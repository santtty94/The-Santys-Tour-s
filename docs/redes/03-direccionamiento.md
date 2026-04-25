# 📊 Plan de Direccionamiento IP

**Módulo:** PAR — Planificación y Administración de Redes
**Proyecto:** The Santy's Tours — Proyecto Intermodular ASIR 2025/2026

---

## 1. Parámetros de la red

| Parámetro | Valor |
|---|---|
| Dirección de red | 192.168.10.0 |
| Máscara de red | 255.255.255.0 (/24) |
| Prefijo CIDR | 192.168.10.0/24 |
| Dirección de broadcast | 192.168.10.255 |
| Rango total de hosts | 192.168.10.1 – 192.168.10.254 |
| Número de hosts disponibles | 254 |
| Puerta de enlace (gateway) | 192.168.10.1 |

---

## 2. Tabla de direccionamiento IP

| Dispositivo | IP | Tipo | Observaciones |
|---|---|---|---|
| Router / Gateway | 192.168.10.1 | Estática | Gateway de la red. Servidor DHCP. |
| Access Point Wi-Fi | 192.168.10.5 | Estática | IP de gestión del AP. Uplink al router por Ethernet. |
| Portátil Desarrollo Web | 192.168.10.20 | DHCP reservado por MAC | Lenovo Legion 5 — i9 / 32GB. Desarrollo web. |
| Portátil Desarrollo App/BBDD | 192.168.10.21 | DHCP reservado por MAC | Lenovo Legion 5 — i9 / 32GB. Desarrollo app y BBDD. |
| Portátil Administración | 192.168.10.30 | DHCP reservado por MAC | Gama media — i5 / 16GB. Back-office y atención al cliente. |
| Impresora multifunción | 192.168.10.40 | DHCP reservado por MAC | IP fija para facilitar la impresión desde todos los equipos. |
| Smartphones x3 | 192.168.10.100 – .102 | DHCP dinámico | Acceso ocasional a la Wi-Fi de oficina. |
| **Pool DHCP general** | **192.168.10.100 – 192.168.10.200** | **Dinámica** | Visitas, dispositivos temporales y futuros equipos. |

---

## 3. Rangos reservados

| Rango | Uso |
|---|---|
| 192.168.10.1 – 192.168.10.9 | Dispositivos de red (router, AP, switch futuro) |
| 192.168.10.10 – 192.168.10.49 | Equipos de oficina con IP fija (portátiles, impresora) |
| 192.168.10.50 – 192.168.10.99 | Reservado para futuros equipos fijos adicionales |
| 192.168.10.100 – 192.168.10.200 | Pool DHCP dinámico (smartphones, visitas, nuevos equipos) |
| 192.168.10.201 – 192.168.10.254 | Reservado para crecimiento futuro |

---

## 4. Configuración del servidor DHCP (router)

| Parámetro | Valor |
|---|---|
| Rango de asignación dinámica | 192.168.10.100 – 192.168.10.200 |
| Puerta de enlace (opción 3) | 192.168.10.1 |
| DNS primario (opción 6) | 8.8.8.8 (Google DNS) |
| DNS secundario (opción 6) | 1.1.1.1 (Cloudflare DNS) |
| Tiempo de concesión (lease time) | 24 horas |
| Reservas DHCP por MAC | Portátiles (.20, .21, .30) e impresora (.40) |

Las IPs de los portátiles y la impresora se asignan mediante **reserva DHCP por dirección MAC**, no mediante configuración estática en cada equipo. Esto simplifica la gestión: si se cambia un equipo, basta con actualizar la MAC en el router.

---

## 5. Nota sobre la infraestructura AWS

El servidor EC2 en AWS tiene una **IP pública** asignada por AWS (Elastic IP) y una **IP privada** dentro de la VPC de AWS. Estas IPs no pertenecen al rango `192.168.10.0/24` de la red local de oficina. La comunicación entre la oficina y el servidor EC2 se realiza siempre a través de internet, usando el dominio `thesantystours.com` o la Elastic IP del servidor para SSH.

---

*Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
