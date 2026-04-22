# 🏗️ Arquitectura Cloud Propuesta

**Módulo:** MPO — Fundamentos de Computación en la Nube  
**Proyecto:** The Santy's Tours  

---

## Descripción general

The Santy's Tours necesita una arquitectura cloud que soporte:
- Un portal web accesible desde cualquier parte del mundo
- Una API REST que gestione reservas, usuarios y pagos
- Almacenamiento de imágenes de tours y documentos
- Alta disponibilidad en temporada turística alta
- Cumplimiento del RGPD (datos en la UE)

La arquitectura propuesta en AWS cubre todas estas necesidades con servicios gestionados que minimizan el mantenimiento manual.

---

## Diagrama de arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                        INTERNET                             │
│         Turistas, guías y administradores                   │
│         (navegador web / aplicación móvil)                  │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
               ┌───────────────────────┐
               │       Route 53        │
               │  DNS — Gestión del    │
               │  dominio              │
               │  thesantystours.com   │
               └───────────┬───────────┘
                           │
                           ▼
               ┌───────────────────────┐
               │      CloudFront       │
               │  CDN — Distribución   │
               │  de contenido         │
               │  estático global      │
               └───────────┬───────────┘
                           │
                           ▼
               ┌───────────────────────┐
               │  Application Load     │
               │     Balancer (ALB)    │
               │  Distribución de      │
               │  tráfico              │
               └───────────┬───────────┘
                           │
                           ▼
               ┌───────────────────────┐
               │    EC2 t3.micro       │
               │  Ubuntu Server 22.04  │
               │  Node.js + API REST   │
               │  Backend de la        │
               │  plataforma           │
               └─────────┬─────┬───────┘
                         │     │
           ┌─────────────┘     └──────────────┐
           ▼                                  ▼
┌──────────────────┐              ┌───────────────────────┐
│   RDS MySQL      │              │      Amazon S3        │
│   db.t3.micro    │              │                       │
│                  │              │  - Imágenes de tours  │
│  - usuarios      │              │  - Fotos de guías     │
│  - tours         │              │  - Documentos PDF     │
│  - reservas      │              │  - Archivos estáticos │
│  - pagos         │              │    del portal web     │
│  - valoraciones  │              └───────────────────────┘
└──────────────────┘
```

---

## Descripción del flujo de una reserva

1. El **turista** accede a thesantystours.com desde su navegador o app móvil
2. **Route 53** resuelve el dominio y dirige la petición a la infraestructura AWS
3. **CloudFront** sirve los archivos estáticos (imágenes, CSS, JavaScript) desde el servidor más cercano geográficamente al usuario, reduciendo la latencia
4. Las peticiones dinámicas (búsqueda de tours, proceso de reserva) llegan al **Application Load Balancer**
5. El ALB distribuye la carga entre las instancias **EC2** disponibles
6. El servidor **EC2** procesa la lógica de negocio a través de la API REST:
   - Consulta la disponibilidad de tours en **RDS MySQL**
   - Gestiona el proceso de pago
   - Confirma la reserva y actualiza la base de datos
7. Las imágenes del tour que ve el usuario se sirven directamente desde **S3** a través de CloudFront

---

## Descripción de cada capa

### Capa DNS — Route 53
Gestiona el dominio thesantystours.com. Cuando un usuario escribe la dirección en su navegador, Route 53 traduce el nombre de dominio a la dirección IP de la infraestructura y dirige el tráfico correctamente.

### Capa CDN — CloudFront
Red de distribución de contenido con servidores en más de 400 ubicaciones mundiales. Almacena en caché las imágenes y archivos estáticos del portal para servirlos desde el punto más cercano al usuario. Esto es especialmente importante para The Santy's Tours, cuyos clientes son turistas de todo el mundo.

### Capa de balanceo — Application Load Balancer
Distribuye el tráfico entrante entre las instancias EC2 disponibles. En temporada baja puede haber una sola instancia; en temporada alta (verano) el sistema puede escalar automáticamente añadiendo más instancias sin interrumpir el servicio.

### Capa de aplicación — EC2 t3.micro
Servidor virtual en la nube que ejecuta el backend de The Santy's Tours:
- Sistema operativo: Ubuntu Server 22.04 LTS
- Runtime: Node.js
- API REST para gestión de usuarios, tours, reservas y pagos
- Conexión segura a la base de datos RDS

### Capa de datos — RDS MySQL
Base de datos relacional gestionada por AWS. Almacena toda la información del negocio: usuarios (turistas, guías, admins), catálogo de tours, reservas, pagos y valoraciones. AWS gestiona automáticamente las copias de seguridad diarias y las actualizaciones de seguridad.

### Capa de almacenamiento — S3
Almacenamiento de objetos para todos los archivos multimedia y documentos: imágenes de cada tour, fotografías de perfil de los guías, documentos PDF de confirmación de reserva y los archivos estáticos del portal web (HTML, CSS, JavaScript).

---

## Seguridad de la arquitectura

- Toda la comunicación se realiza mediante **HTTPS (TLS 1.3)**
- La base de datos RDS **no tiene acceso público** — solo es accesible desde el servidor EC2
- Los archivos en S3 son privados por defecto; solo se sirven públicamente los que están asociados a CloudFront
- La región **eu-west-1 (Irlanda)** garantiza que todos los datos permanecen dentro de la UE cumpliendo el RGPD

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
