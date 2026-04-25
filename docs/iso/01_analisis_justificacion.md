# 01 — Análisis y Justificación del Sistema Operativo

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

## 1. Introducción

The Santy's Tours es una agencia de turismo de ocio y aventura con sede en Barcelona. Su infraestructura tecnológica requiere un sistema operativo que soporte:

- Un servidor web que aloje el portal de la empresa
- Un servidor de base de datos MySQL
- Acceso remoto seguro para administración
- Equipos cliente para los empleados y guías turísticos
- Almacenamiento compartido en red local

Este documento analiza las alternativas disponibles y justifica la elección de **Ubuntu Server 22.04 LTS** como sistema operativo principal del servidor, y **Windows 11 Pro** para los equipos cliente de administración.

---

## 2. Requisitos del sistema

### 2.1 Requisitos funcionales

| Requisito | Descripción |
|-----------|-------------|
| RF-01 | El servidor debe ejecutar Apache/Nginx para el portal web |
| RF-02 | El servidor debe soportar MySQL 8.x para la base de datos de tours |
| RF-03 | Debe permitir acceso remoto seguro por SSH |
| RF-04 | Debe soportar la compartición de archivos por red (Samba) |
| RF-05 | Los equipos cliente deben poder acceder al servidor desde la red local |
| RF-06 | El sistema debe ser administrable por un técnico ASIR |

### 2.2 Requisitos no funcionales

| Requisito | Descripción |
|-----------|-------------|
| RNF-01 | Estabilidad: mínimo 99% de disponibilidad |
| RNF-02 | Seguridad: actualizaciones de seguridad automáticas disponibles |
| RNF-03 | Coste: optimizar el coste total de licencias |
| RNF-04 | Soporte: LTS (Long Term Support) mínimo 5 años en servidor |
| RNF-05 | Rendimiento: optimizado para entorno servidor (sin entorno gráfico) |

---

## 3. Alternativas analizadas para el servidor

### 3.1 Ubuntu Server 22.04 LTS ✅ ELEGIDO

**Distribución:** Canonical Ubuntu
**Tipo:** GNU/Linux — Basado en Debian
**Versión:** 22.04 Jammy Jellyfish (LTS)
**Soporte:** Hasta abril de 2027 (standard) / 2032 (ESM)

**Ventajas:**
- Sin coste de licencia (open source)
- Amplia comunidad y documentación
- Gran compatibilidad con software de servidor (Apache, MySQL, Nginx)
- Actualizaciones de seguridad automáticas (`unattended-upgrades`)
- Sin entorno gráfico por defecto → menor consumo de recursos
- Muy estable en entornos de producción
- Compatible con los servicios cloud de AWS (módulo MPO)

**Inconvenientes:**
- Requiere conocimientos de terminal Linux
- Menos intuitivo para administradores sin experiencia en CLI

---

### 3.2 Windows Server 2022

**Fabricante:** Microsoft
**Tipo:** Sistema propietario
**Coste:** Licencia de pago (~800–3.000 € según edición)

**Ventajas:**
- Interfaz gráfica familiar para usuarios de Windows
- Integración nativa con Active Directory

**Inconvenientes:**
- Coste elevado de licencia
- Mayor consumo de recursos (RAM, disco)
- Peor rendimiento en entornos de servidor web Linux

---

### 3.3 CentOS Stream / Rocky Linux

**Tipo:** GNU/Linux — Basado en Red Hat

**Ventajas:**
- Muy usado en entornos empresariales
- Alta estabilidad

**Inconvenientes:**
- CentOS 8 fue discontinuado en 2021, generando incertidumbre
- Menor documentación accesible que Ubuntu
- Curva de aprendizaje más alta para perfiles ASIR

---

### 3.4 Debian 12 (Bookworm)

**Ventajas:**
- Muy estable, base de Ubuntu
- Software muy probado

**Inconvenientes:**
- Paquetes más antiguos que Ubuntu
- Menor documentación específica para entornos educativos

---

## 4. Tabla comparativa — Servidor

| Criterio | Ubuntu Server 22.04 | Windows Server 2022 | Rocky Linux | Debian 12 |
|----------|--------------------|--------------------|-------------|-----------|
| Coste licencia | Gratuito | ~800–3.000 € | Gratuito | Gratuito |
| Soporte LTS | 5–10 años | 10 años | 10 años | 5 años |
| Rendimiento servidor | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Facilidad de administración | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Compatibilidad web/BBDD | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Comunidad y documentación | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Puntuación total** | **29/30** | **24/30** | **24/30** | **24/30** |

---

## 5. Decisión final — Servidor

**Sistema elegido: Ubuntu Server 22.04 LTS**

Ubuntu Server 22.04 LTS es la opción más adecuada para The Santy's Tours por los siguientes motivos:

1. **Coste cero en licencias**: una startup del sector turístico debe optimizar sus costes operativos. Ubuntu Server no tiene coste de licencia, a diferencia de Windows Server.

