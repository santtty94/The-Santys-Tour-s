# 🖥️ ISO — Implantación de Sistemas Operativos

**Módulo:** Implantación de Sistemas Operativos (ISO)
**Proyecto:** The Santy's Tours — Proyecto Intermodular ASIR 2025/2026
**Repositorio:** `docs/iso/`

---

## 📋 Descripción

Este módulo documenta el diseño, justificación e implantación del sistema operativo para la infraestructura de servidores y equipos cliente de **The Santy's Tours**, agencia de turismo de ocio y aventura con sede en Barcelona.

---

## 📁 Contenido de esta carpeta

```
docs/iso/
├── README.md                        # Este archivo
├── 01_analisis_justificacion.md     # Análisis y justificación del SO elegido
├── 02_plan_implantacion.md          # Plan de implantación paso a paso
├── 03_configuracion_basica.md       # Configuración del sistema (red, usuarios, regional)
├── 04_gestion_usuarios_permisos.md  # Gestión de usuarios y permisos
└── 05_servicios_ssh_samba.md        # Configuración SSH y Samba
```

---

## 🎯 Objetivos del módulo

- Analizar las necesidades del sistema operativo para The Santy's Tours
- Justificar la elección de Ubuntu Server 22.04 LTS para el servidor
- Documentar el proceso de instalación en entorno virtualizado (VirtualBox)
- Configurar usuarios, permisos y servicios básicos de red

---

## 🧩 Sistemas implantados

| Rol | Sistema Operativo | Justificación |
|-----|------------------|---------------|
| Servidor principal | Ubuntu Server 22.04 LTS | Estable, seguro, sin entorno gráfico, ideal para producción |
| Equipos de administración | Windows 11 Pro | Familiaridad del personal de oficina, integración con herramientas de gestión |
| Entorno de pruebas | VirtualBox 7.x sobre Lenovo Legion 5 (i9, 32 GB RAM) | Virtualización local para desarrollo y pruebas |

---

## 👥 Usuarios configurados en el servidor

| Usuario | Rol | Permisos |
|---------|-----|----------|
| `admin_tours` | Administrador del sistema | `sudo` completo |
| `empleado` | Empleado de oficina | Acceso a carpetas de trabajo, sin sudo |
| `guia` | Guía turístico | Solo lectura en rutas, sin acceso a configuración |
| `readonly` | Consultas externas | Solo lectura general |

---

## 🔧 Servicios configurados

- **SSH** — Acceso remoto seguro al servidor (puerto 22)
- **Samba** — Compartición de archivos entre servidor Linux y clientes Windows 11 Pro (puerto 445)

---

## 🗂️ Estructura de directorios del servidor

```
/srv/santysTours/
├── admin/          → Solo admin_tours (rwx-------)
├── tours/          → Empleados r/w, Guías r/x
├── rutas/          → Guías y Empleados solo lectura
├── documentos/     → Empleados lectura/escritura
└── publico/        → Todos los usuarios (solo lectura)
```

---

## 📎 Documentación relacionada

- [FHW — Hardware](../hardware/README.md)
- [PAR — Redes](../redes/README.md)
- [MPO — Cloud](../cloud/README.md)
- [GBD — Base de Datos](../../bbdd/README.md)
