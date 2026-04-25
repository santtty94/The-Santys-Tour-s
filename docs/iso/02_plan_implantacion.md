# 02 — Plan de Implantación

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

> **Nota sobre las evidencias:** Los procedimientos descritos en este documento corresponden al entorno de producción real. Las capturas aportadas fueron tomadas en un entorno de laboratorio (AWS Academy + VirtualBox) como evidencia práctica del proyecto intermodular ASIR.

---

## 1. Arquitectura de implantación

The Santy's Tours despliega una infraestructura mixta en AWS con equipos físicos Windows 11 Pro en la oficina:

| Componente | Plataforma | Sistema Operativo | Justificación |
|-----------|-----------|------------------|---------------|
| Servidor de aplicación | AWS EC2 t3.micro | Ubuntu Server 22.04 LTS | Infraestructura cloud del proyecto (coherente con módulo MPO) |
| Base de datos | AWS RDS db.t3.micro | MySQL 8.0 gestionado por AWS | Separación de capas, backups automáticos, alta disponibilidad |
| Almacenamiento multimedia | AWS S3 | Servicio sin servidor | Escalado independiente, coste por uso |
| CDN / DNS / Balanceo | CloudFront + Route 53 + ALB | Servicios gestionados AWS | Alta disponibilidad y baja latencia global |
| Equipos de administración | Equipos físicos de oficina | Windows 11 Pro | Familiaridad del personal, integración con Samba y PuTTY |

> **Nota:** El servidor EC2 no se instala manualmente — AWS lanza la instancia con Ubuntu Server 22.04 LTS preconfigurado. La implantación consiste en el lanzamiento, configuración y puesta en marcha de los servicios.

---

## 2. PARTE A — Servidor: Lanzamiento de instancia EC2 en AWS

### 2.1 Acceso a la consola AWS