2. **Estabilidad y soporte a largo plazo**: la versión LTS garantiza actualizaciones de seguridad hasta 2032, suficiente para el ciclo de vida del proyecto.

3. **Rendimiento optimizado**: al no disponer de entorno gráfico, todos los recursos del servidor (CPU y RAM) se dedican a los servicios de producción (Apache, MySQL, SSH).

4. **Integración perfecta con el stack tecnológico**: el portal web de The Santy's Tours usa tecnologías (HTML, CSS, JS, MySQL) cuyo despliegue es estándar en Ubuntu Server con LAMP o LEMP.

5. **Compatibilidad con AWS**: el módulo MPO (Cloud) utiliza instancias Ubuntu en AWS EC2, lo que garantiza coherencia entre el entorno local y el entorno cloud.

6. **Perfil técnico ASIR**: el dominio de Linux es una competencia fundamental del ciclo. Utilizar Ubuntu Server refuerza estas habilidades directamente aplicables al mercado laboral.

---

## 6. Sistema operativo para equipos cliente

Para los equipos de administración de la agencia (oficina), se propone:

**Windows 11 Pro** ✅ ELEGIDO

| Característica | Detalle |
|---------------|---------|
| Fabricante | Microsoft |
| Versión | Windows 11 Pro |
| Licencia | OEM incluida en los equipos de administración |
| Soporte | Hasta octubre de 2031 |

**Justificación:**

- **Familiaridad del personal**: los empleados de oficina y guías turísticos no tienen perfil técnico. Windows 11 Pro ofrece la interfaz más familiar y reduce la curva de aprendizaje.
- **Compatibilidad con herramientas de gestión**: Suite Microsoft Office, navegadores, clientes de correo y herramientas de gestión turística funcionan de forma nativa en Windows.
- **Integración con Samba**: Windows 11 Pro accede de forma transparente a las carpetas compartidas del servidor Ubuntu mediante unidades de red Samba (SMB/CIFS).
- **Administración remota del servidor**: el personal técnico gestiona el servidor Ubuntu desde Windows 11 Pro usando **PuTTY** con la clave `labsuser.ppk` (vockey de AWS Academy).
- **Sin coste adicional de licencia**: la licencia Windows 11 Pro viene incluida como OEM en los equipos de administración adquiridos.

---

## 7. Infraestructura completa — Coherencia con el módulo MPO

El módulo ISO cubre los sistemas operativos y la configuración de **todos los componentes** de la arquitectura definida en el módulo MPO (Fundamentos de Computación en la Nube). La siguiente tabla resume la infraestructura completa y su tratamiento en este módulo:

| Componente | Servicio AWS | SO / Gestión | Rol en el proyecto | Cobertura ISO |
|-----------|-------------|-------------|-------------------|---------------|
| Servidor de aplicación | EC2 t3.micro | **Ubuntu Server 22.04 LTS** (administrado por nosotros) | Ejecuta la API REST Node.js y el backend | ✅ Instalación, configuración, usuarios, SSH, Samba |
| Base de datos | RDS MySQL 8.0 (db.t3.micro) | **Gestionado por AWS** (sin acceso al SO) | Almacena usuarios, tours, reservas, pagos | ✅ Lanzamiento, conexión desde EC2, usuario de app |
| Almacenamiento multimedia | S3 (santystours-media) | **Servicio sin servidor** | Imágenes de tours, PDFs, archivos estáticos | ✅ Creación bucket, permisos, estructura, AWS CLI |
| Distribución de contenido | CloudFront | **Servicio sin servidor** | CDN — sirve archivos estáticos con baja latencia | ✅ Documentado (configurable en producción) |
| Balanceo de carga | Application Load Balancer | **Servicio sin servidor** | Distribuye tráfico entre instancias EC2 | ✅ Documentado (configurable en producción) |
| DNS | Route 53 | **Servicio sin servidor** | Resuelve el dominio thesantystours.com | ✅ Documentado (configurable en producción) |
| Equipos de administración | — | **Windows 11 Pro** (administrado por nosotros) | Acceso remoto al servidor y uso diario del personal | ✅ Instalación VirtualBox, PuTTY, Samba |

### Decisiones de diseño coherentes con MPO

- **EC2 + Ubuntu Server 22.04 LTS**: Es el único componente con sistema operativo que administramos directamente. El resto de servicios AWS son gestionados — AWS se encarga de su SO, parches y mantenimiento.
- **RDS en lugar de MySQL en EC2**: Seguimos la arquitectura MPO que separa la capa de aplicación (EC2) de la capa de datos (RDS), mejorando la seguridad, escalabilidad y disponibilidad.
- **S3 para almacenamiento**: Los archivos multimedia no se almacenan en el disco de la EC2, sino en S3, lo que permite escalar el almacenamiento independientemente del servidor.
- **ALB + CloudFront + Route 53**: En el entorno de prueba AWS Academy estos servicios no se configuran (se accede directamente por IP pública de la EC2). En producción real formarán parte de la arquitectura completa.


---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
