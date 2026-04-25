# 03 — Configuración Básica del Sistema

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

> **Nota sobre las evidencias:** Los procedimientos descritos corresponden al entorno de producción real. Las capturas aportadas fueron tomadas en un entorno de laboratorio (AWS Academy + VirtualBox) como evidencia práctica del proyecto intermodular ASIR.

---

## 1. Alcance de este documento

Este documento cubre la configuración básica de los dos sistemas operativos administrados directamente por el equipo técnico de The Santy's Tours:

| Sistema | Plataforma | Configuración aplicada |
|---------|-----------|----------------------|
| Servidor Ubuntu Server 22.04 LTS | AWS EC2 | Hostname, zona horaria, locale, actualizaciones, firewall |
| Equipos cliente Windows 11 Pro | Equipos físicos de oficina | Nombre, zona horaria, red, PuTTY, Samba |

> La configuración de los servicios gestionados AWS (RDS, S3, CloudFront, ALB, Route 53) está documentada en el **módulo MPO**, ya que no disponen de sistema operativo administrable.

---

## 2. PARTE A — Servidor Ubuntu Server en AWS EC2

> Todos los comandos se ejecutan conectado al servidor mediante **PuTTY** con la clave privada descargada de AWS.

### 2.1 Nombre del equipo (hostname)

```bash
sudo hostnamectl set-hostname santyserver
hostname
```

Verificar en `/etc/hosts`:
```bash
cat /etc/hosts
```

Debe contener:
```
127.0.0.1   localhost
127.0.1.1   santyserver
```

### 2.2 Red en AWS EC2

En AWS EC2 la red es gestionada por AWS — no se configura Netplan ni IP estática manualmente. En producción se asigna una **Elastic IP** para tener IP pública fija.

Verificar la configuración de red:
```bash
ip a
curl -s http://169.254.169.254/latest/meta-data/public-ipv4
```

### 2.3 Zona horaria

```bash
sudo timedatectl set-timezone Europe/Madrid
timedatectl
```

![Resultado de timedatectl mostrando Europe/Madrid CEST +0200](capturas/Captura%20de%20pantalla%2011.png)
*Captura 11 — timedatectl confirmando zona horaria Europe/Madrid (CEST, +0200)*

### 2.4 Localización del sistema

```bash
sudo locale-gen es_ES.UTF-8
sudo update-locale LANG=es_ES.UTF-8
locale -a | grep es_ES
```

### 2.5 Actualizaciones del sistema

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

### 2.6 Firewall — UFW

La primera línea de defensa es el **Security Group** de AWS. UFW actúa como segunda capa dentro de la instancia:

```bash
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow samba
sudo ufw enable
sudo ufw status verbose
```

![Resultado de ufw status verbose con puertos 22, 80 y 443 activos](capturas/Captura%20de%20pantalla%2012.png)
*Captura 12 — UFW activo con reglas SSH (22), HTTP (80) y HTTPS (443)*

### 2.7 Resumen de configuración del servidor

| Parámetro | Valor |
|-----------|-------|
| Hostname | `santyserver` |
| IP pública | Elastic IP fija (producción) |
| Zona horaria | `Europe/Madrid (CEST)` |
| Locale | `es_ES.UTF-8` |
| Firewall | Security Group AWS + UFW activo |
| Actualizaciones | Automáticas (`unattended-upgrades`) |

---

## 3. PARTE B — Equipos cliente Windows 11 Pro

Los equipos de administración son máquinas físicas con Windows 11 Pro instalado desde USB booteable (ver `02_plan_implantacion.md`).

### 3.1 Nombre del equipo

1. Inicio → Configuración → Sistema → Acerca de → **Cambiar nombre de este equipo**
2. Establecer: `SantysTours-Admin-01` (numeración por equipo)
3. Reiniciar para aplicar el cambio

![Configuración Sistema Información mostrando edición Windows 11 y nombre del equipo](capturas/Captura%20de%20pantalla%2020.png)
*Captura 20 — Sistema → Información: edición Windows 11 instalada en la VM SantysTours-Admin-01*

### 3.2 Zona horaria

1. Inicio → Configuración → Hora e idioma → Fecha y hora
2. Zona horaria: **(UTC+01:00) Madrid**
3. Activar **Establecer la hora automáticamente**

### 3.3 Red

Conectar el equipo a la red de la oficina. Verificar conectividad con el servidor:
```powershell
ping IP_PUBLICA_SERVIDOR
```

### 3.4 Instalación y configuración de PuTTY

PuTTY es el cliente SSH para administrar el servidor Ubuntu desde los equipos Windows de la oficina.

#### 3.4.1 Descarga e instalación

1. Descargar desde [https://www.putty.org](https://www.putty.org) → **putty-64bit-X.XX-installer.msi**
2. Ejecutar el instalador y completar la instalación

#### 3.4.2 Clave privada para autenticación

La clave privada en formato `.ppk` se descarga desde la consola AWS al crear la instancia EC2. Guardarla en `C:\Keys\` en cada equipo de administración.

#### 3.4.3 Configurar sesión SSH en PuTTY

1. Abrir **PuTTY**
2. **Host Name**: IP pública del servidor (o dominio Route 53)
3. **Port**: 22 / **Connection type**: SSH

![PuTTY configurado con IP del servidor, puerto 22, tipo SSH](capturas/Captura%20de%20pantalla%2006.png)
*Captura 06 — PuTTY Session con IP pública, puerto 22, conexión SSH*

4. **Connection → SSH → Auth → Credentials** → seleccionar el archivo `.ppk`

![PuTTY Auth Credentials con clave privada cargada](capturas/Captura%20de%20pantalla%2007.png)
*Captura 07 — PuTTY SSH → Auth → Credentials con clave privada cargada*

5. Volver a **Session** → **Saved Sessions**: `SantysTours-Server` → **Save**

#### 3.4.4 Conectar al servidor

1. Seleccionar sesión `SantysTours-Server` → **Open**
2. Primer acceso: aviso de clave del host → **Accept**

![PuTTY Security Alert al conectar por primera vez](capturas/Captura%20de%20pantalla%2008.png)
*Captura 08 — PuTTY Security Alert, se acepta la clave del host*

3. **login as:** `ubuntu`
4. El banner de The Santy's Tours aparece al conectarse

![Sesión PuTTY activa con banner de The Santy's Tours](capturas/Captura%20de%20pantalla%2009.png)
*Captura 09 — Sesión PuTTY activa: banner y bienvenida Ubuntu 22.04.5 LTS*

```bash
lsb_release -a
```

![lsb_release -a mostrando Ubuntu 22.04.5 LTS](capturas/Captura%20de%20pantalla%2010.png)
*Captura 10 — lsb_release -a confirmando Ubuntu 22.04.5 LTS (jammy)*

### 3.5 Resumen de configuración del cliente

| Parámetro | Valor |
|-----------|-------|
| Nombre del equipo | `SantysTours-Admin-01` |
| Zona horaria | `(UTC+01:00) Madrid` |
| Red | Ethernet/WiFi de la oficina |
| Cliente SSH | PuTTY con clave privada AWS |
| Acceso Samba | `\\IP_SERVIDOR` desde el Explorador de Windows |

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
