# 01 — Análisis y Justificación del Sistema Operativo

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

> **Nota sobre las evidencias:** Los procedimientos y justificaciones de este documento corresponden al entorno de producción real. Las capturas aportadas en otros documentos fueron tomadas en un entorno de laboratorio (AWS + VirtualBox) como evidencia práctica del proyecto intermodular ASIR.


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

Los equipos de administración de The Santy's Tours requieren un sistema operativo que permita al personal trabajar con las aplicaciones de oficina habituales, acceder al servidor mediante SSH (PuTTY), conectar unidades de red Samba y ser fácilmente administrado por el equipo técnico.

---

### 6.1 Alternativas analizadas para los equipos cliente

#### Windows 11 Pro ✅ ELEGIDO

**Fabricante:** Microsoft
**Versión:** Windows 11 Pro
**Licencia:** OEM incluida en los equipos adquiridos
**Soporte:** Hasta octubre de 2031

**Ventajas:**
- Interfaz familiar para todo el personal sin perfil técnico
- Amplia compatibilidad con software de gestión empresarial y Suite Microsoft Office
- Integración nativa con unidades de red Samba (SMB/CIFS) sin software adicional
- PuTTY disponible y ampliamente documentado para Windows
- Herramientas de administración avanzadas: `gpedit.msc`, políticas de grupo, Active Directory
- Soporte técnico profesional amplio

**Inconvenientes:**
- Coste de licencia (incluido en el precio del equipo OEM)
- Mayor consumo de recursos que sistemas ligeros
- Actualizaciones forzadas pueden interrumpir el trabajo

---

#### macOS Sequoia

**Fabricante:** Apple
**Licencia:** Incluida con hardware Apple

**Ventajas:**
- Interfaz intuitiva y estable
- Integración nativa con ecosistema Apple
- Terminal Unix nativo para SSH

**Inconvenientes:**
- Requiere hardware Apple — coste significativamente superior
- Menor compatibilidad con software empresarial específico del sector turístico
- Sin soporte nativo para unidades de red Samba (requiere configuración adicional)
- No es el entorno habitual del personal de oficina en España

---

#### Ubuntu Desktop 22.04 LTS

**Fabricante:** Canonical
**Licencia:** Gratuito (open source)

**Ventajas:**
- Sin coste de licencia
- SSH y Samba integrados de forma nativa
- Muy ligero en recursos

**Inconvenientes:**
- Curva de aprendizaje elevada para personal sin perfil técnico
- Incompatibilidad con algunos programas de gestión turística específicos de Windows
- Requiere formación del personal — coste indirecto significativo
- La instalación y mantenimiento requiere mayor dedicación técnica

---

#### Windows 10 Pro

**Fabricante:** Microsoft
**Soporte:** Fin de soporte en **octubre de 2025**

**Ventajas:**
- Ampliamente conocido por todo el personal
- Menor requisitos de hardware que Windows 11

**Inconvenientes:**
- Fin de soporte oficial en octubre de 2025 — no apto para un proyecto nuevo
- Sin las mejoras de seguridad de Windows 11 (TPM 2.0, Secure Boot)

---

### 6.2 Tabla comparativa — Equipos cliente

| Criterio | Windows 11 Pro | macOS Sequoia | Ubuntu Desktop 22.04 | Windows 10 Pro |
|----------|---------------|---------------|---------------------|----------------|
| Coste licencia | OEM incluido | Hardware caro | Gratuito | OEM incluido |
| Soporte hasta | 2031 | Indefinido | 2027 | ~~2025~~ ❌ |
| Familiaridad del personal | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| Integración Samba | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Herramientas administración | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Compatibilidad software | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Vigencia del soporte | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ❌ |
| **Puntuación total** | **34/35** | **25/35** | **25/35** | **28/35** |

---

### 6.3 Decisión final — Equipos cliente

**Sistema elegido: Windows 11 Pro**

Windows 11 Pro es la opción más adecuada para los equipos de administración de The Santy's Tours por los siguientes motivos:

1. **Familiaridad del personal**: los empleados y guías turísticos no tienen perfil técnico. Windows 11 Pro es el entorno que conocen y en el que son productivos desde el primer día, sin formación adicional.

2. **Integración nativa con la infraestructura**: Windows 11 Pro se integra de forma transparente con las unidades de red Samba del servidor Ubuntu — los empleados ven las carpetas compartidas como unidades locales en el Explorador de archivos.

3. **PuTTY para administración remota**: el personal técnico gestiona el servidor Ubuntu desde Windows 11 Pro usando PuTTY, herramienta estándar y ampliamente documentada en entornos Windows.

4. **Herramientas de administración avanzadas**: Windows 11 Pro incluye `gpedit.msc` (editor de directivas de grupo) que permite aplicar restricciones de seguridad específicas por usuario — fundamental para limitar los permisos de las cuentas de empleados.

5. **Vigencia del soporte**: soporte oficial hasta octubre de 2031, suficiente para el ciclo de vida del proyecto.

6. **Sin coste adicional**: la licencia Windows 11 Pro viene incluida como OEM en los equipos adquiridos — no supone coste adicional frente a otras opciones de pago.


---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
