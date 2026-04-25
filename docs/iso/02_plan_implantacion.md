# 02 — Plan de Implantación

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

## 1. Arquitectura de implantación

The Santy's Tours utiliza una infraestructura mixta que separa claramente el rol del servidor y de los clientes:

| Componente | Plataforma | Sistema Operativo | Justificación |
|-----------|-----------|------------------|---------------|
| Servidor de producción | AWS Academy (EC2 t3.micro) | Ubuntu Server 22.04 LTS | Infraestructura cloud del proyecto (coherente con módulo MPO) |
| Equipos de administración | VirtualBox 7.x (Lenovo Legion 5) | Windows 11 Pro | Entorno de cliente simulado para demostrar configuración e integración |

> **Nota:** El servidor no se instala manualmente. AWS lanza una instancia EC2 con Ubuntu Server 22.04 LTS preconfigurado. El proceso de implantación consiste en el lanzamiento, configuración y puesta en marcha de dicha instancia.

---

## 2. PARTE A — Servidor: Lanzamiento de instancia EC2 en AWS Academy

### 2.1 Acceso a la consola AWS Academy

1. Acceder al laboratorio de AWS Academy e iniciar la sesión de laboratorio
2. Clic en **AWS** para abrir la consola
3. Navegar a **EC2** → **Instances** → **Launch Instance**

### 2.2 Configuración de la instancia

| Parámetro | Valor |
|-----------|-------|
| Nombre | `SantysTours-Server` |
| AMI | Ubuntu Server 22.04 LTS (64-bit x86) |
| Tipo de instancia | **t3.micro** (1 vCPU, 1 GB RAM) |
| Par de claves | **vockey** *(par de claves por defecto del laboratorio AWS Academy)* |
| Almacenamiento | 20 GB SSD (gp3) |

> **Sobre el par de claves vockey:** En AWS Academy el par de claves `vockey` ya existe en el laboratorio y no es necesario crearlo. La clave privada se descarga directamente desde el panel del laboratorio en el formato necesario.

![Configuración de la instancia: nombre SantysTours-Server, AMI Ubuntu 22.04 LTS y tipo t3.micro](capturas/Captura%20de%20pantalla%2001%20y%2002.png)
*Captura 01-02 — Pantalla Launch Instance con nombre, AMI Ubuntu Server 22.04 LTS y tipo t3.micro seleccionados*

### 2.3 Configuración del Security Group

Crear un nuevo Security Group con las siguientes reglas de entrada:

| Tipo | Puerto | Protocolo | Origen | Uso |
|------|--------|-----------|--------|-----|
| SSH | 22 | TCP | Anywhere (0.0.0.0/0) | Administración remota con PuTTY |
| HTTP | 80 | TCP | Anywhere (0.0.0.0/0) | Portal web |
| HTTPS | 443 | TCP | Anywhere (0.0.0.0/0) | Portal web seguro |
| Custom TCP | 445 | TCP | Anywhere (0.0.0.0/0) | Samba (compartición de archivos) |

![Security Group con las 4 reglas de entrada: SSH 22, HTTPS 443, HTTP 80, TCP 445](capturas/Captura%20de%20pantalla%2003.png)
*Captura 03 — Security Group con reglas SSH (22), HTTPS (443), HTTP (80) y Samba/TCP (445)*

### 2.4 Lanzamiento y verificación

1. Revisar el resumen de la configuración
2. Clic en **Launch Instance**
3. Esperar a que el estado cambie a **running** (1-2 minutos)
4. Anotar la **IP pública** asignada por AWS Academy

![Instancia SantysTours-Server en estado running con IP pública y detalle de la instancia](capturas/Captura%20de%20pantalla%2004%20y%2005.png)
*Captura 04-05 — Instancia SantysTours-Server en estado running, IP pública 100.31.58.43, tipo t3.micro, par de claves vockey*

### 2.5 Descarga de la clave para PuTTY

En AWS Academy, la clave privada **vockey** se descarga directamente desde el panel del laboratorio:

