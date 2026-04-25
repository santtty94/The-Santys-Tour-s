# 🌐 PAR — Planificación y Administración de Redes

**Módulo:** Planificación y Administración de Redes (0370)
**Proyecto:** The Santy's Tours — Proyecto Intermodular ASIR 2025/2026

---

## 📋 Descripción

Este módulo documenta el diseño y la administración de la infraestructura de red de **The Santy's Tours**, agencia de turismo de ocio y aventura con sede en Barcelona. La red conecta los equipos de oficina entre sí y con la infraestructura cloud en AWS (eu-west-1): servidor EC2, RDS MySQL, S3, Route 53, CloudFront y ALB.

---

## 📁 Contenido de esta carpeta

| Documento | Descripción |
|---|---|
| 01-analisis.md | Análisis de necesidades de red: equipos, servicios y acceso a internet |
| 02-topologia.md | Diseño de la topología de red y diagrama de infraestructura |
| 03-direccionamiento.md | Plan completo de direccionamiento IP (192.168.10.0/24) |
| 04-dispositivos.md | Identificación y descripción de los dispositivos de red |
| 05-servicios.md | Explicación de los servicios de red: DHCP, DNS, SSH, Samba, HTTPS |

---

## 📊 Plan de direccionamiento IP

| Dispositivo | IP | Tipo |
|---|---|---|
| Router / Gateway | 192.168.10.1 | Estática |
| Access Point | 192.168.10.5 | Estática |
| Portátil Desarrollo Web | 192.168.10.20 | DHCP reservado |
| Portátil Desarrollo App/BBDD | 192.168.10.21 | DHCP reservado |
| Portátil Administración | 192.168.10.30 | DHCP reservado |
| Impresora multifunción | 192.168.10.40 | DHCP reservado |
| Smartphones / visitas | 192.168.10.100-200 | DHCP dinámico |

**Red:** 192.168.10.0/24 - **Máscara:** 255.255.255.0 - **Gateway:** 192.168.10.1

---

## 🔗 Integración con otros módulos

| Módulo | Relación |
|---|---|
| FHW — Hardware | Equipos de esta red descritos en el módulo de hardware |
| MPO — Cloud | Infraestructura remota AWS con la que conecta esta red |
| ISO — Sistemas | SSH y Samba configurados en el servidor Ubuntu EC2 |
| GBD — Base de Datos | RDS MySQL accesible solo dentro de la VPC de AWS |

---

*Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
