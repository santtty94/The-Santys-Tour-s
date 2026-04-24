# 03 — Configuración Básica del Sistema

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

## 1. Alcance de este documento

Este documento cubre la configuración básica aplicada tras el lanzamiento de los dos sistemas del proyecto:

| Sistema | Plataforma | Configuración aplicada |
|---------|-----------|----------------------|
| Servidor Ubuntu Server 22.04 LTS | AWS EC2 t3.micro | Hostname, zona horaria, locale, actualizaciones, firewall (UFW) |
| Cliente Windows 11 Pro | VirtualBox (Lenovo Legion 5) | Nombre del equipo, zona horaria, red, acceso SSH y Samba |

---

## 2. PARTE A — Servidor Ubuntu Server en AWS EC2

> Todos los comandos de esta sección se ejecutan conectado al servidor por SSH:
> ```powershell
> ssh -i santysTours-key.pem ubuntu@IP_PUBLICA
> ```

### 2.1 Nombre del equipo (hostname)

Verificar y establecer el hostname del servidor:

```bash
hostnamectl set-hostname santyserver
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

En AWS EC2, la red es gestionada completamente por AWS. **No se configura Netplan ni IP estática manualmente.** AWS asigna automáticamente:

- **IP privada** fija dentro de la VPC (Virtual Private Cloud) — permanente
- **IP pública** dinámica — puede cambiar si la instancia se reinicia (se recomienda asignar una Elastic IP para producción)

Verificar la configuración de red:

```bash
ip a
```

Para consultar la IP pública desde la propia instancia:

```bash
curl -s http://169.254.169.254/latest/meta-data/public-ipv4
```

### 2.3 Zona horaria

```bash
sudo timedatectl set-timezone Europe/Madrid
timedatectl
```

Salida esperada:
```
               Local time: Thu 2026-04-23 10:30:00 CEST
           Universal time: Thu 2026-04-23 08:30:00 UTC
                Time zone: Europe/Madrid (CEST, +0200)
System clock synchronized: yes
              NTP service: active
```

### 2.4 Localización del sistema

```bash
sudo locale-gen es_ES.UTF-8
sudo update-locale LANG=es_ES.UTF-8
locale -a | grep es_ES
```

### 2.5 Actualizaciones del sistema

```bash
sudo apt update && sudo apt upgrade -y
```

Activar actualizaciones automáticas de seguridad:

```bash
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

Verificar:

```bash
cat /etc/apt/apt.conf.d/20auto-upgrades
```

Contenido esperado:
```
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
```

### 2.6 Firewall — UFW

En AWS EC2 la primera línea de seguridad es el **Security Group** configurado durante el lanzamiento (puertos 22, 80, 443, 445). Adicionalmente se activa UFW dentro de la instancia como segunda capa:

```bash
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow samba
sudo ufw enable
sudo ufw status verbose
```

Salida esperada:
```
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
80/tcp                     ALLOW IN    Anywhere
443/tcp                    ALLOW IN    Anywhere
Samba                      ALLOW IN    Anywhere
```

### 2.7 Resumen de configuración del servidor

| Parámetro | Valor |
|-----------|-------|
| Hostname | `santyserver` |
| IP privada (AWS VPC) | Asignada automáticamente por AWS |
| IP pública | Asignada por AWS (usar Elastic IP en producción) |
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

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

## 1. Contexto del entorno de prueba

Este módulo se ejecuta en un **entorno de prueba piloto** que simula la infraestructura real del proyecto:

| Componente | Entorno de prueba | Entorno real (producción futura) |
|-----------|------------------|----------------------------------|
| Servidor | AWS Academy (laboratorio para estudiantes) | AWS cuenta de producción |
| Equipos cliente | Windows 11 Pro en VirtualBox | Equipos físicos Windows 11 Pro |
| Acceso remoto | PuTTY desde VM Windows en VirtualBox | PuTTY desde equipos físicos de oficina |

> El objetivo es demostrar los conocimientos técnicos y validar el funcionamiento del sistema antes de su despliegue real. Todos los procedimientos documentados son directamente aplicables al entorno de producción.

---

## 2. PARTE A — Servidor Ubuntu Server en AWS Academy

> Todos los comandos de esta sección se ejecutan conectado al servidor mediante **PuTTY** desde el equipo cliente Windows 11 Pro (VirtualBox). Ver sección 3 para la configuración de PuTTY.

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

En AWS Academy, igual que en AWS producción, la red es gestionada completamente por AWS. **No se configura Netplan ni IP estática manualmente.**

AWS asigna automáticamente:
- **IP privada** fija dentro de la VPC — permanente mientras exista la instancia
- **IP pública** dinámica — puede cambiar si la instancia se reinicia o para

