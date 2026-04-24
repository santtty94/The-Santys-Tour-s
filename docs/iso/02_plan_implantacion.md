# 02 — Plan de Implantación

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

## 1. Arquitectura de implantación

The Santy's Tours utiliza una infraestructura mixta que separa claramente el rol del servidor y de los clientes:

| Componente | Plataforma | Sistema Operativo | Justificación |
|-----------|-----------|------------------|---------------|
| Servidor de producción | AWS EC2 | Ubuntu Server 22.04 LTS | Infraestructura cloud real del proyecto (coherente con módulo MPO) |
| Equipos de administración | VirtualBox 7.x (Lenovo Legion 5) | Windows 11 Pro | Entorno de cliente simulado en local para demostrar configuración e integración |

> **Nota:** El servidor no se instala manualmente. AWS lanza una instancia EC2 con Ubuntu Server 22.04 LTS preconfigurado. El proceso de implantación consiste en el lanzamiento, configuración y puesta en marcha de dicha instancia.

---

## 2. PARTE A — Servidor: Lanzamiento de instancia EC2 en AWS

### 2.1 Acceso a la consola AWS

1. Acceder a [https://console.aws.amazon.com](https://console.aws.amazon.com)
2. Iniciar sesión con la cuenta del proyecto
3. Navegar a **EC2** → **Instances** → **Launch Instance**

### 2.2 Configuración de la instancia

| Parámetro | Valor |
|-----------|-------|
| Nombre | `SantysTours-Server` |
| AMI | Ubuntu Server 22.04 LTS (64-bit x86) |
| Tipo de instancia | **t3.micro** (1 vCPU, 1 GB RAM) — Free Tier elegible |
| Par de claves | `santysTours-key` (generar nuevo, formato .pem) |
| Almacenamiento | 20 GB SSD (gp3) |

> El tipo **t3.micro** es el establecido en el módulo MPO para toda la infraestructura del proyecto.

### 2.3 Configuración del Security Group

Crear un nuevo Security Group con las siguientes reglas de entrada:

| Tipo | Puerto | Protocolo | Origen | Uso |
|------|--------|-----------|--------|-----|
| SSH | 22 | TCP | Anywhere (0.0.0.0/0) | Administración remota |
| HTTP | 80 | TCP | Anywhere (0.0.0.0/0) | Portal web |
| HTTPS | 443 | TCP | Anywhere (0.0.0.0/0) | Portal web seguro |
| Custom TCP | 445 | TCP | Anywhere (0.0.0.0/0) | Samba (compartición de archivos) |

### 2.4 Lanzamiento y verificación

1. Revisar el resumen de la configuración
2. Clic en **Launch Instance**
3. Esperar a que el estado cambie a **running** (1-2 minutos)
4. Anotar la **IP pública** asignada por AWS — se usará en todos los pasos siguientes

### 2.5 Par de claves SSH

- Descargar el archivo `santysTours-key.pem` inmediatamente tras la creación
- Guardar en lugar seguro — AWS no permite descargarlo de nuevo
- En Windows, ajustar los permisos del archivo antes de usarlo:

```powershell
icacls santysTours-key.pem /inheritance:r /grant:r "%USERNAME%:R"
```

### 2.6 Primera conexión SSH al servidor

Desde Windows Terminal en el equipo de administración:

```powershell
ssh -i santysTours-key.pem ubuntu@IP_PUBLICA
```

Verificar que el sistema está operativo:

```bash
lsb_release -a
ip a
```

---

## 3. PARTE B — Cliente: Instalación de Windows 11 Pro en VirtualBox

### 3.1 Entorno de virtualización

| Componente | Especificación |
|-----------|----------------|
| Host | Lenovo Legion 5 |
| CPU Host | Intel Core i9 |
| RAM Host | 32 GB |
| Hipervisor | Oracle VirtualBox 7.x |
| SO invitado | Windows 11 Pro |

### 3.2 Descarga de la ISO de Windows 11

1. Acceder a [https://www.microsoft.com/software-download/windows11](https://www.microsoft.com/software-download/windows11)
2. Descargar la **ISO de Windows 11** (seleccionar idioma Español)
3. Guardar el archivo .iso en el equipo host

### 3.3 Creación de la máquina virtual

1. Abrir VirtualBox → **Nueva**
2. Configurar con los siguientes parámetros:

| Parámetro | Valor |
|-----------|-------|
| Nombre | `SantysTours-Cliente` |
| Tipo | Microsoft Windows |
| Versión | Windows 11 (64-bit) |
| RAM | 4096 MB |
| Disco | 60 GB (VDI dinámico) |

3. En **Configuración → Red**:
   - Adaptador 1: **NAT** (para internet durante la instalación)

### 3.4 Proceso de instalación de Windows 11 Pro

1. Montar la ISO: Configuración → Almacenamiento → seleccionar la ISO
2. Iniciar la VM
3. En la pantalla de selección de edición → marcar **Windows 11 Pro**
4. Tipo de instalación: **Personalizada** (instalación limpia)
5. Seleccionar el disco completo para la instalación
6. Completar el asistente de configuración inicial (idioma, cuenta, etc.)

### 3.5 Verificación post-instalación

```
Inicio → Configuración → Sistema → Acerca de
→ Confirmar: Windows 11 Pro
```

### 3.6 Instalación de herramientas de administración

Una vez instalado Windows 11 Pro, instalar en la VM:

- **Windows Terminal** — para conexiones SSH al servidor AWS
- Copiar el archivo `santysTours-key.pem` dentro de la VM para las conexiones SSH

---

## 4. Resumen del plan de implantación

```
┌─────────────────────────────────────────────────────────────┐
│              PLAN DE IMPLANTACIÓN ISO                        │
├────────────────────────┬────────────────────────────────────┤
│  SERVIDOR (AWS)        │  CLIENTE (VirtualBox)              │
│                        │                                    │
│  1. Consola AWS EC2    │  1. Descarga ISO Windows 11 Pro    │
│  2. Launch Instance    │  2. Crear VM en VirtualBox         │
│     → AMI Ubuntu 22.04 │     → 4GB RAM, 60GB disco          │
│     → t3.micro         │  3. Instalación Windows 11 Pro     │
│     → Security Group   │     → Seleccionar edición Pro      │
│       (22,80,443,445)  │     → Instalación limpia           │
│  3. Obtener IP pública │  4. Verificar SO instalado         │
│  4. Conectar por SSH   │  5. Instalar Windows Terminal      │
│     desde Windows      │  6. Copiar clave .pem              │
└────────────────────────┴────────────────────────────────────┘
```

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
