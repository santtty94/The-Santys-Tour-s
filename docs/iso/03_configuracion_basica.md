# 03 — Configuración Básica del Sistema

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

## 1. Contexto del entorno de prueba

| Componente | Entorno de prueba | Entorno real (producción futura) |
|-----------|------------------|----------------------------------|
| Servidor | AWS Academy (laboratorio para estudiantes) | AWS cuenta de producción |
| Equipos cliente | Windows 11 Pro en VirtualBox | Equipos físicos Windows 11 Pro |
| Acceso remoto | PuTTY desde VM Windows → AWS Academy | PuTTY desde equipos físicos → AWS producción |

---

## 2. PARTE A — Servidor Ubuntu Server en AWS Academy

> Todos los comandos se ejecutan conectado al servidor mediante **PuTTY**. Ver sección 3 para la configuración de PuTTY.

### 2.1 Nombre del equipo (hostname)

```bash
sudo hostnamectl set-hostname santyserver
hostname
```

Verificar en `/etc/hosts`:
```bash
cat /etc/hosts
```

### 2.2 Red en AWS Academy

En AWS Academy la red es gestionada por AWS. No se configura Netplan ni IP estática manualmente.

- **IP privada** fija dentro de la VPC
- **IP pública** dinámica (usar Elastic IP en producción)

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
```

### 2.5 Actualizaciones del sistema

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

### 2.6 Firewall — UFW

```bash
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow samba
sudo ufw enable
sudo ufw status verbose
```

![Resultado de ufw status verbose con puertos 22, 80 y 443 activos](capturas/Captura%20de%20pantalla%2012.png)
*Captura 12 — UFW activo con reglas SSH (22), HTTP (80) y HTTPS (443). El puerto 445 (Samba) está abierto a través del Security Group de AWS.*

### 2.7 Resumen de configuración del servidor

| Parámetro | Valor |
|-----------|-------|
| Hostname | `santyserver` |
| IP privada (VPC) | Asignada automáticamente por AWS |
| IP pública | Asignada por AWS Academy (dinámica) |
| Zona horaria | `Europe/Madrid (CEST)` |
| Locale | `es_ES.UTF-8` |
| Firewall | Security Group AWS + UFW activo |
| Actualizaciones automáticas | Activadas (`unattended-upgrades`) |

---


---

## 3. PARTE B — Configuración de Amazon RDS MySQL

Amazon RDS no requiere configuración de sistema operativo — AWS lo gestiona completamente. La configuración básica consiste en establecer los parámetros de conexión, seguridad y rendimiento de la base de datos.

### 3.1 Verificar conectividad EC2 → RDS

Desde la sesión PuTTY conectada al servidor EC2, verificar que la instancia EC2 puede alcanzar la base de datos RDS:

```bash
# Instalar cliente MySQL
sudo apt install mysql-client -y

# Probar conexión al endpoint RDS
mysql -h santytoursdb.xxxxxxxxx.us-east-1.rds.amazonaws.com -u admin -p
```

Si la conexión es exitosa, aparecerá el prompt de MySQL:
```
Welcome to the MySQL monitor...
mysql>
```

### 3.2 Crear la base de datos y usuario de aplicación

Una vez conectado al servidor MySQL de RDS:

```sql
-- Crear base de datos del proyecto
CREATE DATABASE santytoursdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Crear usuario específico para la aplicación (principio de mínimo privilegio)
CREATE USER 'santyapp'@'%' IDENTIFIED BY 'ContraseñaSegura123!';

-- Otorgar permisos solo sobre la base de datos del proyecto
GRANT SELECT, INSERT, UPDATE, DELETE ON santytoursdb.* TO 'santyapp'@'%';

