# 🌐 PAR — Planificación y Administración de Redes

**Módulo:** Planificación y Administración de Redes (0370)
**Proyecto:** The Santy's Tours — Proyecto Intermodular ASIR 2025/2026

---

## Arquitectura de red

The Santy's Tours opera con una arquitectura de red dividida en dos entornos diferenciados: la **red local de oficina** y la **infraestructura cloud en AWS**.

### Red local de oficina

La red local sigue una **topología en estrella** con un router central (192.168.10.1) que actúa como gateway, servidor DHCP y firewall perimetral. Todos los dispositivos de la oficina se conectan a él, ya sea por cable Ethernet o de forma inalámbrica a través de un Access Point Wi-Fi 6 (192.168.10.5) que extiende la cobertura por toda la oficina en modo AP puro.

La red opera en el rango **192.168.10.0/24**. Los tres portátiles de trabajo y la impresora tienen IPs asignadas de forma fija mediante reserva DHCP por MAC, lo que facilita la administración sin necesidad de configurar manualmente cada equipo. Los smartphones y dispositivos ocasionales reciben IP dinámica del pool 192.168.10.100–200.

No existe servidor físico en la oficina. La decisión es deliberada: The Santy's Tours adopta un modelo **cloud-first** que elimina el coste y mantenimiento de hardware local y delega toda la lógica de negocio a AWS.

### Conexión con la nube

La red local actúa como puente hacia la infraestructura cloud en AWS (región eu-west-1, Irlanda). Toda la conectividad pasa por internet a través de la línea de fibra simétrica de 600 Mbps.

Los portátiles de desarrollo acceden al servidor **EC2 t3.micro** (Ubuntu 22.04) mediante **SSH** (puerto 22) con autenticación por clave privada, lo que permite administrar el servidor, desplegar código y gestionar la base de datos de forma segura. La compartición de archivos entre el servidor y los clientes Windows se realiza mediante **Samba** (puerto 445), exponiendo dos recursos compartidos: uno de lectura/escritura para el equipo y uno público de solo lectura.

El portal web y la API REST son accesibles desde cualquier dispositivo mediante **HTTPS** (puerto 443, TLS 1.3), pasando por CloudFront (CDN), el ALB y finalmente el servidor EC2. La resolución de nombres del dominio thesantystours.com está gestionada por **AWS Route 53**.

La base de datos **RDS MySQL** reside dentro de la VPC de AWS y solo es accesible desde el propio servidor EC2, nunca directamente desde la red de oficina, lo que garantiza un nivel adicional de aislamiento y seguridad.

### Seguridad de red

La seguridad opera en dos capas: el firewall integrado en el router de oficina bloquea todo el tráfico entrante no solicitado desde internet hacia la red local, y los **Security Groups de AWS** restringen el acceso al servidor EC2 permitiendo únicamente SSH y Samba desde la IP pública de la oficina, y HTTPS desde cualquier origen para el portal web.

---

## 📁 Documentación del módulo

| Documento | Descripción |
|---|---|
| 01-analisis.md | Análisis de necesidades de red: equipos, servicios y acceso a internet |
| 02-topologia.md | Diseño de la topología de red y diagrama de infraestructura |
| 03-direccionamiento.md | Plan completo de direccionamiento IP (192.168.10.0/24) |
| 04-dispositivos.md | Identificación y descripción de los dispositivos de red |
| 05-servicios.md | Explicación de los servicios de red: DHCP, DNS, SSH, Samba, HTTPS |

---

*Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
