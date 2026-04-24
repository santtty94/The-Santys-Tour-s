# 🖥️ ISO — Implantación de Sistemas Operativos

**Módulo:** Implantación de Sistemas Operativos (ISO)
**Proyecto:** The Santy's Tours — Proyecto Intermodular ASIR 2025/2026
**Repositorio:** `docs/iso/`

---

## 📋 Descripción

Este módulo documenta el diseño, justificación e implantación del sistema operativo para la infraestructura de servidores y equipos cliente de **The Santy's Tours**, agencia de turismo de ocio y aventura con sede en Barcelona.

---

## ⚠️ Contexto del entorno de prueba

Este módulo se ejecuta como **prueba piloto** previa al despliegue real del proyecto. El objetivo es demostrar los conocimientos técnicos y validar el funcionamiento del sistema antes de ejecutarlo en producción.

| Componente | Entorno de prueba (este módulo) | Entorno real (producción futura) |
|-----------|--------------------------------|----------------------------------|
| Servidor | **AWS Academy** (laboratorio para estudiantes) | AWS cuenta de producción |
| Equipos cliente | **Windows 11 Pro en VirtualBox** (Lenovo Legion 5 i9, 32 GB RAM) | Equipos físicos Windows 11 Pro en la oficina |
| Acceso remoto | **PuTTY** desde VM Windows en VirtualBox → AWS Academy | PuTTY desde equipos físicos → AWS producción |

> Todos los procedimientos documentados son directamente aplicables al entorno de producción real sin cambios técnicos, únicamente cambia la infraestructura sobre la que se ejecutan.

---

## 📁 Contenido de esta carpeta

```
docs/iso/
├── README.md                        # Este archivo
├── 01_analisis_justificacion.md     # Análisis y justificación del SO elegido
├── 02_plan_implantacion.md          # Plan de implantación: AWS Academy + VirtualBox
├── 03_configuracion_basica.md       # Configuración básica: hostname, red, PuTTY, zona horaria
├── 04_gestion_usuarios_permisos.md  # Gestión de usuarios y permisos en servidor y cliente
└── 05_servicios_ssh_samba.md        # Servicios SSH (PuTTY) y Samba (unidades de red)
```

---

## 🎯 Objetivos del módulo

- Justificar la elección de Ubuntu Server 22.04 LTS (servidor) y Windows 11 Pro (cliente)
- Documentar el lanzamiento de la instancia EC2 t3.micro en AWS Academy
- Documentar la instalación de Windows 11 Pro en VirtualBox como equipo cliente
- Configurar el acceso remoto SSH mediante PuTTY con clave .ppk
- Configurar usuarios, permisos y servicios básicos (SSH y Samba)

---

## 🧩 Sistemas implantados

| Rol | Sistema Operativo | Plataforma (prueba) | Plataforma (producción) |
|-----|------------------|--------------------|-----------------------|
| Servidor principal | Ubuntu Server 22.04 LTS | AWS Academy — EC2 t3.micro | AWS — EC2 t3.micro |
| Equipos de administración | Windows 11 Pro | VirtualBox (Lenovo Legion 5) | Equipos físicos de oficina |

---

## 👥 Usuarios configurados en el servidor

| Usuario | Rol | Permisos |
|---------|-----|----------|
| `ubuntu` | Usuario por defecto AWS (admin técnico) | `sudo` completo |
| `admin_tours` | Administrador del sistema | `sudo` completo |
| `empleado` | Empleado de oficina | Lectura/escritura en carpetas de trabajo |
| `guia` | Guía turístico | Solo lectura en rutas |
| `readonly` | Consultas externas | Solo lectura general |

---

## 🔧 Servicios configurados

- **SSH** — Acceso remoto seguro al servidor mediante **PuTTY** desde Windows 11 Pro (puerto 22)
- **Samba** — Compartición de carpetas entre servidor Ubuntu y clientes Windows 11 Pro (puerto 445)

---

## 🗂️ Estructura de directorios del servidor

```
/srv/santysTours/
├── admin/          → Solo ubuntu y admin_tours (rwx-------)
├── tours/          → Empleados r/w, Guías r/x
├── rutas/          → Guías y Empleados solo lectura
├── documentos/     → Empleados lectura/escritura (share Samba)
└── publico/        → Todos los usuarios (solo lectura, share Samba)
```

---

## 🔐 Acceso remoto al servidor

El acceso SSH desde Windows 11 Pro al servidor Ubuntu en AWS Academy se realiza mediante **PuTTY**:

1. Clave AWS descargada en formato `.pem`
2. Convertida a `.ppk` con **PuTTYgen**
3. Sesión guardada en PuTTY: `SantysTours-Server` → IP pública AWS Academy
4. Login: usuario `ubuntu` con autenticación por clave .ppk

---

## 📎 Documentación relacionada

- [MPO — Cloud (AWS)](../cloud/README.md) — Infraestructura AWS donde corre el servidor
- [PAR — Redes](../redes/README.md) — Diseño de red del proyecto
- [FHW — Hardware](../hardware/README.md) — Hardware de los equipos
- [GBD — Base de Datos](../../bbdd/README.md) — Base de datos del servidor
