# 📋 Análisis de Necesidades de Red

**Módulo:** PAR — Planificación y Administración de Redes
**Proyecto:** The Santy's Tours — Proyecto Intermodular ASIR 2025/2026

---

## 1. Descripción de la empresa

The Santy's Tours es una agencia de turismo de ocio y aventura con sede en Barcelona. El equipo está formado por 2-3 personas que gestionan las operaciones desde la oficina y en campo.

La infraestructura tecnológica se divide en dos entornos:

- **Red local de oficina:** equipos físicos del equipo de trabajo
- **Infraestructura en la nube (AWS):** servidor EC2, base de datos RDS MySQL, almacenamiento S3 y servicios gestionados

No existe servidor físico en la oficina. Toda la lógica de negocio y los datos del sistema residen en AWS (región eu-west-1, Irlanda).

---

## 2. Equipos conectados a la red local

| Dispositivo | Cantidad | Conexión | Función |
|---|---|---|---|
| Portátil de desarrollo web | 1 | Ethernet / Wi-Fi | Desarrollo y mantenimiento del portal web |
| Portátil de desarrollo app/BBDD | 1 | Ethernet / Wi-Fi | Desarrollo de app móvil y gestión de base de datos |
| Portátil de administración | 1 | Ethernet / Wi-Fi | Reservas, atención al cliente, facturación |
| Smartphone de trabajo | 3 | Wi-Fi / 5G | Operativa en campo durante las experiencias |
| Impresora multifunción | 1 | Wi-Fi | Vouchers, tickets, documentación |
| Router con módem fibra | 1 | — | Acceso a internet y gateway de la red |
| Access Point Wi-Fi | 1 | Ethernet (uplink al router) | Cobertura inalámbrica extendida en la oficina |

**Total de dispositivos en red local:** 9 (3 portátiles + 3 smartphones + 1 impresora + 1 router + 1 AP)

---

## 3. Acceso a internet

| Parámetro | Detalle |
|---|---|
| Tipo de conexión | Fibra óptica simétrica |
| Velocidad contratada | 600 Mbps simétricos |
| Uso principal | Acceso a AWS (SSH, Samba, portal web), videoconferencias, correo, desarrollo |

El acceso a internet es crítico: todo el backend, la base de datos y el portal web están en la nube. Sin conexión, los empleados no pueden acceder a los servicios del sistema.

---

## 4. Servicios que se ofrecerán en la red

| Servicio | Dónde corre | Para qué se usa |
|---|---|---|
| DHCP | Router de oficina | Asignación automática de IPs a los equipos de la red local |
| DNS | Router (reenvío) + AWS Route 53 | Resolución de nombres y del dominio thesantystours.com |
| SSH (puerto 22) | Servidor EC2 en AWS | Acceso remoto seguro al servidor Ubuntu desde los portátiles |
| Samba (puerto 445) | Servidor EC2 en AWS | Compartición de carpetas entre el servidor y los clientes Windows |
| HTTP/HTTPS (puertos 80/443) | AWS (CloudFront + ALB + EC2) | Acceso al portal web y a la API REST |
| Wi-Fi (802.11ax / Wi-Fi 6) | Access Point de oficina | Conectividad inalámbrica para portátiles, smartphones e impresora |

---

## 5. Conclusión

La red de The Santy's Tours es una red local de oficina pequeña (menos de 10 dispositivos) que actúa como puente hacia la infraestructura cloud en AWS. Los requisitos principales son conexión a internet estable, cobertura Wi-Fi completa en la oficina y acceso seguro al servidor remoto EC2 mediante SSH y Samba.

---

*Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
