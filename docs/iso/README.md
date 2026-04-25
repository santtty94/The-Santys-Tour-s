# 🖥️ ISO — Implantación de Sistemas Operativos

**Módulo:** Implantación de Sistemas Operativos (ISO)
**Proyecto:** The Santy's Tours — Proyecto Intermodular ASIR 2025/2026
**Repositorio:** `docs/iso/`

---

## 📋 Descripción

Este módulo documenta el diseño, justificación e implantación de todos los sistemas operativos y servicios de la infraestructura de **The Santy's Tours**, agencia de turismo de ocio y aventura con sede en Barcelona.

---

## ⚠️ Contexto del entorno de prueba

Este módulo se ejecuta como **prueba piloto** previa al despliegue real del proyecto. El objetivo es demostrar los conocimientos técnicos y validar el funcionamiento del sistema antes de ejecutarlo en producción.

| Componente | Entorno de prueba (este módulo) | Entorno real (producción futura) |
|-----------|--------------------------------|----------------------------------|
| Servidor EC2 | **AWS Academy** (laboratorio para estudiantes) | AWS cuenta de producción |
| Base de datos RDS | **AWS Academy** — db.t3.micro MySQL 8.0 | AWS RDS producción con Multi-AZ |
| Almacenamiento S3 | **AWS Academy** — bucket santystours-media | AWS S3 producción |
| ALB / CloudFront / Route 53 | Documentados, no configurados en lab | Configurados en producción |
| Equipos cliente | **Windows 11 Pro en VirtualBox** (Lenovo Legion 5 i9, 32 GB RAM) | Equipos físicos Windows 11 Pro en la oficina |
| Acceso remoto | **PuTTY** + clave `labsuser.ppk` (vockey AWS Academy) | PuTTY desde equipos físicos → AWS producción |

> Todos los procedimientos documentados son directamente aplicables al entorno de producción real sin cambios técnicos, únicamente cambia la infraestructura sobre la que se ejecutan.

---

## 📁 Contenido de esta carpeta

```
docs/iso/
├── README.md                        # Este archivo
├── 01_analisis_justificacion.md     # Análisis y justificación de todos los sistemas
├── 02_plan_implantacion.md          # Plan completo: EC2, RDS, S3, ALB, CloudFront, Route 53, VirtualBox
├── 03_configuracion_basica.md       # Config básica: EC2 (Ubuntu), RDS (MySQL), S3, cliente Windows
├── 04_gestion_usuarios_permisos.md  # Gestión de usuarios y permisos en servidor y cliente
└── 05_servicios_ssh_samba.md        # Servicios SSH (PuTTY + vockey) y Samba
```

---

## 🎯 Objetivos del módulo

- Justificar la elección de todos los sistemas operativos y servicios de la arquitectura MPO
- Documentar el lanzamiento de **EC2 t3.micro** con Ubuntu Server 22.04 LTS en AWS Academy
- Documentar el lanzamiento y configuración básica de **RDS MySQL 8.0**
- Documentar la creación y configuración del bucket **S3** para almacenamiento multimedia
- Documentar ALB, CloudFront y Route 53 (servicios gestionados, configurables en producción)
- Documentar la instalación de **Windows 11 Pro** en VirtualBox como equipo cliente
- Configurar acceso remoto SSH mediante **PuTTY** con clave `labsuser.ppk`
- Configurar usuarios, permisos y servicios básicos (SSH y Samba)

---

## 🧩 Infraestructura completa — Coherencia con MPO

| Componente | Servicio AWS | Sistema / Gestión | Cobertura ISO |
|-----------|-------------|------------------|---------------|
| Servidor de aplicación | EC2 t3.micro | Ubuntu Server 22.04 LTS | ✅ Instalación + configuración + servicios |
| Base de datos | RDS MySQL 8.0 | Gestionado por AWS | ✅ Lanzamiento + conexión + usuario app |
| Almacenamiento | S3 (santystours-media) | Servicio sin servidor | ✅ Bucket + permisos + estructura + CLI |
| CDN | CloudFront | Servicio sin servidor | ✅ Documentado (producción) |
| Balanceo de carga | ALB | Servicio sin servidor | ✅ Documentado (producción) |
| DNS | Route 53 | Servicio sin servidor | ✅ Documentado (producción) |
| Equipos de oficina | — | Windows 11 Pro | ✅ Instalación VirtualBox + PuTTY + Samba |

---

## 👥 Usuarios configurados en el servidor

| Usuario | Rol | Permisos |
|---------|-----|----------|
| `ubuntu` | Usuario por defecto AWS (admin técnico) | `sudo` completo |
| `admin_tours` | Administrador del sistema | `sudo` completo |
| `empleado` | Empleado de oficina | Lectura/escritura en carpetas de trabajo |
| `guia` | Guía turístico | Solo lectura en rutas |
| `readonly` | Consultas externas | Solo lectura general |
| `santyapp` | Usuario de aplicación (RDS) | SELECT, INSERT, UPDATE, DELETE en santytoursdb |

---

## 🔧 Servicios configurados

- **SSH** — Acceso remoto seguro al servidor mediante **PuTTY** + `labsuser.ppk` (vockey) desde Windows 11 Pro (puerto 22)
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

1. Par de claves **vockey** del laboratorio AWS Academy
2. Descargar `labsuser.ppk` desde el panel del laboratorio (**Download PPK**)
3. Copiar `labsuser.ppk` a `C:\Keys\` en la VM Windows 11 Pro
4. Sesión guardada en PuTTY: `SantysTours-Server` → IP pública AWS Academy
5. Login: usuario `ubuntu` con autenticación por clave .ppk

---

## 📎 Documentación relacionada

- [MPO — Cloud (AWS)](../cloud/README.md) — Arquitectura AWS completa del proyecto
- [PAR — Redes](../redes/README.md) — Diseño de red del proyecto
- [FHW — Hardware](../hardware/README.md) — Hardware de los equipos
- [GBD — Base de Datos](../../bbdd/README.md) — Base de datos del proyecto
