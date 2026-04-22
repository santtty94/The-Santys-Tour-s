# ☁️ MPO — Fundamentos de Computación en la Nube

**Proyecto:** The Santy's Tours  
**Módulo:** Fundamentos de Computación en la Nube (MPO)  
**Ciclo:** ASIR — Administración de Sistemas Informáticos en Red  
**Curso:** 2025/2026

---

## 🏢 Contexto de la empresa

**The Santy's Tours** es una plataforma digital de turismo de ocio y aventura con sede en Barcelona. Ofrece tours guiados, experiencias culturales y actividades en la ciudad a turistas nacionales e internacionales.

La plataforma se compone de:
- **Portal web** para búsqueda y reserva de tours
- **Aplicación móvil** para gestión de reservas en tiempo real
- **Panel de administración** para guías y gestores
- **API REST** como backend central del sistema

Usuarios del sistema: turistas, guías turísticos y administradores de la plataforma.

---

## 1. Elección del Proveedor Cloud

### Proveedor elegido: Amazon Web Services (AWS)

Tras analizar los principales proveedores del mercado (AWS, Google Cloud, Microsoft Azure y DigitalOcean), se ha elegido **AWS** por los siguientes motivos:

### ¿Por qué AWS para The Santy's Tours?

**1. Madurez y fiabilidad**  
AWS es el proveedor cloud líder mundial con más de 15 años en el mercado. Su infraestructura global garantiza una disponibilidad del 99,99%, crítica para una plataforma de reservas donde la caída del servicio implica pérdida directa de ventas.

**2. Cobertura geográfica**  
AWS dispone de regiones en Europa (Irlanda, Frankfurt, París), lo que permite alojar los datos dentro de la Unión Europea, cumpliendo con el **RGPD** (Reglamento General de Protección de Datos), obligatorio para una empresa que gestiona datos personales de turistas.

**3. Free Tier generoso**  
AWS ofrece una capa gratuita de 12 meses que cubre prácticamente toda la infraestructura necesaria para la fase inicial del proyecto, lo que permite arrancar sin coste.

**4. Escalabilidad**  
En temporada alta (verano, festivos), el tráfico de The Santy's Tours puede multiplicarse. AWS permite escalar recursos automáticamente sin necesidad de cambiar de proveedor ni migrar datos.

**5. Servicios integrados**  
AWS ofrece en un mismo ecosistema: servidores, bases de datos, almacenamiento, CDN, dominio y monitorización, simplificando la gestión técnica.

---

## 2. Arquitectura Cloud Propuesta

### Descripción del flujo

```
USUARIO (navegador / app móvil)
        │
        ▼
  [Route 53 — DNS]
  Resolución del dominio thesantystours.com
        │
        ▼
  [CloudFront — CDN]
  Distribución de contenido estático (imágenes, CSS, JS)
        │
        ▼
  [Application Load Balancer]
  Distribuye el tráfico entre instancias
        │
        ▼
  [EC2 t3.micro — Servidor de Aplicación]
  Backend Node.js + API REST
        │
     ┌──┴──┐
     ▼     ▼
[RDS MySQL]  [S3 — Almacenamiento]
Base de datos  Imágenes de tours,
de reservas,   documentos y
usuarios y     archivos estáticos
pagos
```

### Explicación de cada capa

| Capa | Servicio AWS | Función |
|------|-------------|---------|
| DNS | Route 53 | Gestión del dominio thesantystours.com |
| CDN | CloudFront | Servir imágenes y archivos estáticos desde el servidor más cercano al usuario |
| Balanceador | Application Load Balancer | Distribuir el tráfico si hay varias instancias activas |
| Servidor app | EC2 t3.micro | Ejecutar el backend (API REST, lógica de negocio) |
| Base de datos | RDS MySQL t3.micro | Almacenar usuarios, tours, reservas, pagos y valoraciones |
| Almacenamiento | S3 | Guardar imágenes de los tours, fotos de perfil de guías y documentos |

---

## 3. Servicios Cloud Utilizados

### 3.1 Amazon EC2 (Elastic Compute Cloud)
- **Tipo de instancia:** t3.micro (1 vCPU, 1 GB RAM)
- **Sistema operativo:** Ubuntu Server 22.04 LTS
- **Función:** Ejecutar el servidor de aplicación con el backend de The Santy's Tours (API REST en Node.js)
- **Free Tier:** ✅ 750 horas/mes durante 12 meses

### 3.2 Amazon RDS (Relational Database Service)
- **Motor:** MySQL 8.0
- **Tipo de instancia:** db.t3.micro
- **Almacenamiento:** 20 GB SSD
- **Función:** Base de datos gestionada que almacena toda la información del negocio: usuarios, tours, reservas, pagos y valoraciones
- **Ventaja:** AWS gestiona automáticamente copias de seguridad diarias, actualizaciones y failover
- **Free Tier:** ✅ 750 horas/mes durante 12 meses

### 3.3 Amazon S3 (Simple Storage Service)
- **Función:** Almacenamiento de objetos para imágenes de los tours, fotografías de los guías turísticos, documentos PDF y archivos estáticos del portal web
- **Capacidad inicial estimada:** 5-10 GB
- **Free Tier:** ✅ 5 GB durante 12 meses

