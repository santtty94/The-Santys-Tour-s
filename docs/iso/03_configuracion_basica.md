# 03 — Configuración Básica del Sistema

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

## 1. Contexto del entorno de prueba

Este documento cubre la configuración básica aplicada tras el lanzamiento de los dos sistemas del proyecto piloto:

| Componente | Entorno de prueba | Entorno real (producción futura) |
|-----------|------------------|----------------------------------|
| Servidor | AWS Academy (laboratorio para estudiantes) | AWS cuenta de producción |
| Equipos cliente | Windows 11 Pro en VirtualBox | Equipos físicos Windows 11 Pro |
| Acceso remoto | PuTTY desde VM Windows → AWS Academy | PuTTY desde equipos físicos → AWS producción |

> Todos los procedimientos son directamente aplicables al entorno de producción real.

---

## 2. PARTE A — Servidor Ubuntu Server en AWS Academy

> Todos los comandos de esta sección se ejecutan conectado al servidor mediante **PuTTY** desde el equipo cliente Windows 11 Pro. Ver sección 3 para la configuración de PuTTY.

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

### 2.2 Red en AWS Academy

En AWS Academy, la red es gestionada completamente por AWS. **No se configura Netplan ni IP estática manualmente.** AWS asigna automáticamente:

- **IP privada** fija dentro de la VPC — permanente mientras exista la instancia
- **IP pública** dinámica — puede cambiar si la instancia se reinicia o para

> Para producción real se asignará una **Elastic IP** para tener IP pública fija.

Verificar la red:
```bash
ip a
curl -s http://169.254.169.254/latest/meta-data/public-ipv4
```

### 2.3 Zona horaria

```bash
sudo timedatectl set-timezone Europe/Madrid
timedatectl
```

![Resultado de timedatectl mostrando Europe/Madrid CEST +0200](capturas/Captura_de_pantalla_11.png)
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

En AWS Academy la primera línea de defensa es el **Security Group**. UFW actúa como segunda capa dentro de la instancia:

```bash
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow samba
sudo ufw enable
sudo ufw status verbose
```

![Resultado de ufw status verbose con puertos 22, 80 y 443 activos](capturas/Captura_de_pantalla_12.png)
*Captura 12 — UFW activo con reglas SSH (22), HTTP (80) y HTTPS (443). Nota: el perfil Samba no se encontró en UFW; el puerto 445 está abierto a través del Security Group de AWS.*

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
2. Establecer: `SantysTours-Admin`
3. Reiniciar para aplicar el cambio

### 3.2 Zona horaria

1. Inicio → Configuración → Hora e idioma → Fecha y hora
2. Zona horaria: **(UTC+01:00) Madrid**
3. Activar **Establecer la hora automáticamente**

### 3.3 Red

La VM Windows 11 Pro usa el adaptador **NAT** de VirtualBox para acceder a internet y conectarse al servidor en AWS Academy mediante su IP pública. No requiere configuración adicional.

Verificar conectividad:
```powershell
ping IP_PUBLICA_SERVIDOR
```

### 3.4 Instalación y configuración de PuTTY

PuTTY es el cliente SSH para administrar el servidor Ubuntu desde Windows 11 Pro.

#### 3.4.1 Descarga e instalación de PuTTY

1. Descargar desde [https://www.putty.org](https://www.putty.org) → **putty-64bit-X.XX-installer.msi**
2. Ejecutar el instalador → completar la instalación
3. Verificar que **PuTTY** aparece en el menú de inicio

#### 3.4.2 Obtener la clave privada desde AWS Academy

En AWS Academy el par de claves utilizado es **vockey** (par de claves por defecto del laboratorio). La clave privada se descarga directamente desde el panel del laboratorio:

1. En el panel de AWS Academy → clic en **Download PEM** o **Download PPK**
2. Para PuTTY en Windows → seleccionar **Download PPK**
3. Guardar el archivo `labsuser.ppk` en `C:\Keys\` dentro de la VM Windows 11 Pro

> **No es necesario usar PuTTYgen** — AWS Academy ya proporciona el archivo en formato .ppk listo para PuTTY.

#### 3.4.3 Configurar la sesión SSH en PuTTY

1. Abrir **PuTTY**
2. **Host Name**: IP pública del servidor AWS Academy
3. **Port**: 22 / **Connection type**: SSH

![PuTTY configurado con IP del servidor 100.31.58.43, puerto 22, tipo SSH](capturas/Captura_de_pantalla_06.png)
*Captura 06 — PuTTY Session con IP pública 100.31.58.43, puerto 22, conexión SSH*

4. Panel izquierdo → **Connection → SSH → Auth → Credentials**
5. **Private key file for authentication** → **Browse** → seleccionar `C:\Keys\labsuser.ppk`

![PuTTY Auth Credentials con labsuser.ppk seleccionado como clave privada](capturas/Captura_de_pantalla_07.png)
*Captura 07 — PuTTY SSH → Auth → Credentials con labsuser.ppk cargado*

6. Volver a **Session** → **Saved Sessions**: escribir `SantysTours-Server` → **Save**

#### 3.4.4 Conectar al servidor

1. Seleccionar sesión `SantysTours-Server` → **Open**
2. Primer acceso: aviso de seguridad sobre la clave del host → **Accept**

![PuTTY Security Alert — aviso de verificación de clave del host](capturas/Captura_de_pantalla_08.png)
*Captura 08 — PuTTY Security Alert al conectar por primera vez, se acepta la clave del host*

3. **login as:** `ubuntu`
4. Conexión establecida — se muestra el banner de The Santy's Tours

![Sesión PuTTY conectada al servidor mostrando el banner y el prompt ubuntu@ip](capturas/Captura_de_pantalla_09.png)
*Captura 09 — Sesión PuTTY activa: banner "The Santy's Tours — Servidor Interno" y bienvenida a Ubuntu 22.04.5 LTS*

5. Verificar versión del sistema:

```bash
lsb_release -a
```

![lsb_release -a mostrando Ubuntu 22.04.5 LTS codename jammy](capturas/Captura_de_pantalla_10.png)
*Captura 10 — lsb_release -a confirmando Ubuntu 22.04.5 LTS (jammy), sesión PuTTY activa*

### 3.5 Resumen de configuración del cliente

| Parámetro | Valor |
|-----------|-------|
| Nombre del equipo | `SantysTours-Admin` |
| Zona horaria | `(UTC+01:00) Madrid` |
| Red | NAT (VirtualBox) → acceso a internet y AWS Academy |
| Clave SSH | `labsuser.ppk` (vockey de AWS Academy) |
| Cliente SSH | PuTTY — sesión guardada `SantysTours-Server` |
| Acceso Samba | `\\IP_PUBLICA` desde el Explorador de Windows |

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
