# 03 — Configuración Básica del Sistema

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

> **Nota sobre las evidencias:** Los procedimientos descritos corresponden al entorno de producción real. Las capturas aportadas fueron tomadas en un entorno de laboratorio (AWS Academy + VirtualBox) como evidencia práctica del proyecto intermodular ASIR.

---

## 1. Alcance de este documento

Este documento cubre la configuración básica de todos los sistemas de la infraestructura de The Santy's Tours:

| Sistema | Plataforma | Configuración aplicada |
|---------|-----------|----------------------|
| Servidor Ubuntu Server 22.04 LTS | AWS EC2 | Hostname, zona horaria, locale, actualizaciones, firewall |
| Base de datos MySQL 8.0 | AWS RDS | Conexión, usuario de aplicación, seguridad |
| Almacenamiento | AWS S3 | Estructura, permisos, AWS CLI, CORS |
| Equipos cliente | Windows 11 Pro (equipos físicos) | Nombre, zona horaria, red, PuTTY, Samba |

---

## 2. PARTE A — Servidor Ubuntu Server en AWS EC2

> Todos los comandos se ejecutan conectado al servidor mediante **PuTTY** con la clave privada descargada de AWS. Ver sección 5 para la configuración de PuTTY.

### 2.1 Nombre del equipo (hostname)

```bash
sudo hostnamectl set-hostname santyserver
hostname
```

Verificar en `/etc/hosts`:
```bash
cat /etc/hosts
```

Debe contener:
```
127.0.0.1   localhost
127.0.1.1   santyserver
```

### 2.2 Red en AWS EC2

En AWS EC2, la red es gestionada completamente por AWS. No se configura Netplan ni IP estática manualmente. AWS asigna:
- **IP privada** fija dentro de la VPC
- **IP pública** (asignar una **Elastic IP** en producción para tener IP fija)

Verificar la red:
```bash
ip a
curl -s http://169.254.169.254/latest/meta-data/public-ipv4
```

### 2.3 Zona horaria

```bash
sudo timedatectl set-timezone Europe/Madrid
timedatectl
```

![Resultado de timedatectl mostrando Europe/Madrid CEST +0200](capturas/Captura%20de%20pantalla%2011.png)
*Captura 11 — timedatectl confirmando zona horaria Europe/Madrid (CEST, +0200)*

### 2.4 Localización del sistema

```bash
sudo locale-gen es_ES.UTF-8
sudo update-locale LANG=es_ES.UTF-8
locale -a | grep es_ES
```

### 2.5 Actualizaciones del sistema

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

### 2.6 Firewall — UFW

La primera línea de defensa es el **Security Group** de AWS. UFW actúa como segunda capa dentro de la instancia:

```bash
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow samba
sudo ufw enable
sudo ufw status verbose
```

![Resultado de ufw status verbose con puertos 22, 80 y 443 activos](capturas/Captura%20de%20pantalla%2012.png)
*Captura 12 — UFW activo con reglas SSH (22), HTTP (80) y HTTPS (443). El puerto 445 (Samba) se gestiona a través del Security Group de AWS.*

### 2.7 Resumen de configuración del servidor

| Parámetro | Valor |
|-----------|-------|
| Hostname | `santyserver` |
| IP pública | Elastic IP fija (producción) |
| Zona horaria | `Europe/Madrid (CEST)` |
| Locale | `es_ES.UTF-8` |
| Firewall | Security Group AWS + UFW activo |
| Actualizaciones automáticas | Activadas |

---

## 3. PARTE B — Configuración de Amazon RDS MySQL

Amazon RDS no requiere configuración de sistema operativo — AWS lo gestiona completamente.

### 3.1 Verificar conectividad EC2 → RDS

Desde la sesión PuTTY conectada al servidor EC2:

```bash
sudo apt install mysql-client -y
mysql -h santytoursdb.xxxxxxxxx.us-east-1.rds.amazonaws.com -u admin -p
```

Conexión exitosa:
```
Welcome to the MySQL monitor...
mysql>
```

### 3.2 Crear base de datos y usuario de aplicación

```sql
CREATE DATABASE santytoursdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER 'santyapp'@'%' IDENTIFIED BY 'ContraseñaSegura123!';

GRANT SELECT, INSERT, UPDATE, DELETE ON santytoursdb.* TO 'santyapp'@'%';

FLUSH PRIVILEGES;
SHOW DATABASES;
```

### 3.3 Configurar conexión en el backend Node.js

```bash
sudo nano /etc/environment
```

Añadir:
```bash
DB_HOST="santytoursdb.xxxxxxxxx.us-east-1.rds.amazonaws.com"
DB_PORT="3306"
DB_NAME="santytoursdb"
DB_USER="santyapp"
DB_PASS="ContraseñaSegura123!"
```

### 3.4 Resumen de configuración RDS

