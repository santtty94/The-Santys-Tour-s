# 05 — Servicios: SSH y Samba

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

> **Nota sobre las evidencias:** Los procedimientos descritos corresponden al entorno de producción real. Las capturas aportadas fueron tomadas en un entorno de laboratorio (AWS Academy + VirtualBox) como evidencia práctica del proyecto intermodular ASIR.

---

## 1. Servicios configurados

| Servicio | Configurado en | Accedido desde |
|---------|---------------|----------------|
| SSH | Servidor Ubuntu en AWS EC2 | Equipos físicos Windows 11 Pro de la oficina mediante **PuTTY** |
| Samba | Servidor Ubuntu en AWS EC2 | Equipos físicos Windows 11 Pro mediante el Explorador de archivos |

---

## 2. Servicio SSH — Acceso remoto con PuTTY

### 2.1 ¿Por qué SSH con PuTTY?

PuTTY permite al personal técnico de The Santy's Tours administrar el servidor Ubuntu en AWS de forma remota y segura desde los equipos Windows 11 Pro de la oficina, sin necesidad de acceso físico al servidor.

Casos de uso:
- Administración del servidor desde los equipos de oficina
- Despliegue y mantenimiento del portal web
- Gestión de usuarios, permisos y servicios

### 2.2 Verificar SSH activo en el servidor

Conectarse al servidor por PuTTY y ejecutar:

```bash
sudo systemctl status ssh
```

![systemctl status ssh mostrando el servicio active running](capturas/Captura%20de%20pantalla%2015.png)
*Captura 15 — ssh.service active (running) — OpenBSD Secure Shell server activo*

Si no está activo:
```bash
sudo apt install openssh-server -y
sudo systemctl enable ssh
sudo systemctl start ssh
```

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

#### Clave privada para autenticación SSH

La clave privada se descarga desde la consola AWS al crear la instancia EC2 en formato **.ppk** (listo para PuTTY). Se guarda en cada equipo de administración en `C:\Keys\`.

#### Abrir la sesión guardada en PuTTY

1. Abrir **PuTTY** en el equipo Windows 11 Pro de la oficina
2. Seleccionar la sesión guardada `SantysTours-Server`
3. Clic en **Open**
4. Primer acceso → aviso de clave del host → **Accept**
5. **login as:** `ubuntu`
6. Conexión establecida — el banner de The Santy's Tours aparece en pantalla

### 2.7 Verificación del servicio SSH

```bash
sudo systemctl status ssh
sudo ss -tlnp | grep :22
sudo journalctl -u ssh -n 20
```

---

## 3. Servicio Samba — Compartición de archivos con Windows 11 Pro

### 3.1 ¿Por qué Samba?

Samba permite que los equipos **Windows 11 Pro** de la oficina accedan a las carpetas del servidor Ubuntu como **unidades de red**, directamente desde el Explorador de archivos de Windows sin herramientas adicionales.

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

[documentos]
   comment = Documentos The Santy's Tours
   path = /srv/santysTours/documentos
   valid users = @tours_staff @tours_admin
   read only = no
   browseable = yes
   create mask = 0660
   directory mask = 0770

[rutas]
   comment = Rutas y Tours
   path = /srv/santysTours/rutas
   valid users = @tours_guias @tours_staff @tours_admin
   read only = yes
   browseable = yes

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

El puerto 445 (TCP) está abierto a través del **Security Group** de AWS. Adicionalmente en UFW:
```bash
sudo ufw allow samba
sudo ufw status | grep -i samba
```

---

## 4. Acceso Samba desde Windows 11 Pro

### 4.1 Explorador de archivos

1. Abrir el **Explorador de archivos** en el equipo Windows 11 Pro
2. En la barra de dirección escribir:
```
\\thesantystours.com
```
o usando la IP pública del servidor si Route 53 no está configurado.

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
| SSH (OpenSSH) | 22/TCP | ✅ Activo | PuTTY con clave privada AWS | Administración remota del servidor |
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
