# 03 — Configuración Básica del Sistema

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

## 1. Nombre del equipo (hostname)

Verificar el hostname asignado durante la instalación:

```bash
hostname
```

Debe devolver: `santyserver`

Si se necesita cambiar:

```bash
sudo hostnamectl set-hostname santyserver
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

---

## 2. Configuración de red estática

Para un servidor de producción, la IP debe ser estática. Ubuntu Server 22.04 usa **Netplan** para la configuración de red.

### 2.1 Identificar interfaces de red

```bash
ip a
```

Interfaces esperadas:
- `enp0s3` — Adaptador NAT (internet)
- `enp0s8` — Adaptador puente (red local)

### 2.2 Editar la configuración Netplan

```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

Contenido a establecer:

```yaml
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: true
    enp0s8:
      dhcp4: false
      addresses:
        - 192.168.1.100/24
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
```

> La IP `192.168.1.100` se asigna de forma estática en la red local. Ajustar según el direccionamiento definido en el módulo PAR.

### 2.3 Aplicar la configuración

```bash
sudo netplan apply
```

### 2.4 Verificar conectividad

```bash
ip a show enp0s8
ping -c 3 192.168.1.1
```

---

## 3. Zona horaria

### 3.1 Verificar zona horaria actual

```bash
timedatectl
```

### 3.2 Establecer zona horaria de Barcelona

```bash
sudo timedatectl set-timezone Europe/Madrid
```

### 3.3 Verificar resultado

```bash
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

---

## 4. Localización del sistema

### 4.1 Configurar locale español

```bash
sudo locale-gen es_ES.UTF-8
sudo update-locale LANG=es_ES.UTF-8
```

### 4.2 Verificar locales disponibles

```bash
locale -a | grep es_ES
```

---

## 5. Actualizaciones automáticas de seguridad

### 5.1 Activar `unattended-upgrades`

```bash
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

Seleccionar **Yes** para activar las actualizaciones automáticas.

### 5.2 Verificar configuración

```bash
cat /etc/apt/apt.conf.d/20auto-upgrades
```

Contenido esperado:
```
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
```

---

## 6. Configuración del firewall (UFW)

### 6.1 Habilitar UFW

```bash
sudo ufw enable
```

### 6.2 Reglas para The Santy's Tours

```bash
# Acceso remoto SSH
sudo ufw allow ssh

# Portal web HTTP
sudo ufw allow 80/tcp

# Portal web HTTPS
sudo ufw allow 443/tcp

# Compartición de archivos Samba
sudo ufw allow samba
```

### 6.3 Verificar estado del firewall

```bash
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

---

## 7. Verificación final

```bash
# Nombre del equipo
hostname

# Versión del SO
lsb_release -a

# Zona horaria
timedatectl | grep "Time zone"

# IP estática asignada
ip a show enp0s8 | grep inet

# Estado del firewall
sudo ufw status

# Actualizaciones pendientes
sudo apt list --upgradable 2>/dev/null | wc -l
```

---

## 8. Resumen de configuración

| Parámetro | Valor |
|-----------|-------|
| Hostname | `santyserver` |
| IP servidor (red local) | `192.168.1.100/24` |
| IP NAT | DHCP automático |
| Zona horaria | `Europe/Madrid (CEST)` |
| Locale | `es_ES.UTF-8` |
| Firewall (UFW) | Activo — puertos 22, 80, 443, Samba |
| Actualizaciones automáticas | Activadas (`unattended-upgrades`) |

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
