# 02 — Plan de Implantación

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

> **Nota sobre las evidencias:** Los procedimientos descritos corresponden al entorno de producción real. Las capturas aportadas fueron tomadas en un entorno de laboratorio (AWS Academy + VirtualBox) como evidencia práctica del proyecto intermodular ASIR. Los comandos y configuraciones son idénticos en producción.

---

## 1. Alcance de este documento

El módulo ISO cubre exclusivamente los **sistemas operativos** de la infraestructura de The Santy's Tours — es decir, los sistemas que requieren instalación, configuración y administración de un SO:

| Sistema | SO | Administrado por |
|---------|-----|-----------------|
| Servidor de aplicación | Ubuntu Server 22.04 LTS | El equipo técnico de The Santy's Tours |
| Equipos de administración de oficina | Windows 11 Pro | El equipo técnico de The Santy's Tours |

> Los demás servicios de la arquitectura (RDS, S3, CloudFront, ALB, Route 53) son servicios **totalmente gestionados por AWS** — no tienen sistema operativo administrable. Su planificación, configuración y costes están documentados en el **módulo MPO**.

---

## 2. PARTE A — Servidor: Ubuntu Server 22.04 LTS en AWS EC2

### 2.1 Acceso a la consola AWS

1. Acceder a [https://console.aws.amazon.com](https://console.aws.amazon.com) con la cuenta del proyecto
2. Navegar a **EC2** → **Instances** → **Launch Instance**

### 2.2 Configuración de la instancia EC2

| Parámetro | Valor |
|-----------|-------|
| Nombre | `SantysTours-Server` |
| AMI | Ubuntu Server 22.04 LTS (64-bit x86) |
| Tipo de instancia | **t3.micro** (1 vCPU, 1 GB RAM) |
| Par de claves | Crear nuevo par de claves → descargar `.ppk` para PuTTY |
| Almacenamiento | 20 GB SSD (gp3) |

> El servidor no se instala manualmente — AWS lanza la instancia con Ubuntu Server 22.04 LTS preconfigurado. La implantación consiste en el lanzamiento y puesta en marcha de los servicios sobre ese SO.

![Configuración de la instancia: nombre SantysTours-Server, AMI Ubuntu 22.04 LTS y tipo t3.micro](capturas/Captura%20de%20pantalla%2001%20y%2002.png)
*Captura 01-02 — Pantalla Launch Instance con nombre, AMI Ubuntu Server 22.04 LTS y tipo t3.micro*

### 2.3 Configuración del Security Group

| Tipo | Puerto | Protocolo | Origen | Uso |
|------|--------|-----------|--------|-----|
| SSH | 22 | TCP | IP de administración | Administración remota con PuTTY |
| HTTP | 80 | TCP | Anywhere | Portal web |
| HTTPS | 443 | TCP | Anywhere | Portal web seguro |
| Custom TCP | 445 | TCP | Red interna de oficina | Samba |

![Security Group con las reglas de entrada configuradas](capturas/Captura%20de%20pantalla%2003.png)
*Captura 03 — Security Group con reglas SSH (22), HTTPS (443), HTTP (80) y Samba/TCP (445)*

### 2.4 Lanzamiento y verificación

1. Clic en **Launch Instance** → esperar estado **running** (1-2 minutos)
2. Asignar una **Elastic IP** para tener IP pública fija en producción
3. Anotar la IP pública — se usará en todos los pasos siguientes

![Instancia SantysTours-Server en estado running con IP pública](capturas/Captura%20de%20pantalla%2004%20y%2005.png)
*Captura 04-05 — Instancia SantysTours-Server en estado running con IP pública asignada*

### 2.5 Par de claves para PuTTY

1. Al crear la instancia, descargar la clave en formato **.ppk** desde la consola AWS
2. Guardar en el equipo de administración en `C:\Keys\`
3. Esta clave permite autenticarse en PuTTY sin contraseña

### 2.6 Primera conexión SSH al servidor con PuTTY

1. Abrir PuTTY → IP pública del servidor → puerto 22 → tipo SSH
2. **Connection → SSH → Auth → Credentials** → seleccionar el archivo `.ppk`
3. Guardar sesión como `SantysTours-Server` → **Open**
4. Login: `ubuntu`
5. Verificar el sistema:

```bash
lsb_release -a
ip a
```

---

## 3. PARTE B — Equipos cliente: Windows 11 Pro en equipos físicos

### 3.1 Especificaciones de los equipos de oficina

| Componente | Especificación |
|-----------|---------------|
| Modelo | Lenovo Legion 5 |
| CPU | Intel Core i9 (64-bit, TPM 2.0) |
| RAM | 32 GB |
| Almacenamiento | SSD NVMe |
| Red | Ethernet / WiFi |
| SO a instalar | Windows 11 Pro |

### 3.2 Preparación del medio de instalación (USB booteable)

1. Descargar la **Media Creation Tool** desde [https://www.microsoft.com/software-download/windows11](https://www.microsoft.com/software-download/windows11)
2. Ejecutar → **Crear medios de instalación** → idioma: Español (España) → edición: Windows 11 → 64-bit
3. Seleccionar **Unidad flash USB** (mínimo 8 GB)
4. La herramienta descarga Windows 11 y crea el USB booteable automáticamente

### 3.3 Proceso de instalación desde USB

1. Conectar el USB al equipo → acceder a BIOS/UEFI (F2, F12 o DEL)
2. Cambiar el orden de arranque → USB primero → guardar y reiniciar
3. Seleccionar idioma y región → **Instalar ahora**
4. Introducir la clave de producto Windows 11 Pro (o activar después)
5. Seleccionar edición: **Windows 11 Pro** ✅
6. Aceptar los términos de licencia
7. Tipo de instalación: **Personalizada** (instalación limpia)
8. Seleccionar el disco → **Siguiente**
9. Esperar a que finalice (15-30 minutos, el equipo reiniciará varias veces)

![Proceso de instalación de Windows 11 en curso en la VM SantysTours-Admin-01](capturas/Captura%20de%20pantalla%2016.png)
*Captura 16 — Proceso de instalación de Windows 11 pro al 12% en la VM SantysTours-Admin-01*

### 3.4 Configuración inicial

1. Región: **España** → teclado: **Español**
2. Conectar a la red de la oficina
3. Crear cuenta local de administrador: `Admin_SantysTours`
4. Desactivar el requisito de cuenta Microsoft si se solicita

![Escritorio de Windows 11 recién instalado en la VM SantysTours-Admin-01](capturas/Captura%20de%20pantalla%2019.png)
*Captura 19 — Escritorio de Windows 11 pro en la VM SantysTours-Admin-01 tras completar la instalación*

### 3.5 Verificación post-instalación

```
Inicio → Configuración → Sistema → Acerca de
→ Confirmar: Windows 11 Pro
→ Renombrar equipo: SantysTours-Admin-01
```

### 3.6 Instalación de herramientas de administración

1. Instalar **PuTTY** desde [https://www.putty.org](https://www.putty.org)
2. Copiar la clave privada `.ppk` al equipo en `C:\Keys\`
3. Configurar sesión PuTTY (ver `03_configuracion_basica.md`)

---

## 4. Resumen del plan de implantación

```
┌─────────────────────────────────────────────────────────────────────┐
│                  PLAN DE IMPLANTACIÓN ISO                           │
├──────────────────────────────┬──────────────────────────────────────┤
│  SERVIDOR (AWS EC2)          │  EQUIPOS DE OFICINA                  │
│                              │                                      │
│  1. Consola AWS              │  1. Preparar USB booteable           │
│  2. Launch Instance          │     → Media Creation Tool            │
│     → AMI Ubuntu 22.04 LTS  │     → Windows 11 Pro                 │
│     → t3.micro               │  2. Instalar Windows 11 Pro          │
│     → Security Group         │     → Boot desde USB                 │
│       (22, 80, 443, 445)     │     → Instalación limpia             │
│     → Par de claves .ppk     │     → Edición Pro                    │
│  3. Asignar Elastic IP       │  3. Configurar equipo                │
│  4. Conectar por PuTTY       │     → Nombre SantysTours-Admin-01    │
│     → Login: ubuntu          │     → Cuenta local admin             │
│     → Verificar SO           │  4. Instalar PuTTY + clave .ppk      │
└──────────────────────────────┴──────────────────────────────────────┘
```

> **Servicios AWS gestionados** (RDS, S3, CloudFront, ALB, Route 53): no tienen SO administrable. Su configuración está documentada en el **módulo MPO**.

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
