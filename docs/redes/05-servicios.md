# ⚙️ Servicios de Red

**Módulo:** PAR — Planificación y Administración de Redes
**Proyecto:** The Santy's Tours — Proyecto Intermodular ASIR 2025/2026

---

## 1. DHCP — Asignación dinámica de IPs

| Parámetro | Detalle |
|---|---|
| Dónde corre | Router de oficina (192.168.10.1) |
| Rango dinámico | 192.168.10.100 – 192.168.10.200 |
| Reservas por MAC | Portátiles (.20, .21, .30) e impresora (.40) |
| Lease time | 24 horas |

Cuando un dispositivo se conecta a la red, envía una petición DHCP al router. El router comprueba si la dirección MAC tiene una reserva configurada: si la tiene, le asigna siempre la misma IP; si no, le asigna una IP libre del rango dinámico. Además del IP, el router comunica el gateway (192.168.10.1) y los servidores DNS (8.8.8.8 y 1.1.1.1).

Esto evita configurar manualmente la red en cada equipo y garantiza que los portátiles de desarrollo siempre tengan la misma IP.

---

## 2. DNS — Resolución de nombres

| Parámetro | Detalle |
|---|---|
| DNS local | Router (reenvía consultas a servidores externos) |
| DNS externo primario | 8.8.8.8 (Google Public DNS) |
| DNS externo secundario | 1.1.1.1 (Cloudflare DNS) |
| DNS del portal web | AWS Route 53 — gestiona thesantystours.com |

Cuando un portátil accede a `thesantystours.com`, la petición DNS va al router, que la reenvía a los servidores externos. Estos consultan AWS Route 53, que devuelve la IP de CloudFront donde está alojado el portal web. Para el acceso SSH al servidor EC2, los desarrolladores usan la Elastic IP de AWS o el subdominio `server.thesantystours.com` configurado en Route 53.

---

## 3. SSH — Acceso remoto al servidor

| Parámetro | Detalle |
|---|---|
| Puerto | 22 (TCP) |
| Dónde corre | Servidor EC2 Ubuntu 22.04 en AWS |
| Cliente | PuTTY (Windows 11 Pro) |
| Autenticación | Clave privada AWS (.ppk) — sin contraseña |
| Usuario de acceso | ubuntu (usuario por defecto de AWS) |

Los portátiles de desarrollo conectan al servidor EC2 en AWS mediante SSH a través de internet. La autenticación se realiza con el par de claves vockey de AWS Academy — se descarga el archivo `labsuser.ppk` y se configura en PuTTY. El tráfico viaja cifrado de extremo a extremo.

Desde la sesión SSH los desarrolladores pueden desplegar nuevas versiones del código, gestionar usuarios y permisos, consultar logs del servidor Node.js, administrar la conexión a RDS MySQL y gestionar el bucket S3 mediante AWS CLI.

---

## 4. Samba — Compartición de archivos

| Parámetro | Detalle |
|---|---|
| Puerto | 445 (TCP) |
| Dónde corre | Servidor EC2 Ubuntu 22.04 en AWS |
| Clientes | Portátiles Windows 11 Pro de la oficina |
| Autenticación | Usuario y contraseña Samba |

Samba permite que los portátiles Windows de la oficina accedan a carpetas del servidor Ubuntu en AWS como si fueran unidades de red locales.

| Share | Ruta en servidor | Usuarios | Permisos |
|---|---|---|---|
| documentos | /srv/santysTours/documentos | empleado, admin_tours | Lectura / escritura |
| publico | /srv/santysTours/publico | Todos | Solo lectura |

---

## 5. HTTP/HTTPS — Servicios web

| Parámetro | Detalle |
|---|---|
| Puerto HTTP | 80 (redirección automática a HTTPS) |
| Puerto HTTPS | 443 (TLS 1.3) |
| Dónde corre | AWS: CloudFront → ALB → EC2 |
| Dominio | thesantystours.com |

El portal web y la API REST están desplegados en AWS y son accesibles desde cualquier dispositivo con conexión a internet. Todo el tráfico web utiliza HTTPS con TLS 1.3, garantizando la confidencialidad e integridad de los datos en tránsito.

---

## 6. Resumen de servicios

| Servicio | Puerto | Dónde corre | Usuarios |
|---|---|---|---|
| DHCP | 67/68 UDP | Router de oficina | Todos los dispositivos de la red local |
| DNS | 53 UDP/TCP | Router (reenvío) + Route 53 | Todos los dispositivos |
| SSH | 22 TCP | EC2 AWS | Portátiles de desarrollo y administración |
| Samba | 445 TCP | EC2 AWS | Portátiles Windows de oficina |
| HTTPS | 443 TCP | CloudFront + ALB + EC2 | Empleados y clientes externos |

---

*Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
