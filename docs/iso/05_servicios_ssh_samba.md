# 05 — Servicios: SSH y Samba

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

## 1. Servicio SSH — Acceso remoto seguro

### 1.1 ¿Por qué SSH?

SSH (Secure Shell) permite administrar el servidor de The Santy's Tours de forma remota y segura. Es imprescindible para:

- Administración del servidor desde los equipos cliente **Windows 11 Pro** sin necesidad de acceso físico (usando Windows Terminal, PuTTY o MobaXterm)
- Despliegue del portal web desde el equipo de desarrollo
- Conexión desde el entorno cloud de AWS (módulo MPO)
- Transferencia segura de archivos con `scp` o `sftp`

### 1.2 Verificar que OpenSSH está instalado

```bash
sudo systemctl status ssh
```

Si no está activo:

```bash
sudo apt install openssh-server -y
sudo systemctl enable ssh
sudo systemctl start ssh
```

### 1.3 Configuración de seguridad SSH

```bash
sudo nano /etc/ssh/sshd_config
```

Parámetros a modificar:

```bash
# Puerto estándar
Port 22

# No permitir login directo como root
PermitRootLogin no

# Tiempo máximo para autenticarse
LoginGraceTime 30

# Máximo de intentos de contraseña
MaxAuthTries 3

# Solo permitir usuarios autorizados
AllowUsers admin_tours empleado

# Desactivar autenticación por contraseña vacía
PermitEmptyPasswords no

# Banner de advertencia
Banner /etc/ssh/banner.txt
```

### 1.4 Crear banner de advertencia

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

### 1.5 Aplicar cambios

```bash
sudo systemctl restart ssh
```

### 1.6 Conexión SSH desde Windows 11 Pro

Desde Windows Terminal o PowerShell en los equipos cliente:

```powershell
ssh admin_tours@192.168.1.100
```

Debe mostrar el banner y solicitar la contraseña.

### 1.7 Configuración de claves SSH (acceso sin contraseña)

En el equipo Windows 11 Pro cliente:

```powershell
# Generar par de claves
ssh-keygen -t ed25519 -C "admin_santysTours"

# Copiar clave pública al servidor
ssh-copy-id admin_tours@192.168.1.100
```

Verificar que el acceso por clave funciona y luego deshabilitar autenticación por contraseña:

```bash
# En /etc/ssh/sshd_config del servidor:
PasswordAuthentication no
```

```bash
sudo systemctl restart ssh
```

### 1.8 Verificación del servicio SSH

```bash
# Estado del servicio
sudo systemctl status ssh

# Puerto escuchando
sudo ss -tlnp | grep :22

# Logs de conexión
sudo journalctl -u ssh -n 20
```

---

## 2. Servicio Samba — Compartición de archivos con Windows 11 Pro

### 2.1 ¿Por qué Samba?

Samba permite compartir carpetas del servidor Ubuntu con los equipos cliente **Windows 11 Pro** de la red local. Los empleados y guías podrán acceder a los documentos directamente desde el Explorador de Windows como unidades de red, sin necesidad de usar SSH ni herramientas adicionales.

### 2.2 Instalación de Samba

```bash
sudo apt install samba -y
smbd --version
```

### 2.3 Copia de seguridad de la configuración original

```bash
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.backup
```

### 2.4 Configuración de Samba

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

# Carpeta de rutas (solo lectura para guías y empleados)
[rutas]
   comment = Rutas y Tours
   path = /srv/santysTours/rutas
   valid users = @tours_guias @tours_staff @tours_admin
   read only = yes
   browseable = yes

# Carpeta pública (todos los usuarios pueden ver)
[publico]
   comment = Información pública
   path = /srv/santysTours/publico
   valid users = @tours_readonly @tours_staff @tours_guias @tours_admin
   read only = yes
   browseable = yes
```

### 2.5 Agregar usuarios a Samba

```bash
sudo smbpasswd -a admin_tours
sudo smbpasswd -a empleado
sudo smbpasswd -a guia
sudo smbpasswd -a readonly
```

### 2.6 Verificar la configuración

```bash
sudo testparm
```

### 2.7 Reiniciar y habilitar Samba

```bash
sudo systemctl restart smbd nmbd
sudo systemctl enable smbd nmbd
```

### 2.8 Permitir Samba en el firewall

```bash
sudo ufw allow samba
sudo ufw status | grep -i samba
```

---

## 3. Acceso desde Windows 11 Pro

Los equipos cliente Windows 11 Pro acceden al servidor de dos formas:

### 3.1 Explorador de Windows — Unidades de red

1. Abrir el Explorador de archivos
2. En la barra de dirección escribir: `\\192.168.1.100`
3. Introducir las credenciales del usuario Samba (ej: `empleado` / su contraseña)
4. Se muestran los recursos compartidos: `documentos`, `rutas`, `publico`
5. Hacer clic derecho → `Conectar a unidad de red` para mapearla de forma permanente

### 3.2 Mapear unidad de red desde PowerShell

```powershell
# Mapear documentos como unidad Z:
net use Z: \\192.168.1.100\documentos /user:empleado /persistent:yes
```

---

## 4. Verificación del acceso Samba

Desde el servidor:

```bash
# Ver recursos compartidos disponibles
smbclient -L localhost -U admin_tours

# Ver usuarios conectados
sudo smbstatus
```

---

## 5. Resumen de servicios configurados

| Servicio | Puerto | Protocolo | Estado | Función |
|---------|--------|-----------|--------|---------|
| SSH (OpenSSH) | 22 | TCP | ✅ Activo | Administración remota desde Windows 11 Pro |
| Samba (SMB) | 445 | TCP | ✅ Activo | Compartición de archivos con Windows 11 Pro |
| Samba (NetBIOS) | 137–139 | UDP | ✅ Activo | Descubrimiento de red |

05_servicios_ssh_samba.md
## 6. Comandos de mantenimiento

```bash
# Estado de todos los servicios
sudo systemctl status ssh smbd nmbd

# Usuarios conectados por Samba
sudo smbstatus

# Logs de SSH en tiempo real
sudo journalctl -u ssh -f

# Logs de Samba
sudo tail -f /var/log/samba/log.smbd
```

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
