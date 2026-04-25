# 🌐 PAR — Planificación y Administración de Redes

**Módulo:** Planificación y Administración de Redes (0370)
**Proyecto:** The Santy's Tours — Proyecto Intermodular ASIR 2025/2026

---

## Arquitectura de red

The Santy's Tours opera con una arquitectura de red dividida en dos entornos diferenciados: la **red local de oficina** y la **infraestructura cloud en AWS**.

### Red local de oficina

La red local sigue una **topología en estrella** con un router central (192.168.10.1) que actúa como gateway, servidor DHCP y firewall perimetral. Los portátiles de desarrollo se conectan directamente al router por **cable Ethernet**, garantizando la máxima estabilidad para tareas de desarrollo y acceso SSH. El portátil de administración, los smartphones y la impresora se conectan de forma inalámbrica a través de un **Access Point Wi-Fi 6** (192.168.10.5) en modo AP puro.

La red opera en el rango **192.168.10.0/24**. Los portátiles y la impresora tienen IPs fijas asignadas por reserva DHCP por MAC. Los smartphones y dispositivos ocasionales reciben IP dinámica del pool 192.168.10.100–200.

No existe servidor físico en la oficina. The Santy's Tours adopta un modelo **cloud-first** que delega toda la lógica de negocio a AWS, eliminando el coste y mantenimiento de hardware local.

### Conexión con la nube

La red local actúa como puente hacia la infraestructura cloud en AWS (región eu-west-1, Irlanda). Toda la conectividad pasa por internet a través de la línea de fibra simétrica de 600 Mbps.

Los portátiles de desarrollo acceden al servidor **EC2 t3.micro** (Ubuntu 22.04) mediante **SSH** (puerto 22) con autenticación por clave privada. La compartición de archivos con los clientes Windows se realiza mediante **Samba** (puerto 445). El portal web y la API REST son accesibles mediante **HTTPS** (puerto 443, TLS 1.3) a través de CloudFront, ALB y EC2. El dominio thesantystours.com está gestionado por **AWS Route 53**.

La base de datos **RDS MySQL** reside dentro de la VPC de AWS y solo es accesible desde el servidor EC2, nunca directamente desde la red de oficina.

### Seguridad de red

La seguridad opera en dos capas: el firewall del router bloquea todo el tráfico entrante no solicitado desde internet, y los **Security Groups de AWS** restringen el acceso al servidor EC2 permitiendo únicamente SSH y Samba desde la IP pública de la oficina, y HTTPS desde cualquier origen para el portal web.

---

## 📁 Documentación del módulo

| Documento | Descripción |
|---|---|
| [01-analisis.md](./01-analisis.md) | Análisis de necesidades de red: equipos, servicios y acceso a internet |
| [02-topologia.md](./02-topologia.md) | Diseño de la topología de red y diagrama de infraestructura |
| [03-direccionamiento.md](./03-direccionamiento.md) | Plan completo de direccionamiento IP (192.168.10.0/24) |
| [04-dispositivos.md](./04-dispositivos.md) | Identificación y descripción de los dispositivos de red |
| [05-servicios.md](./05-servicios.md) | Explicación de los servicios de red: DHCP, DNS, SSH, Samba, HTTPS |

---

*Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
