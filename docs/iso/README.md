# 🖥️ ISO — Implantación de Sistemas Operativos

**Módulo:** Implantación de Sistemas Operativos (ISO)
**Proyecto:** The Santy's Tours — Proyecto Intermodular ASIR 2025/2026
**Repositorio:** `docs/iso/`

---

## 📋 Descripción

Este módulo documenta el diseño, justificación e implantación de todos los sistemas operativos y servicios de la infraestructura de **The Santy's Tours**, agencia de turismo de ocio y aventura con sede en Barcelona.

---

## 📌 Nota sobre las evidencias

Los procedimientos descritos en este módulo corresponden al **entorno de producción real** del proyecto. Las capturas de pantalla y evidencias prácticas aportadas fueron realizadas en un **entorno de laboratorio** (AWS Academy + VirtualBox) como parte del proyecto intermodular ASIR 2025/2026, con el objetivo de demostrar los conocimientos técnicos antes del despliegue real.

Los comandos, configuraciones y procedimientos son **idénticos** en producción.

---

## 📁 Contenido de esta carpeta

```
docs/iso/
├── README.md                        # Este archivo
├── 01_analisis_justificacion.md     # Análisis y justificación de todos los sistemas
├── 02_plan_implantacion.md          # Plan completo: EC2, RDS, S3, ALB, CloudFront, Route 53, Windows
├── 03_configuracion_basica.md       # Config básica: Ubuntu Server, RDS MySQL, S3, Windows 11 Pro
├── 04_gestion_usuarios_permisos.md  # Gestión de usuarios y permisos en servidor y clientes
└── 05_servicios_ssh_samba.md        # Servicios SSH y Samba
```

---

## 🎯 Objetivos del módulo

- Justificar la elección de todos los sistemas y servicios de la arquitectura MPO
- Documentar el despliegue de **EC2** con Ubuntu Server 22.04 LTS en AWS
- Documentar el lanzamiento y configuración de **RDS MySQL 8.0**
- Documentar la creación y configuración del bucket **S3**
- Documentar ALB, CloudFront y Route 53 como servicios gestionados AWS
- Documentar la instalación de **Windows 11 Pro** en equipos físicos desde USB booteable
- Configurar acceso remoto SSH mediante **PuTTY** con clave privada AWS
- Configurar usuarios, permisos y servicios básicos (SSH y Samba)

---

## 🧩 Infraestructura completa — Coherencia con MPO

| Componente | Servicio AWS | Sistema / Gestión | Cobertura ISO |
|-----------|-------------|------------------|---------------|
| Servidor de aplicación | EC2 t3.micro | Ubuntu Server 22.04 LTS | ✅ Instalación + configuración + servicios |
| Base de datos | RDS MySQL 8.0 | Gestionado por AWS | ✅ Lanzamiento + conexión + usuario app |
| Almacenamiento | S3 (santystours-media) | Servicio sin servidor | ✅ Bucket + permisos + estructura + CLI |
| CDN | CloudFront | Servicio sin servidor | ✅ Configuración documentada |
| Balanceo de carga | ALB | Servicio sin servidor | ✅ Configuración documentada |
| DNS | Route 53 | Servicio sin servidor | ✅ Configuración documentada |
| Equipos de oficina | — | Windows 11 Pro | ✅ Instalación física + PuTTY + Samba |

---

## 👥 Usuarios configurados en el servidor

| Usuario | Rol | Permisos |
|---------|-----|----------|
| `ubuntu` | Usuario por defecto AWS | `sudo` completo |
| `admin_tours` | Administrador del sistema | `sudo` completo |
| `empleado` | Empleado de oficina | Lectura/escritura en carpetas de trabajo |
| `guia` | Guía turístico | Solo lectura en rutas |
| `readonly` | Consultas externas | Solo lectura general |
| `santyapp` | Usuario de aplicación (RDS) | SELECT, INSERT, UPDATE, DELETE en santytoursdb |

---

## 🔧 Servicios configurados

- **SSH** — Acceso remoto seguro al servidor mediante **PuTTY** con clave privada AWS (puerto 22)
- **Samba** — Compartición de carpetas entre servidor Ubuntu y clientes Windows 11 Pro (puerto 445)
- **MySQL** — Conexión desde EC2 al endpoint RDS (puerto 3306, solo red interna VPC)
- **AWS CLI** — Gestión del bucket S3 desde la instancia EC2

---

## 🗂️ Estructura de directorios del servidor

```
/srv/santysTours/
├── admin/          → Solo ubuntu y admin_tours
├── tours/          → Empleados r/w, Guías r/x
├── rutas/          → Guías y Empleados solo lectura
├── documentos/     → Empleados lectura/escritura (share Samba)
└── publico/        → Todos los usuarios (solo lectura, share Samba)
```

---

## 🔐 Acceso remoto al servidor

1. Descargar la clave privada desde la consola AWS (**Download PPK** para PuTTY)
2. Guardar la clave en el equipo de administración Windows 11 Pro
3. Configurar sesión PuTTY: IP pública o dominio Route 53 del servidor EC2
4. Login: usuario `ubuntu` con autenticación por clave privada

---

## 📎 Documentación relacionada

- [MPO — Cloud (AWS)](../cloud/README.md) — Arquitectura AWS completa del proyecto
- [PAR — Redes](../redes/README.md) — Diseño de red del proyecto
- [FHW — Hardware](../hardware/README.md) — Hardware de los equipos
- [GBD — Base de Datos](../../bbdd/README.md) — Base de datos del proyecto