1. En el panel del laboratorio AWS Academy → clic en **Download PEM** o **Download PPK**
2. Para conectar con PuTTY desde Windows → seleccionar **Download PPK**
3. Guardar el archivo `labsuser.ppk` en `C:\Keys\` dentro de la VM Windows 11 Pro
4. **No es necesario usar PuTTYgen** — AWS Academy ya proporciona el archivo en formato .ppk listo para usar

### 2.6 Primera conexión SSH al servidor con PuTTY

El acceso al servidor se realiza mediante **PuTTY** desde el equipo cliente Windows 11 Pro.
El proceso completo de configuración de PuTTY está documentado en `03_configuracion_basica.md`.

Pasos resumidos:
1. Descargar `labsuser.ppk` desde el panel del laboratorio AWS Academy
2. Abrir PuTTY → sesión guardada `SantysTours-Server` → **Open**
3. Login: `ubuntu`
4. Verificar que el sistema está operativo:

```bash
lsb_release -a
ip a
```

---


---

## 3. PARTE B — Base de datos: Amazon RDS MySQL

### 3.1 Descripción del servicio

Amazon RDS (Relational Database Service) proporciona la base de datos MySQL 8.0 de The Santy's Tours. Al ser un **servicio totalmente gestionado**, AWS se encarga del sistema operativo subyacente, los parches de seguridad y las copias de seguridad automáticas diarias.

> **En el entorno de prueba AWS Academy:** RDS se configura dentro de la misma VPC que la instancia EC2 y solo es accesible desde ella — no expuesto a internet público.

### 3.2 Parámetros de configuración

| Parámetro | Valor |
|-----------|-------|
| Motor | MySQL 8.0 |
| Tipo de instancia | **db.t3.micro** |
| Almacenamiento | 20 GB SSD (gp2) |
| Identificador de BD | `santytoursdb` |
| Usuario maestro | `admin` |
| Multi-AZ | No (entorno de prueba) |
| Acceso público | **No** — solo accesible desde la EC2 |
| VPC | La misma VPC que la instancia EC2 |

### 3.3 Pasos de lanzamiento en AWS Academy

1. Navegar a **RDS** → **Databases** → **Create database**
2. Método: **Standard create**
3. Motor: **MySQL** → Versión **8.0**
4. Plantilla: **Free Tier**
5. Identificador de BD: `santytoursdb`
6. Usuario maestro: `admin` → contraseña segura
7. Tipo de instancia: **db.t3.micro**
8. Almacenamiento: **20 GB SSD**
9. Conectividad:
   - VPC: la misma que la instancia EC2
   - Acceso público: **No**
   - Security Group: permitir MySQL (3306/TCP) **solo desde el Security Group de la EC2**
10. Clic en **Create database** — el proceso tarda entre 5 y 10 minutos

### 3.4 Endpoint de conexión

Una vez creada la instancia, anotar el **endpoint** desde el panel de RDS:

```
santytoursdb.xxxxxxxxx.us-east-1.rds.amazonaws.com:3306
```

Este endpoint se configura en el backend Node.js de la instancia EC2 para conectar con la base de datos.

---

## 4. PARTE C — Almacenamiento: Amazon S3

### 4.1 Descripción del servicio

Amazon S3 (Simple Storage Service) almacena todos los archivos multimedia y estáticos del proyecto:
- Imágenes de los tours y fotografías de los guías
- Documentos PDF de confirmación de reservas
- Archivos estáticos del portal web (HTML, CSS, JavaScript)

> S3 es un servicio completamente gestionado por AWS — **no requiere sistema operativo ni administración de servidor**.

### 4.2 Creación del bucket

1. Navegar a **S3** → **Create bucket**
2. Nombre del bucket: `santystours-media`
3. Región: **us-east-1** (misma región que EC2 y RDS)
4. Acceso público: **Desbloquear** para archivos estáticos (confirmar aviso)
5. Versionado: Desactivado (entorno de prueba)
6. Clic en **Create bucket**

### 4.3 Política de acceso del bucket

Aplicar la siguiente Bucket Policy para permitir lectura pública de los archivos estáticos:

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

Los siguientes servicios completan la arquitectura definida en el módulo MPO. Son **servicios totalmente gestionados por AWS** — no requieren instalación de sistema operativo.

### 5.1 Application Load Balancer (ALB)

El ALB distribuye el tráfico entrante entre las instancias EC2 disponibles. En el entorno de prueba con una sola instancia EC2, el ALB no se configura. En producción real gestionará el escalado automático.

| Parámetro | Valor (producción) |
|-----------|-------------------|
| Tipo | Application Load Balancer |
| Esquema | Internet-facing |
| Listeners | HTTP (80) → redirige a HTTPS (443) |
| Target Group | Instancias EC2 (puerto 80) |
| Health check | `GET /health` → 200 OK |

> **Entorno de prueba:** No configurado. El acceso al servidor se realiza directamente por la IP pública de la instancia EC2.

### 5.2 Amazon CloudFront

CloudFront actúa como CDN distribuyendo los archivos estáticos desde el servidor geográficamente más cercano al usuario, reduciendo la latencia.

| Parámetro | Valor (producción) |
|-----------|-------------------|
| Origen | Bucket S3 `santystours-media` |
| Protocolo | HTTPS only |
| TTL caché | 86400s para imágenes, 0 para HTML |
| Función | Servir archivos estáticos con baja latencia globalmente |

> **Entorno de prueba:** No configurado. Los archivos se sirven directamente desde S3.

### 5.3 Amazon Route 53

Route 53 gestiona el DNS del dominio `thesantystours.com`, traduciendo el nombre de dominio a la IP del ALB.

| Parámetro | Valor (producción) |
|-----------|-------------------|
| Dominio | `thesantystours.com` |
| Tipo de registro | A — Alias apuntando al ALB |
| TTL | 300 segundos |

> **Entorno de prueba:** No configurado. El acceso se realiza mediante IP pública de la EC2.

---

## 6. PARTE E — Cliente: Instalación de Windows 11 Pro en VirtualBox: Instalación de Windows 11 Pro en VirtualBox

### 6.1 Entorno de virtualización

| Componente | Especificación |
|-----------|----------------|
| Host | Lenovo Legion 5 |
| CPU Host | Intel Core i9 |
| RAM Host | 32 GB |
| Hipervisor | Oracle VirtualBox 7.x |
| SO invitado | Windows 11 Pro |

### 6.2 Descarga de la ISO de Windows 11

1. Acceder a [https://www.microsoft.com/software-download/windows11](https://www.microsoft.com/software-download/windows11)
2. Descargar la **ISO de Windows 11** (idioma Español)
3. Guardar el archivo .iso en el equipo host

### 6.3 Creación de la máquina virtual

1. Abrir VirtualBox → **Nueva**
2. Configurar:

| Parámetro | Valor |
|-----------|-------|
| Nombre | `SantysTours-Cliente` |
| Tipo | Microsoft Windows |
| Versión | Windows 11 (64-bit) |
| RAM | 4096 MB |
| Disco | 60 GB (VDI dinámico) |

3. **Configuración → Red** → Adaptador 1: **NAT**

### 6.4 Proceso de instalación de Windows 11 Pro

1. Montar la ISO → iniciar la VM
2. Seleccionar edición: **Windows 11 Pro**
3. Tipo de instalación: **Personalizada** (instalación limpia)
4. Seleccionar el disco completo
5. Completar el asistente de configuración inicial

### 6.5 Verificación post-instalación

```
Inicio → Configuración → Sistema → Acerca de
→ Confirmar: Windows 11 Pro
→ Renombrar equipo: SantysTours-Admin
```

### 6.6 Instalación de herramientas de administración

Una vez instalado Windows 11 Pro:

1. Instalar **PuTTY** desde [https://www.putty.org](https://www.putty.org)
2. Descargar `labsuser.ppk` desde el panel del laboratorio AWS Academy
3. Copiar `labsuser.ppk` a `C:\Keys\` dentro de la VM
4. Configurar la sesión PuTTY (ver `03_configuracion_basica.md`)

---

## 7. Resumen del plan de implantación

```
┌─────────────────────────────────────────────────────────────┐
│              PLAN DE IMPLANTACIÓN ISO                        │
├────────────────────────┬────────────────────────────────────┤
│  SERVIDOR (AWS Academy)│  CLIENTE (VirtualBox)              │
│                        │                                    │
│  1. Consola AWS Academy│  1. Descarga ISO Windows 11 Pro    │
│  2. Launch Instance    │  2. Crear VM en VirtualBox         │
│     → AMI Ubuntu 22.04 │     → 4GB RAM, 60GB disco          │
│     → t3.micro         │  3. Instalación Windows 11 Pro     │
│     → vockey (clave    │     → Seleccionar edición Pro      │
│       del laboratorio) │     → Instalación limpia           │
│     → Security Group   │  4. Verificar SO + renombrar equipo│
│       (22,80,443,445)  │  5. Instalar PuTTY                 │
│  3. Descargar .ppk     │  6. Copiar labsuser.ppk            │
│     desde panel lab    │  7. Configurar sesión PuTTY        │
│  4. Conectar por PuTTY │                                    │
└────────────────────────┴────────────────────────────────────┘
```

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