| Parámetro | Valor |
|-----------|-------|
| Endpoint | `santytoursdb.xxxxxxxxx.us-east-1.rds.amazonaws.com` |
| Puerto | 3306 |
| Base de datos | `santytoursdb` |
| Usuario app | `santyapp` |
| Acceso | Solo desde Security Group EC2 |
| Backups | Automáticos por AWS (7 días) |

---

## 4. PARTE C — Configuración de Amazon S3

### 4.1 Estructura de carpetas en el bucket

```
santystours-media/
├── tours/     → Imágenes de los tours
├── guias/     → Fotografías de perfil de los guías
├── docs/      → PDFs de confirmación de reservas
└── static/    → Archivos estáticos del portal (CSS, JS, fuentes)
```

### 4.2 Subir archivos desde EC2 usando AWS CLI

```bash
sudo apt install awscli -y
aws configure
# Introducir credenciales AWS, región us-east-1
aws s3 cp test.txt s3://santystours-media/static/test.txt
aws s3 ls s3://santystours-media/
```

### 4.3 Configurar CORS en S3

En S3 → bucket `santystours-media` → **Permissions** → **CORS**:

```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["GET"],
    "AllowedOrigins": ["https://thesantystours.com"],
    "ExposeHeaders": []
  }
]
```

---

## 5. PARTE D — Equipos cliente Windows 11 Pro

Los equipos de administración de la oficina son máquinas físicas con Windows 11 Pro instalado desde USB booteable (ver `02_plan_implantacion.md`).

### 5.1 Nombre del equipo

1. Inicio → Configuración → Sistema → Acerca de → **Cambiar nombre de este equipo**
2. Establecer: `SantysTours-Admin-01` (numeración por equipo)
3. Reiniciar para aplicar el cambio

### 5.2 Zona horaria

1. Inicio → Configuración → Hora e idioma → Fecha y hora
2. Zona horaria: **(UTC+01:00) Madrid**
3. Activar **Establecer la hora automáticamente**

### 5.3 Red

Conectar el equipo a la red de la oficina. Verificar conectividad con el servidor:
```powershell
ping IP_PUBLICA_SERVIDOR
```

### 5.4 Instalación y configuración de PuTTY

PuTTY es el cliente SSH para administrar el servidor Ubuntu desde los equipos Windows de la oficina.

#### 5.4.1 Descarga e instalación

1. Descargar desde [https://www.putty.org](https://www.putty.org) → **putty-64bit-X.XX-installer.msi**
2. Ejecutar el instalador

#### 5.4.2 Clave privada para autenticación

La clave privada en formato `.ppk` se descarga desde la consola AWS al crear la instancia EC2. Guardarla en `C:\Keys\` en cada equipo de administración.

#### 5.4.3 Configurar sesión SSH en PuTTY

1. Abrir **PuTTY**
2. **Host Name**: IP pública del servidor AWS (o dominio Route 53)
3. **Port**: 22 / **Connection type**: SSH

![PuTTY configurado con IP del servidor, puerto 22, tipo SSH](capturas/Captura%20de%20pantalla%2006.png)
*Captura 06 — PuTTY Session con IP pública, puerto 22, conexión SSH*

4. **Connection → SSH → Auth → Credentials** → seleccionar `C:\Keys\labsuser.ppk`

![PuTTY Auth Credentials con clave privada cargada](capturas/Captura%20de%20pantalla%2007.png)
*Captura 07 — PuTTY SSH → Auth → Credentials con clave privada cargada*

5. Volver a **Session** → **Saved Sessions**: `SantysTours-Server` → **Save**

#### 5.4.4 Conectar al servidor

1. Seleccionar sesión → **Open**
2. Primer acceso: aviso de clave del host → **Accept**

![PuTTY Security Alert al conectar por primera vez](capturas/Captura%20de%20pantalla%2008.png)
*Captura 08 — PuTTY Security Alert, se acepta la clave del host*

3. **login as:** `ubuntu`
4. El banner de The Santy's Tours aparece al conectarse

![Sesión PuTTY activa con banner de The Santy's Tours](capturas/Captura%20de%20pantalla%2009.png)
*Captura 09 — Sesión PuTTY activa: banner "The Santy's Tours — Servidor Interno" y bienvenida Ubuntu 22.04.5 LTS*

```bash
lsb_release -a
```

![lsb_release -a mostrando Ubuntu 22.04.5 LTS](capturas/Captura%20de%20pantalla%2010.png)
*Captura 10 — lsb_release -a confirmando Ubuntu 22.04.5 LTS (jammy)*

### 5.5 Resumen de configuración del cliente

| Parámetro | Valor |
|-----------|-------|
| Nombre del equipo | `SantysTours-Admin-01` |
| Zona horaria | `(UTC+01:00) Madrid` |
| Red | Ethernet/WiFi de la oficina |
| Cliente SSH | PuTTY con clave privada AWS |
| Acceso Samba | `\\IP_SERVIDOR` desde el Explorador de Windows |

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
