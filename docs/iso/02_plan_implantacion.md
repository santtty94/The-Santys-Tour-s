# 02 — Plan de Implantación

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

## 1. Entorno de virtualización

La implantación se realiza en un entorno virtualizado local usando **VirtualBox 7.x** sobre el equipo de trabajo:

| Componente | Especificación |
|-----------|----------------|
| Host | Lenovo Legion 5 |
| CPU Host | Intel Core i9 |
| RAM Host | 32 GB |
| Hipervisor | Oracle VirtualBox 7.x |
| SO invitado | Ubuntu Server 22.04.4 LTS |

### Recursos asignados a la VM

| Recurso | Valor asignado | Justificación |
|---------|---------------|---------------|
| CPU (núcleos) | 2 | Suficiente para entorno de pruebas |
| RAM | 4 GB | Recomendado para Ubuntu Server con MySQL y Apache |
| Disco | 25 GB (VDI dinámico) | Espacio para SO + servicios + datos |
| Red | NAT + Adaptador en puente | NAT para internet, puente para acceso desde host |

---

## 2. Descarga de Ubuntu Server 22.04 LTS

1. Acceder a [https://ubuntu.com/download/server](https://ubuntu.com/download/server)
2. Descargar la ISO de **Ubuntu Server 22.04.4 LTS** (archivo `.iso`, ~1.5 GB)
3. Verificar la integridad del archivo con SHA256:

```bash
sha256sum ubuntu-22.04.4-live-server-amd64.iso
```

El hash debe coincidir con el publicado en la página oficial de Canonical.

---

## 3. Creación de la máquina virtual en VirtualBox

### 3.1 Nueva máquina virtual

1. Abrir VirtualBox → `Nueva`
2. Configurar:
   - **Nombre:** `SantysTours-Server`
   - **Tipo:** Linux
   - **Versión:** Ubuntu (64-bit)
3. Asignar **4096 MB de RAM**
4. Crear disco duro virtual:
   - Tipo: VDI (VirtualBox Disk Image)
   - Asignación: Dinámicamente asignado
   - Tamaño: **25 GB**

### 3.2 Configuración de red

Antes de arrancar:
1. `Configuración` → `Red`
2. Adaptador 1: **NAT** (para acceso a internet durante instalación)
3. Adaptador 2: **Adaptador puente** → seleccionar la tarjeta de red física del host

### 3.3 Montar la ISO

1. `Configuración` → `Almacenamiento`
2. Controlador IDE → icono de disco → `Elegir archivo`
3. Seleccionar la ISO descargada

---

## 4. Proceso de instalación de Ubuntu Server 22.04 LTS

### 4.1 Arranque e idioma

1. Iniciar la máquina virtual
2. En el menú GRUB → seleccionar `Try or Install Ubuntu Server`
3. Seleccionar idioma: **English** (recomendado para servidores, evita problemas con caracteres especiales en configs)

### 4.2 Configuración del teclado

- Layout: **Spanish**
- Variant: **Spanish**

### 4.3 Tipo de instalación

- Seleccionar: **Ubuntu Server** (no minimized)
- Instala el sistema completo con las utilidades esenciales

### 4.4 Configuración de red

El instalador detecta automáticamente las interfaces:
- **enp0s3** (NAT) → DHCP para descarga de actualizaciones durante la instalación
- **enp0s8** (Puente) → Se configurará con IP estática tras la instalación

### 4.5 Configuración de proxy

- Dejar en blanco (sin proxy)

### 4.6 Mirror de Ubuntu

- Usar el mirror por defecto: `http://es.archive.ubuntu.com/ubuntu`

### 4.7 Particionado del disco

Seleccionar: **Use an entire disk** (disco completo)

Distribución automática recomendada:

| Partición | Tamaño | Sistema de archivos | Punto de montaje |
|-----------|--------|---------------------|------------------|
| `/dev/sda1` | 1 MB | BIOS Boot | — |
| `/dev/sda2` | 2 GB | ext4 | `/boot` |
| `/dev/sda3` | ~21 GB | LVM (ext4) | `/` |
| Swap (LVM) | 2 GB | swap | — |

> Confirmar la escritura en el disco virtual → continuar

### 4.8 Configuración del perfil

| Campo | Valor |
|-------|-------|
| Your name | Santiago |
| Server name | `santyserver` |
| Username | `admin_tours` |
| Password | *(contraseña segura, mínimo 12 caracteres)* |

### 4.9 SSH Server

- ✅ Marcar **Install OpenSSH server**
- Instala y activa SSH automáticamente durante el setup

### 4.10 Snaps adicionales

- No seleccionar ninguno adicional → continuar

### 4.11 Finalización

El instalador copia los archivos y aplica las configuraciones. Tiempo estimado: 10–15 minutos.

Al finalizar:
1. Seleccionar **Reboot Now**
2. VirtualBox desmonta la ISO automáticamente
3. Pulsar Enter para continuar el arranque

---

## 5. Primer arranque y verificación

### 5.1 Login inicial

```
Ubuntu 22.04.4 LTS santyserver tty1
santyserver login: admin_tours
Password: ****
```

### 5.2 Verificar versión del sistema

```bash
lsb_release -a
```

Salida esperada:
```
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.4 LTS
Release:        22.04
Codename:       jammy
```

### 5.3 Verificar conectividad

```bash
ping -c 4 google.com
```

### 5.4 Actualizar el sistema

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 6. Resumen del proceso

```
┌─────────────────────────────────────────────────────┐
│         PROCESO DE IMPLANTACIÓN ISO                  │
├─────────────────────────────────────────────────────┤
│ 1. Descarga ISO Ubuntu Server 22.04.4 LTS            │
│ 2. Creación VM en VirtualBox                         │
│    → CPU: 2 núcleos | RAM: 4 GB | Disco: 25 GB       │
│    → Red: NAT (internet) + Puente (red local)        │
│ 3. Instalación Ubuntu Server:                        │
│    → Teclado ES / idioma EN                          │
│    → Particionado automático LVM                     │
│    → Usuario admin_tours creado                      │
│    → OpenSSH instalado durante el setup              │
│ 4. Primer arranque y actualización del sistema       │
└─────────────────────────────────────────────────────┘
```

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