### 3.4 Amazon Route 53
- **Función:** Servicio DNS para gestionar el dominio thesantystours.com y dirigir el tráfico hacia la infraestructura de AWS
- **Free Tier:** ❌ No incluido (0,50 $/mes por zona alojada)

### 3.5 Amazon CloudFront (CDN)
- **Función:** Red de distribución de contenido. Sirve las imágenes y archivos estáticos desde el punto más cercano geográficamente al usuario, reduciendo la latencia para turistas de todo el mundo
- **Free Tier:** ✅ 1 TB de transferencia/mes durante 12 meses

### 3.6 Application Load Balancer (ALB)
- **Función:** Distribuye el tráfico entrante entre instancias EC2 cuando la demanda aumenta en temporada alta
- **Nota:** En fase inicial puede omitirse y añadirse cuando el negocio crezca
- **Free Tier:** ✅ 750 horas/mes durante 12 meses

---

## 4. Estimación de Costes

### Costes durante el Free Tier (primeros 12 meses)

| Servicio | Recursos | Coste estimado/mes |
|---------|---------|-------------------|
| EC2 t3.micro | 750h/mes incluidas | **0,00 €** |
| RDS MySQL db.t3.micro | 750h/mes incluidas | **0,00 €** |
| S3 | Hasta 5 GB incluidos | **0,00 €** |
| CloudFront | Hasta 1 TB incluido | **0,00 €** |
| Route 53 | Zona DNS alojada | **~0,50 €** |
| **TOTAL primer año** | | **~0,50 €/mes** |

> Durante los primeros 12 meses, la infraestructura completa cuesta prácticamente **0 €**, lo que permite validar el negocio sin inversión en infraestructura.

---

### Costes a partir del mes 13 (sin Free Tier)

| Servicio | Especificaciones | Coste estimado/mes |
|---------|----------------|-------------------|
| EC2 t3.micro | On-Demand, región EU | ~8,50 € |
| RDS MySQL db.t3.micro | 20 GB SSD, región EU | ~15,00 € |
| S3 | 10 GB almacenamiento | ~0,23 € |
| CloudFront | 50 GB transferencia | ~0,50 € |
| Route 53 | 1 zona DNS | ~0,50 € |
| **TOTAL desde mes 13** | | **~24,73 €/mes** |

> Una infraestructura profesional en cloud para una startup de turismo como The Santy's Tours tiene un coste de aproximadamente **25 € al mes**, equivalente a lo que cuesta una sola entrada a un tour de la competencia.

---

### Escalabilidad futura

Si el negocio crece y el tráfico aumenta significativamente, se puede escalar a:

| Servicio | Upgrade | Coste adicional estimado |
|---------|---------|------------------------|
| EC2 | t3.small (2 GB RAM) | +8 €/mes |
| RDS | db.t3.small + Multi-AZ | +30 €/mes |
| Instancias adicionales EC2 | Auto Scaling | Variable según tráfico |

---

## 5. Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────┐
│                  INTERNET                           │
│   Turistas, guías y administradores                 │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
            ┌──────────────────┐
            │   Route 53       │
            │   DNS            │
            │ thesantystours   │
            └────────┬─────────┘
                     │
                     ▼
            ┌──────────────────┐
            │   CloudFront     │
            │   CDN Global     │
            │ Contenido estát. │
            └────────┬─────────┘
                     │
                     ▼
            ┌──────────────────┐
            │ Load Balancer    │
            │ (ALB)            │
            └────────┬─────────┘
                     │
                     ▼
         ┌───────────────────────┐
         │   EC2 t3.micro        │
         │   Ubuntu Server 22.04 │
         │   Node.js + API REST  │
         └──────┬────────┬───────┘
                │        │
        ┌───────┘        └──────────┐
        ▼                          ▼
┌──────────────┐         ┌──────────────────┐
│ RDS MySQL    │         │ Amazon S3        │
│ db.t3.micro  │         │ Imágenes tours   │
│ Usuarios     │         │ Fotos guías      │
│ Tours        │         │ Documentos PDF   │
│ Reservas     │         │ Archivos web     │
│ Pagos        │         └──────────────────┘
│ Valoraciones │
└──────────────┘
```

---

## 6. Justificación de la arquitectura para The Santy's Tours

Esta arquitectura responde directamente a las necesidades operativas reales de la empresa:

- **Disponibilidad 24/7:** Los turistas reservan desde cualquier parte del mundo y en cualquier franja horaria. AWS garantiza alta disponibilidad.
- **Picos de tráfico estacionales:** En verano y periodos vacacionales, el tráfico puede triplicarse. El Load Balancer y Auto Scaling permiten absorber esos picos automáticamente.
- **RGPD y protección de datos:** Al usar la región EU (Irlanda o Frankfurt), todos los datos de los clientes quedan dentro de la Unión Europea, cumpliendo la normativa vigente.
- **Escalabilidad progresiva:** La empresa puede empezar con una sola instancia EC2 y escalar conforme crezca sin migrar de infraestructura.
- **Coste controlado:** El primer año es prácticamente gratuito, y a partir del segundo el coste es de ~25 €/mes, asumible para cualquier emprendimiento en fase de crecimiento.

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
