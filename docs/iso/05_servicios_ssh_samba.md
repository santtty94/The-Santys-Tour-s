# 05 — Servicios: SSH y Samba

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

## 1. Contexto del entorno de prueba

| Servicio | Configurado en | Accedido desde |
|---------|---------------|----------------|
| SSH | Servidor Ubuntu en AWS Academy (EC2 t3.micro) | Windows 11 Pro (VirtualBox) mediante **PuTTY** + clave `labsuser.ppk` (vockey) |
| Samba | Servidor Ubuntu en AWS Academy (EC2 t3.micro) | Windows 11 Pro (VirtualBox) mediante el Explorador de archivos |

> En producción real, el acceso SSH y Samba se realizaría desde los equipos físicos Windows 11 Pro de la oficina hacia el servidor en AWS.

---

## 2. Servicio SSH — Acceso remoto con PuTTY

### 2.1 ¿Por qué SSH con PuTTY?

PuTTY permite al personal técnico de The Santy's Tours administrar el servidor Ubuntu en AWS Academy de forma remota y segura desde los equipos Windows 11 Pro, sin acceso físico al servidor.

### 2.2 Verificar SSH activo en el servidor

Conectarse al servidor por PuTTY y ejecutar:

```bash
sudo systemctl status ssh
```

![systemctl status ssh mostrando el servicio active running](capturas/Captura%20de%20pantalla%2015.png)
*Captura 15 — ssh.service active (running) — OpenBSD Secure Shell server activo desde el arranque de la instancia*

> **Nota:** Samba (`smbd.service`) no aparece como instalado en esta captura — se configurará en el paso 3 de este documento.

### 2.3 Hardening de la configuración SSH

```bash
sudo nano /etc/ssh/sshd_config
```

Parámetros a modificar:

```bash
# No permitir login directo como root
PermitRootLogin no

# Tiempo máximo para autenticarse
LoginGraceTime 30

# Máximo de intentos de contraseña
MaxAuthTries 3

# Solo permitir usuarios autorizados
AllowUsers ubuntu admin_tours

# Desactivar autenticación por contraseña vacía
PermitEmptyPasswords no

# Banner de advertencia
Banner /etc/ssh/banner.txt
```

### 2.4 Crear banner de advertencia

```bash
sudo nano /etc/ssh/banner.txt
```

Contenido:

```
************************************************************
*        THE SANTY'S TOURS — SERVIDOR INTERNO             *
*                                                          *
*  Acceso restringido solo a personal autorizado.         *
*  Toda actividad en este sistema es monitorizada.        *
*  Acceso no autorizado está prohibido y perseguido.      *
************************************************************
```

### 2.5 Aplicar cambios

```bash
sudo systemctl restart ssh
```

### 2.6 Conexión desde Windows 11 Pro con PuTTY

#### Clave SSH del laboratorio AWS Academy

En AWS Academy el par de claves es **vockey**. La clave privada se descarga directamente desde el panel del laboratorio en formato **.ppk** (listo para PuTTY):

1. Panel AWS Academy → **Download PPK** → guardar como `labsuser.ppk` en `C:\Keys\`

#### Abrir la sesión guardada en PuTTY

1. Abrir **PuTTY** en la VM Windows 11 Pro
2. Seleccionar la sesión guardada `SantysTours-Server`
3. Clic en **Open**
4. Primer acceso → aviso de clave del host → **Accept**
5. **login as:** `ubuntu`
6. Conexión establecida con `labsuser.ppk` sin contraseña
7. El banner de The Santy's Tours aparece al conectarse

### 2.7 Verificación del servicio SSH

```bash
sudo systemctl status ssh
sudo ss -tlnp | grep :22
sudo journalctl -u ssh -n 20
```

---

## 3. Servicio Samba — Compartición de archivos con Windows 11 Pro

### 3.1 ¿Por qué Samba?

Samba permite que los equipos **Windows 11 Pro** de la oficina accedan a las carpetas del servidor Ubuntu en AWS Academy como **unidades de red**, directamente desde el Explorador de archivos de Windows.

### 3.2 Instalación de Samba

```bash
sudo apt install samba -y
smbd --version
```

### 3.3 Copia de seguridad de la configuración original

```bash
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.backup
```

### 3.4 Configuración de Samba

```bash
sudo nano /etc/samba/smb.conf
```

```ini
[global]
   workgroup = SANTYGROUP
   server string = The Santy's Tours - Servidor de Archivos
   server role = standalone server
   log file = /var/log/samba/log.%m
   max log size = 1000
   logging = file
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   pam password change = yes
   map to guest = bad user
   usershare allow guests = no

# Carpeta para empleados (lectura/escritura)
[documentos]
   comment = Documentos The Santy's Tours
   path = /srv/santysTours/documentos
   valid users = @tours_staff @tours_admin
   read only = no
   browseable = yes
   create mask = 0660
   directory mask = 0770

# Carpeta de rutas (solo lectura)
[rutas]
   comment = Rutas y Tours
   path = /srv/santysTours/rutas
   valid users = @tours_guias @tours_staff @tours_admin
   read only = yes
   browseable = yes

# Carpeta pública
[publico]
   comment = Información pública
   path = /srv/santysTours/publico
   valid users = @tours_readonly @tours_staff @tours_guias @tours_admin
   read only = yes
   browseable = yes
```

### 3.5 Registrar usuarios en Samba

```bash
sudo smbpasswd -a ubuntu
sudo smbpasswd -a admin_tours
sudo smbpasswd -a empleado
sudo smbpasswd -a guia
sudo smbpasswd -a readonly
```

### 3.6 Verificar y arrancar Samba

```bash
sudo testparm
sudo systemctl restart smbd nmbd
sudo systemctl enable smbd nmbd
sudo systemctl status smbd
```

### 3.7 Firewall para Samba

El puerto 445 (TCP) está abierto a través del **Security Group** de AWS Academy configurado durante el lanzamiento de la instancia. Adicionalmente en UFW:

```bash
sudo ufw allow samba
sudo ufw status | grep -i samba
```

---

## 4. Acceso Samba desde Windows 11 Pro

### 4.1 Explorador de archivos

1. Abrir el **Explorador de archivos** en la VM Windows 11 Pro
2. En la barra de dirección escribir:
```
\\IP_PUBLICA_AWS
```
3. Introducir credenciales Samba: usuario `empleado` / contraseña configurada en el servidor
4. Se muestran los recursos compartidos: `documentos`, `rutas`, `publico`

### 4.2 Mapear unidad de red permanente

1. Clic derecho en `documentos` → **Conectar a unidad de red**
2. Asignar letra (ej: Z:)
3. Marcar **Volver a conectar al iniciar sesión**
4. Introducir credenciales Samba → **Finalizar**

---

## 5. Resumen de servicios configurados

| Servicio | Puerto | Estado | Cliente | Función |
|---------|--------|--------|---------|---------|
| SSH (OpenSSH) | 22/TCP | ✅ Activo | PuTTY + `labsuser.ppk` (vockey) | Administración remota del servidor |
| Samba (SMB) | 445/TCP | ✅ Activo | Explorador de Windows | Compartición de carpetas en red |
| Samba (NetBIOS) | 137–139/UDP | ✅ Activo | Automático | Descubrimiento de red |

---

## 6. Comandos de mantenimiento

```bash
sudo systemctl status ssh smbd nmbd
sudo smbstatus
sudo journalctl -u ssh -f
sudo tail -f /var/log/samba/log.smbd
```

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
