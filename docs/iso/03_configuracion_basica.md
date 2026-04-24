# 03 — Configuración Básica del Sistema

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

## 1. Contexto del entorno de prueba

| Componente | Entorno de prueba | Entorno real (producción futura) |
|-----------|------------------|----------------------------------|
| Servidor | AWS Academy (laboratorio para estudiantes) | AWS cuenta de producción |
| Equipos cliente | Windows 11 Pro en VirtualBox | Equipos físicos Windows 11 Pro |
| Acceso remoto | PuTTY desde VM Windows → AWS Academy | PuTTY desde equipos físicos → AWS producción |

---

## 2. PARTE A — Servidor Ubuntu Server en AWS Academy

> Todos los comandos se ejecutan conectado al servidor mediante **PuTTY**. Ver sección 3 para la configuración de PuTTY.

### 2.1 Nombre del equipo (hostname)

```bash
sudo hostnamectl set-hostname santyserver
hostname
```

Verificar en `/etc/hosts`:
```bash
cat /etc/hosts
```

### 2.2 Red en AWS Academy

En AWS Academy la red es gestionada por AWS. No se configura Netplan ni IP estática manualmente.

- **IP privada** fija dentro de la VPC
- **IP pública** dinámica (usar Elastic IP en producción)

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
```

### 2.5 Actualizaciones del sistema

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

### 2.6 Firewall — UFW

```bash
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow samba
sudo ufw enable
sudo ufw status verbose
```

![Resultado de ufw status verbose con puertos 22, 80 y 443 activos](capturas/Captura%20de%20pantalla%2012.png)
*Captura 12 — UFW activo con reglas SSH (22), HTTP (80) y HTTPS (443). El puerto 445 (Samba) está abierto a través del Security Group de AWS.*

### 2.7 Resumen de configuración del servidor

| Parámetro | Valor |
|-----------|-------|
| Hostname | `santyserver` |
| IP privada (VPC) | Asignada automáticamente por AWS |
| IP pública | Asignada por AWS Academy (dinámica) |
| Zona horaria | `Europe/Madrid (CEST)` |
| Locale | `es_ES.UTF-8` |
| Firewall | Security Group AWS + UFW activo |
| Actualizaciones automáticas | Activadas (`unattended-upgrades`) |

---

## 3. PARTE B — Cliente Windows 11 Pro en VirtualBox

### 3.1 Nombre del equipo

1. Inicio → Configuración → Sistema → Acerca de → **Cambiar nombre de este equipo**
2. Establecer: `SantysTours-Admin` → Reiniciar

### 3.2 Zona horaria

Inicio → Configuración → Hora e idioma → Fecha y hora → **(UTC+01:00) Madrid**

### 3.3 Red

La VM usa adaptador **NAT** de VirtualBox. No requiere configuración adicional.

### 3.4 Instalación y configuración de PuTTY

#### 3.4.1 Descarga e instalación

Descargar desde [https://www.putty.org](https://www.putty.org) → instalar.

#### 3.4.2 Obtener la clave privada desde AWS Academy

En AWS Academy el par de claves es **vockey**. Descargar directamente desde el panel del laboratorio:

- Panel AWS Academy → **Download PPK** → guardar `labsuser.ppk` en `C:\Keys\`

> No es necesario usar PuTTYgen — AWS Academy proporciona el .ppk directamente.

#### 3.4.3 Configurar la sesión SSH en PuTTY

1. Abrir **PuTTY**
2. **Host Name**: IP pública AWS Academy / **Port**: 22 / **SSH**

![PuTTY configurado con IP del servidor 100.31.58.43, puerto 22, tipo SSH](capturas/Captura%20de%20pantalla%2006.png)
*Captura 06 — PuTTY Session con IP pública 100.31.58.43, puerto 22, conexión SSH*

3. **Connection → SSH → Auth → Credentials** → seleccionar `labsuser.ppk`

![PuTTY Auth Credentials con labsuser.ppk seleccionado](capturas/Captura%20de%20pantalla%2007.png)
*Captura 07 — PuTTY SSH → Auth → Credentials con labsuser.ppk cargado*

4. **Session** → **Saved Sessions**: `SantysTours-Server` → **Save**

#### 3.4.4 Conectar al servidor

1. Sesión `SantysTours-Server` → **Open**
2. Aviso de clave del host → **Accept**

![PuTTY Security Alert al conectar por primera vez](capturas/Captura%20de%20pantalla%2008.png)
*Captura 08 — PuTTY Security Alert, se acepta la clave del host*

3. **login as:** `ubuntu` → conexión establecida con banner de The Santy's Tours

![Sesión PuTTY conectada mostrando el banner y el prompt ubuntu@ip](capturas/Captura%20de%20pantalla%2009.png)
*Captura 09 — Sesión PuTTY activa: banner "The Santy's Tours — Servidor Interno" y Ubuntu 22.04.5 LTS*

4. Verificar versión:
```bash
lsb_release -a
```

![lsb_release -a mostrando Ubuntu 22.04.5 LTS codename jammy](capturas/Captura%20de%20pantalla%2010.png)
*Captura 10 — lsb_release -a confirmando Ubuntu 22.04.5 LTS (jammy)*

### 3.5 Resumen de configuración del cliente

| Parámetro | Valor |
|-----------|-------|
| Nombre del equipo | `SantysTours-Admin` |
| Zona horaria | `(UTC+01:00) Madrid` |
| Red | NAT (VirtualBox) → AWS Academy |
| Clave SSH | `labsuser.ppk` (vockey de AWS Academy) |
| Cliente SSH | PuTTY — sesión `SantysTours-Server` |
| Acceso Samba | `\\IP_PUBLICA` desde Explorador de Windows |

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
