# 🔌 Dispositivos de Red

**Módulo:** PAR — Planificación y Administración de Redes
**Proyecto:** The Santy's Tours — Proyecto Intermodular ASIR 2025/2026

---

## 1. Router / Módem de fibra

| Campo | Detalle |
|---|---|
| Función | Gateway de la red local. Conecta la oficina a internet. |
| IP | 192.168.10.1 |
| Ejemplo de modelo | ASUS RT-AX86U (Wi-Fi 6) o equivalente del ISP |
| Puertos LAN | 4x Gigabit Ethernet |
| Puerto WAN | 1x (fibra ONT) |
| Wi-Fi integrado | Wi-Fi 6 (2.4 GHz + 5 GHz) |
| Servicios que presta | DHCP, NAT, firewall básico, DNS forwarder |

El router es el dispositivo central de la red. Recibe la señal de internet de la operadora de fibra óptica y la distribuye al resto de equipos. Gestiona la asignación automática de IPs (DHCP) y actúa como puerta de enlace para todas las comunicaciones que salen hacia internet, incluidas las conexiones al servidor EC2 en AWS.

---

## 2. Access Point Wi-Fi

| Campo | Detalle |
|---|---|
| Función | Ampliar y mejorar la cobertura inalámbrica de la oficina |
| IP de gestión | 192.168.10.5 |
| Ejemplo de modelo | TP-Link EAP670 (Wi-Fi 6) o similar |
| Conexión al router | Cable Ethernet Gigabit (modo AP puro, sin NAT) |
| Estándar Wi-Fi | 802.11ax (Wi-Fi 6) — 2.4 GHz + 5 GHz |

El Access Point se conecta al router por cable Ethernet y funciona en **modo AP puro**: extiende la señal Wi-Fi por toda la oficina sin crear una subred adicional. Todos los dispositivos inalámbricos (portátiles, smartphones, impresora) se conectan a través de él. La elección de Wi-Fi 6 es coherente con los portátiles Lenovo Legion 5, que incorporan adaptadores Wi-Fi 6 nativamente.

---

## 3. Firewall

| Campo | Detalle |
|---|---|
| Nivel 1 | Firewall integrado en el router (red local) |
| Nivel 2 | AWS Security Groups (servidor EC2) |
| Tipo | Stateful firewall — inspección de estado de conexiones |

El firewall opera en dos niveles:

**Router de oficina:** incorpora NAT y firewall básico que impide el acceso directo desde internet a los equipos de la red local. Bloquea por defecto todo el tráfico entrante no solicitado.

**AWS Security Groups:** protegen el servidor EC2 a nivel de instancia. Solo se permiten las conexiones necesarias:

| Puerto | Protocolo | Origen permitido | Uso |
|---|---|---|---|
| 22 | TCP | IP pública de la oficina | SSH — acceso remoto al servidor |
| 445 | TCP | IP pública de la oficina | Samba — compartición de archivos |
| 80 | TCP | 0.0.0.0/0 | HTTP (redirección a HTTPS) |
| 443 | TCP | 0.0.0.0/0 | HTTPS — portal web y API REST |
| 3306 | TCP | VPC interna | MySQL — solo desde dentro de la VPC |

---

## 4. Resumen de dispositivos de red

| Dispositivo | Cantidad | IP | Función principal |
|---|---|---|---|
| Router / Módem fibra | 1 | 192.168.10.1 | Gateway, DHCP, NAT, firewall básico |
| Access Point Wi-Fi 6 | 1 | 192.168.10.5 | Cobertura inalámbrica extendida |
| Firewall | — | Integrado en router + AWS SG | Protección del perímetro de red |

> **Evolución futura:** si la empresa crece, se recomienda añadir un switch gestionable de 8-16 puertos para segmentar la red en VLANs (desarrollo / administración / invitados) y disponer de más puertos Ethernet.

---

*Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