FLUSH PRIVILEGES;
SHOW DATABASES;
```

### 3.3 Configuración del Security Group de RDS

Verificar que el Security Group de RDS permite la conexión desde EC2:

| Tipo | Puerto | Origen |
|------|--------|--------|
| MySQL/Aurora | 3306/TCP | Security Group de la instancia EC2 |

> **Importante:** El puerto 3306 de RDS **no debe estar abierto a internet** (0.0.0.0/0). Solo debe aceptar conexiones desde el Security Group de la EC2.

### 3.4 Configurar conexión en el backend Node.js (EC2)

En la instancia EC2, configurar las variables de entorno de conexión a RDS:

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

### 3.5 Resumen de configuración RDS

| Parámetro | Valor |
|-----------|-------|
| Endpoint | `santytoursdb.xxxxxxxxx.us-east-1.rds.amazonaws.com` |
| Puerto | 3306 |
| Motor | MySQL 8.0 |
| Base de datos | `santytoursdb` |
| Usuario aplicación | `santyapp` |
| Acceso | Solo desde Security Group EC2 |
| Backups automáticos | Activados por AWS (7 días de retención) |

---

## 4. PARTE C — Configuración de Amazon S3

### 4.1 Estructura de carpetas en el bucket

Una vez creado el bucket `santystours-media`, organizar el contenido con la siguiente estructura:

```
santystours-media/
├── tours/          → Imágenes de los tours (JPG, WebP)
├── guias/          → Fotografías de perfil de los guías
├── docs/           → PDFs de confirmación de reservas
└── static/         → Archivos estáticos del portal (CSS, JS, fuentes)
```

Crear las carpetas desde la consola AWS S3 → bucket → **Create folder**.

### 4.2 Subir archivos desde EC2 usando AWS CLI

Instalar AWS CLI en la instancia EC2:

```bash
sudo apt install awscli -y
aws --version
```

Configurar credenciales (en AWS Academy usar las credenciales del laboratorio):

```bash
aws configure
# AWS Access Key ID: [de las credenciales del laboratorio]
# AWS Secret Access Key: [de las credenciales del laboratorio]
# Default region: us-east-1
# Default output format: json
```

Subir un archivo de prueba:

```bash
echo "test" > test.txt
aws s3 cp test.txt s3://santystours-media/static/test.txt
aws s3 ls s3://santystours-media/
```

### 4.3 Configurar CORS en S3

Para que el portal web pueda acceder a los archivos desde el navegador, configurar CORS en el bucket:

1. S3 → bucket `santystours-media` → **Permissions** → **Cross-origin resource sharing (CORS)**
2. Añadir la siguiente configuración:

```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["GET"],
    "AllowedOrigins": ["*"],
    "ExposeHeaders": []
  }
]
```

### 4.4 Resumen de configuración S3

| Parámetro | Valor |
|-----------|-------|
| Nombre del bucket | `santystours-media` |
| Región | `us-east-1` |
| Acceso público | Activado para archivos estáticos |
| CORS | Configurado para GET desde cualquier origen |
| Estructura | tours/, guias/, docs/, static/ |

---

## 5. PARTE D — Cliente Windows 11 Pro en VirtualBox

### 5.1 Nombre del equipo

1. Inicio → Configuración → Sistema → Acerca de → **Cambiar nombre de este equipo**
2. Establecer: `SantysTours-Admin` → Reiniciar

### 5.2 Zona horaria

Inicio → Configuración → Hora e idioma → Fecha y hora → **(UTC+01:00) Madrid**

### 5.3 Red

La VM usa adaptador **NAT** de VirtualBox. No requiere configuración adicional.

### 5.4 Instalación y configuración de PuTTY

#### 3.4.1 Descarga e instalación

Descargar desde [https://www.putty.org](https://www.putty.org) → instalar.

#### 3.4.2 Obtener la clave privada desde AWS Academy

En AWS Academy el par de claves es **vockey**. Descargar directamente desde el panel del laboratorio:

- Panel AWS Academy → **Download PPK** → guardar `labsuser.ppk` en `C:\Keys\`

> No es necesario usar PuTTYgen — AWS Academy proporciona el .ppk directamente.

#### 3.4.3 Configurar la sesión SSH en PuTTY

1. Abrir **PuTTY**
2. **Host Name**: IP pública AWS Academy / **Port**: 22 / **SSH**

![PuTTY configurado con IP del servidor 100.31.58.43, puerto 22, tipo SSH](capturas/Captura%20de%20pantalla%2006.png)
*Captura 06 — PuTTY Session con IP pública 100.31.58.43, puerto 22, conexión SSH*

3. **Connection → SSH → Auth → Credentials** → seleccionar `labsuser.ppk`

![PuTTY Auth Credentials con labsuser.ppk seleccionado](capturas/Captura%20de%20pantalla%2007.png)
*Captura 07 — PuTTY SSH → Auth → Credentials con labsuser.ppk cargado*

4. **Session** → **Saved Sessions**: `SantysTours-Server` → **Save**

#### 3.4.4 Conectar al servidor

1. Sesión `SantysTours-Server` → **Open**
2. Aviso de clave del host → **Accept**

![PuTTY Security Alert al conectar por primera vez](capturas/Captura%20de%20pantalla%2008.png)
*Captura 08 — PuTTY Security Alert, se acepta la clave del host*

3. **login as:** `ubuntu` → conexión establecida con banner de The Santy's Tours

![Sesión PuTTY conectada mostrando el banner y el prompt ubuntu@ip](capturas/Captura%20de%20pantalla%2009.png)
*Captura 09 — Sesión PuTTY activa: banner "The Santy's Tours — Servidor Interno" y Ubuntu 22.04.5 LTS*

4. Verificar versión:
```bash
lsb_release -a
```

![lsb_release -a mostrando Ubuntu 22.04.5 LTS codename jammy](capturas/Captura%20de%20pantalla%2010.png)
*Captura 10 — lsb_release -a confirmando Ubuntu 22.04.5 LTS (jammy)*

### 5.5 Resumen de configuración del cliente

| Parámetro | Valor |
|-----------|-------|
| Nombre del equipo | `SantysTours-Admin` |
| Zona horaria | `(UTC+01:00) Madrid` |
| Red | NAT (VirtualBox) → AWS Academy |
| Clave SSH | `labsuser.ppk` (vockey de AWS Academy) |
| Cliente SSH | PuTTY — sesión `SantysTours-Server` |
| Acceso Samba | `\\IP_PUBLICA` desde Explorador de Windows |

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