1. Acceder a [https://console.aws.amazon.com](https://console.aws.amazon.com) con la cuenta del proyecto
2. Navegar a **EC2** → **Instances** → **Launch Instance**

### 2.2 Configuración de la instancia

| Parámetro | Valor |
|-----------|-------|
| Nombre | `SantysTours-Server` |
| AMI | Ubuntu Server 22.04 LTS (64-bit x86) |
| Tipo de instancia | **t3.micro** (1 vCPU, 1 GB RAM) |
| Par de claves | Crear nuevo par de claves → descargar `.pem` / `.ppk` |
| Almacenamiento | 20 GB SSD (gp3) |

![Configuración de la instancia: nombre SantysTours-Server, AMI Ubuntu 22.04 LTS y tipo t3.micro](capturas/Captura%20de%20pantalla%2001%20y%2002.png)
*Captura 01-02 — Pantalla Launch Instance con nombre, AMI Ubuntu Server 22.04 LTS y tipo t3.micro seleccionados*

### 2.3 Configuración del Security Group

| Tipo | Puerto | Protocolo | Origen | Uso |
|------|--------|-----------|--------|-----|
| SSH | 22 | TCP | IP de administración | Administración remota con PuTTY |
| HTTP | 80 | TCP | Anywhere (0.0.0.0/0) | Portal web |
| HTTPS | 443 | TCP | Anywhere (0.0.0.0/0) | Portal web seguro |
| Custom TCP | 445 | TCP | Red interna de oficina | Samba (compartición de archivos) |

> En producción el puerto SSH (22) debe restringirse a las IPs de los administradores, no a cualquier origen.

![Security Group con las 4 reglas de entrada configuradas](capturas/Captura%20de%20pantalla%2003.png)
*Captura 03 — Security Group con reglas SSH (22), HTTPS (443), HTTP (80) y Samba/TCP (445)*

### 2.4 Lanzamiento y verificación

1. Clic en **Launch Instance** → esperar estado **running** (1-2 minutos)
2. Anotar la **IP pública** asignada — se usará en todos los pasos siguientes
3. En producción: asignar una **Elastic IP** para tener IP pública fija

![Instancia SantysTours-Server en estado running con IP pública y detalle de la instancia](capturas/Captura%20de%20pantalla%2004%20y%2005.png)
*Captura 04-05 — Instancia SantysTours-Server en estado running, IP pública asignada, tipo t3.micro*

### 2.5 Par de claves para PuTTY

Al crear la instancia, AWS genera un par de claves. Para conectar desde Windows con PuTTY:

1. Descargar la clave en formato **.ppk** directamente desde la consola AWS
2. Guardar en el equipo de administración en una ubicación segura (ej: `C:\Keys\`)
3. Esta clave se usará en PuTTY para autenticarse sin contraseña

### 2.6 Primera conexión SSH al servidor con PuTTY

1. Abrir PuTTY → introducir la IP pública del servidor → puerto 22 → tipo SSH
2. Ir a **Connection → SSH → Auth → Credentials** → seleccionar el archivo `.ppk`
3. Guardar la sesión como `SantysTours-Server` → **Open**
4. Login: `ubuntu`
5. Verificar el sistema:

```bash
lsb_release -a
ip a
```

---

## 3. PARTE B — Base de datos: Amazon RDS MySQL

### 3.1 Descripción del servicio

Amazon RDS proporciona la base de datos MySQL 8.0 de The Santy's Tours como servicio totalmente gestionado. AWS gestiona el sistema operativo subyacente, los parches de seguridad y las copias de seguridad automáticas diarias.

### 3.2 Parámetros de configuración

| Parámetro | Valor |
|-----------|-------|
| Motor | MySQL 8.0 |
| Tipo de instancia | **db.t3.micro** |
| Almacenamiento | 20 GB SSD (gp2) |
| Identificador de BD | `santytoursdb` |
| Usuario maestro | `admin` |
| Multi-AZ | Sí (producción) — No (entorno de prueba) |
| Acceso público | **No** — solo accesible desde la EC2 |
| VPC | La misma VPC que la instancia EC2 |

### 3.3 Pasos de lanzamiento en AWS

1. Navegar a **RDS** → **Databases** → **Create database**
2. Método: **Standard create** → Motor: **MySQL** → Versión: **8.0**
3. Plantilla: **Production** (o Free Tier para laboratorio)
4. Identificador: `santytoursdb` → Usuario: `admin` → contraseña segura
5. Instancia: **db.t3.micro** → Almacenamiento: 20 GB SSD
6. Conectividad: VPC = misma que EC2 → Acceso público: **No**
7. Security Group: permitir MySQL (3306/TCP) solo desde el Security Group de la EC2
8. Clic en **Create database** (5-10 minutos)

### 3.4 Endpoint de conexión

Una vez creada, anotar el **endpoint** desde el panel RDS:
```
santytoursdb.xxxxxxxxx.us-east-1.rds.amazonaws.com:3306
```

Este endpoint se configura en el backend Node.js de la instancia EC2.

---

## 4. PARTE C — Almacenamiento: Amazon S3

### 4.1 Descripción del servicio

Amazon S3 almacena todos los archivos multimedia y estáticos: imágenes de tours, fotos de guías, PDFs de reservas y archivos estáticos del portal web.

### 4.2 Creación del bucket

1. Navegar a **S3** → **Create bucket**
2. Nombre: `santystours-media` → Región: `eu-west-1` (Irlanda, para cumplir RGPD)
3. Desbloquear acceso público para archivos estáticos
4. Clic en **Create bucket**

### 4.3 Política de acceso

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::santystours-media/*"
    }
  ]
}
```

---

## 5. PARTE D — Servicios gestionados: ALB, CloudFront y Route 53

Servicios totalmente gestionados por AWS — no requieren instalación de sistema operativo.

### 5.1 Application Load Balancer (ALB)

| Parámetro | Valor |
|-----------|-------|
| Tipo | Application Load Balancer |
| Esquema | Internet-facing |
| Listeners | HTTP (80) → redirect a HTTPS (443) |
| Target Group | Instancias EC2 (puerto 80) |
| Health check | `GET /health` → 200 OK |

### 5.2 Amazon CloudFront

| Parámetro | Valor |
|-----------|-------|
| Origen | Bucket S3 `santystours-media` |
| Protocolo | HTTPS only |
| TTL caché | 86400s imágenes, 0 HTML |
| Función | CDN global — reduce latencia para usuarios internacionales |

### 5.3 Amazon Route 53

| Parámetro | Valor |
|-----------|-------|
| Dominio | `thesantystours.com` |
| Tipo de registro | A — Alias apuntando al ALB |
| TTL | 300 segundos |

---

## 6. PARTE E — Equipos cliente: Instalación de Windows 11 Pro

### 6.1 Especificaciones de los equipos de oficina

The Santy's Tours equipa su oficina con equipos de sobremesa o portátiles con las siguientes características mínimas para ejecutar Windows 11 Pro:

| Componente | Especificación mínima |
|-----------|----------------------|
| CPU | Intel Core i5 de 8ª generación o superior (64-bit, TPM 2.0) |
| RAM | 8 GB |
| Almacenamiento | 256 GB SSD |
| Conexión de red | Ethernet o WiFi con acceso a internet |
| SO a instalar | Windows 11 Pro |

### 6.2 Preparación del medio de instalación (USB booteable)

1. Descargar la **Media Creation Tool** desde [https://www.microsoft.com/software-download/windows11](https://www.microsoft.com/software-download/windows11)
2. Ejecutar la herramienta → seleccionar **Crear medios de instalación**
3. Idioma: **Español (España)** → Edición: **Windows 11** → Arquitectura: **64-bit**
4. Seleccionar **Unidad flash USB** → elegir un USB de mínimo 8 GB
5. La herramienta descarga Windows 11 y crea el USB booteable automáticamente

### 6.3 Arranque desde USB e instalación

1. Conectar el USB booteable al equipo
2. Acceder a la BIOS/UEFI (habitualmente tecla F2, F12 o DEL al arrancar)
3. Cambiar el orden de arranque → USB como primer dispositivo → guardar y reiniciar
4. Seleccionar idioma y región → clic en **Instalar ahora**
5. Introducir la clave de producto Windows 11 Pro (o seleccionar "No tengo clave" para activar después)
6. Seleccionar edición: **Windows 11 Pro** ✅
7. Aceptar los términos de licencia
8. Tipo de instalación: **Personalizada** (instalación limpia)
9. Seleccionar el disco de instalación → formatear si es necesario → **Siguiente**
10. Esperar a que finalice la instalación (15-30 minutos, el equipo reiniciará varias veces)

### 6.4 Configuración inicial post-instalación

1. Seleccionar región: **España** → distribución de teclado: **Español**
2. Conectar a la red de la oficina
3. Configurar cuenta local de administrador: `Admin_SantysTours`
4. Desactivar el requisito de cuenta Microsoft si se solicita

### 6.5 Verificación post-instalación

```
Inicio → Configuración → Sistema → Acerca de
→ Confirmar: Windows 11 Pro
→ Renombrar equipo: SantysTours-Admin-01 (numeración por equipo)
→ Unir al dominio si aplica
```

### 6.6 Instalación de herramientas de administración

En cada equipo Windows 11 Pro de la oficina:

1. Instalar **PuTTY** desde [https://www.putty.org](https://www.putty.org)
2. Copiar la clave privada `.ppk` del servidor EC2 al equipo en `C:\Keys\`
3. Configurar sesión PuTTY (ver `03_configuracion_basica.md`)
4. Verificar conexión SSH al servidor y acceso a las unidades de red Samba

---

## 7. Resumen del plan de implantación

```
┌─────────────────────────────────────────────────────────────────────┐
│                  PLAN DE IMPLANTACIÓN ISO                           │
├──────────────────────────────┬──────────────────────────────────────┤
│  INFRAESTRUCTURA AWS         │  EQUIPOS DE OFICINA                  │
│                              │                                      │
│  1. EC2 — Ubuntu Server      │  1. Preparar USB booteable           │
│     → Launch Instance        │     → Media Creation Tool            │
│     → AMI Ubuntu 22.04       │     → Windows 11 Pro ISO             │
│     → t3.micro               │  2. Instalar Windows 11 Pro          │
│     → Security Group         │     → Boot desde USB                 │
│     → Par de claves .ppk     │     → Instalación limpia             │
│  2. RDS — MySQL 8.0          │     → Edición Pro seleccionada       │
│     → db.t3.micro            │  3. Configurar equipo                │
│     → VPC privada            │     → Nombre: SantysTours-Admin-XX   │
│     → Endpoint de conexión   │     → Cuenta local de admin          │
│  3. S3 — santystours-media   │  4. Instalar herramientas            │
│     → Bucket + política      │     → PuTTY + clave .ppk             │
│     → Estructura de carpetas │     → Conexión SSH al servidor       │
│  4. ALB + CloudFront + R53   │     → Unidades de red Samba          │
│     → Balanceo + CDN + DNS   │                                      │
└──────────────────────────────┴──────────────────────────────────────┘
```

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
