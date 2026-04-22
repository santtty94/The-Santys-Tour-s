# 💰 Estimación de Costes Cloud

**Módulo:** MPO — Fundamentos de Computación en la Nube  
**Proyecto:** The Santy's Tours  

---

## Servicios cloud utilizados

### Amazon EC2 (Elastic Compute Cloud)
- **Instancia:** t3.micro (1 vCPU, 1 GB RAM)
- **Sistema operativo:** Ubuntu Server 22.04 LTS
- **Función:** Servidor de aplicación — ejecuta el backend Node.js y la API REST
- **Free Tier:** ✅ 750 horas/mes durante los primeros 12 meses

### Amazon RDS (Relational Database Service)
- **Motor:** MySQL 8.0
- **Instancia:** db.t3.micro
- **Almacenamiento:** 20 GB SSD
- **Función:** Base de datos gestionada — almacena usuarios, tours, reservas, pagos y valoraciones. AWS gestiona las copias de seguridad diarias automáticamente
- **Free Tier:** ✅ 750 horas/mes durante los primeros 12 meses

### Amazon S3 (Simple Storage Service)
- **Función:** Almacenamiento de imágenes de tours, fotos de guías y documentos PDF
- **Capacidad inicial estimada:** 5-10 GB
- **Free Tier:** ✅ 5 GB durante los primeros 12 meses

### Amazon CloudFront (CDN)
- **Función:** Distribución global de contenido estático — sirve imágenes y archivos desde el servidor más cercano al usuario
- **Free Tier:** ✅ 1 TB de transferencia/mes durante los primeros 12 meses

### Amazon Route 53
- **Función:** Gestión del dominio thesantystours.com
- **Free Tier:** ❌ No incluido

### Application Load Balancer (ALB)
- **Función:** Distribuye el tráfico entre instancias EC2 en temporada alta
- **Free Tier:** ✅ 750 horas/mes durante los primeros 12 meses

---

## Costes durante el Free Tier (primeros 12 meses)

| Servicio | Recursos incluidos | Coste/mes |
|---------|-------------------|-----------|
| EC2 t3.micro | 750 h/mes | **0,00 €** |
| RDS db.t3.micro | 750 h/mes + 20 GB | **0,00 €** |
| S3 | Hasta 5 GB | **0,00 €** |
| CloudFront | Hasta 1 TB transferencia | **0,00 €** |
| Route 53 | Zona DNS alojada | **~0,50 €** |
| ALB | 750 h/mes | **0,00 €** |
| **TOTAL** | | **~0,50 €/mes** |

> Durante los primeros 12 meses la infraestructura completa cuesta prácticamente **0 €**, lo que permite validar el negocio sin inversión en infraestructura.

---

## Costes a partir del mes 13 (sin Free Tier)

| Servicio | Especificaciones | Coste/mes |
|---------|----------------|-----------|
| EC2 t3.micro | On-Demand, región EU (Irlanda) | ~8,50 € |
| RDS db.t3.micro | 20 GB SSD, región EU | ~15,00 € |
| S3 | 10 GB almacenamiento | ~0,23 € |
| CloudFront | 50 GB transferencia | ~0,50 € |
| Route 53 | 1 zona DNS | ~0,50 € |
| **TOTAL** | | **~24,73 €/mes** |

> Una infraestructura profesional en cloud para The Santy's Tours cuesta aproximadamente **25 € al mes** — equivalente al precio de una sola reserva de tour.

---

## Escalabilidad futura

Si el negocio crece y el tráfico aumenta, se puede escalar progresivamente:

| Servicio | Upgrade | Coste adicional |
|---------|---------|----------------|
| EC2 | t3.small (2 GB RAM) | +8 €/mes |
| RDS | db.t3.small + Multi-AZ | +30 €/mes |
| Auto Scaling | Instancias adicionales en temporada alta | Variable |

---

## Herramienta utilizada para el cálculo

Los costes se han calculado con la **calculadora oficial de AWS**:  
[https://calculator.aws/pricing/2/homeScreen](https://calculator.aws/pricing/2/homeScreen)

Región de referencia: **eu-west-1 (Irlanda)**

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