> **Nota para producción real:** Se asignará una **Elastic IP** para tener una IP pública fija y estable.

Verificar la red desde la terminal del servidor:

```bash
ip a
```

Consultar la IP pública desde la propia instancia:

```bash
curl -s http://169.254.169.254/latest/meta-data/public-ipv4
```

### 2.3 Zona horaria

```bash
sudo timedatectl set-timezone Europe/Madrid
timedatectl
```

Salida esperada:
```
               Local time: Thu 2026-04-23 10:30:00 CEST
           Universal time: Thu 2026-04-23 08:30:00 UTC
                Time zone: Europe/Madrid (CEST, +0200)
System clock synchronized: yes
              NTP service: active
```

### 2.4 Localización del sistema

```bash
sudo locale-gen es_ES.UTF-8
sudo update-locale LANG=es_ES.UTF-8
locale -a | grep es_ES
```

### 2.5 Actualizaciones del sistema

```bash
sudo apt update && sudo apt upgrade -y
```

Activar actualizaciones automáticas de seguridad:

```bash
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

Verificar:

```bash
cat /etc/apt/apt.conf.d/20auto-upgrades
```

Contenido esperado:
```
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
```

### 2.6 Firewall — UFW

En AWS Academy, igual que en producción, la primera línea de defensa es el **Security Group** configurado durante el lanzamiento. UFW actúa como segunda capa de seguridad dentro de la instancia:

```bash
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow samba
sudo ufw enable
sudo ufw status verbose
```

Salida esperada:
```
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
80/tcp                     ALLOW IN    Anywhere
443/tcp                    ALLOW IN    Anywhere
Samba                      ALLOW IN    Anywhere
```

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

La VM Windows 11 Pro usa el adaptador **NAT** de VirtualBox para acceder a internet y conectarse al servidor en AWS Academy mediante su IP pública. No requiere configuración de red adicional.

Verificar conectividad con el servidor desde PowerShell:

```powershell
ping IP_PUBLICA_SERVIDOR
```

### 3.4 Instalación y configuración de PuTTY

PuTTY es el cliente SSH que usaremos desde Windows 11 Pro para administrar el servidor Ubuntu en AWS. Incluye **PuTTYgen** para convertir la clave del formato AWS (.pem) al formato PuTTY (.ppk).

#### 3.4.1 Descarga e instalación

1. Descargar PuTTY desde [https://www.putty.org](https://www.putty.org) → **putty-64bit-X.XX-installer.msi**
2. Ejecutar el instalador y completar la instalación
3. Verificar que están disponibles tanto **PuTTY** como **PuTTYgen** en el menú de inicio

#### 3.4.2 Convertir la clave .pem a .ppk con PuTTYgen

AWS proporciona la clave en formato **.pem** pero PuTTY requiere formato **.ppk**:

1. Abrir **PuTTYgen**
2. Clic en **Load** → cambiar el filtro a *All Files (*.*)* → seleccionar `santysTours-key.pem`
3. PuTTYgen importa la clave automáticamente
4. Clic en **Save private key** → confirmar sin passphrase → guardar como `santysTours-key.ppk`
5. Guardar el archivo `santysTours-key.ppk` en `C:\Keys\`

#### 3.4.3 Configurar la sesión SSH en PuTTY

1. Abrir **PuTTY**
2. En **Host Name**: introducir la IP pública del servidor AWS Academy
3. **Port**: 22
4. **Connection type**: SSH
5. En el panel izquierdo ir a **Connection → SSH → Auth → Credentials**
6. En **Private key file for authentication**: clic en **Browse** → seleccionar `C:\Keys\santysTours-key.ppk`
7. Volver a **Session** → en **Saved Sessions** escribir `SantysTours-Server` → clic en **Save**

#### 3.4.4 Conectar al servidor

1. Seleccionar la sesión guardada `SantysTours-Server` → clic en **Open**
2. En el primer acceso PuTTY mostrará un aviso de seguridad sobre la clave del host → clic en **Accept**
3. En el prompt **login as:** escribir `ubuntu`
4. La conexión se establece automáticamente con la clave .ppk (sin contraseña)
5. Debe aparecer el prompt: `ubuntu@santyserver:~$`

### 3.5 Resumen de configuración del cliente

| Parámetro | Valor |
|-----------|-------|
| Nombre del equipo | `SantysTours-Admin` |
| Zona horaria | `(UTC+01:00) Madrid` |
| Red | NAT (VirtualBox) → acceso a internet y AWS Academy |
| Cliente SSH | PuTTY con clave `santysTours-key.ppk` |
| Sesión guardada | `SantysTours-Server` → IP pública AWS |
| Acceso Samba | `\\IP_PUBLICA` desde el Explorador de Windows |

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
