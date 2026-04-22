# 🔍 Investigación del Proveedor Cloud

**Módulo:** MPO — Fundamentos de Computación en la Nube  
**Proyecto:** The Santy's Tours  

---

## Proveedor elegido: Amazon Web Services (AWS)

Tras analizar los principales proveedores del mercado, se ha elegido **AWS (Amazon Web Services)** como proveedor cloud para The Santy's Tours.

### Proveedores analizados

| Proveedor | Ventajas | Inconvenientes |
|-----------|----------|----------------|
| **AWS** | Líder del mercado, Free Tier generoso, mayor número de servicios, presencia global | Curva de aprendizaje más pronunciada |
| Google Cloud | Buena integración con herramientas Google, fuerte en IA/ML | Menos documentación en español, menor cuota de mercado |
| Microsoft Azure | Ideal si ya se usa Microsoft 365, buena integración con Windows Server | Más orientado a empresa grande, precio más elevado |
| DigitalOcean | Muy sencillo de usar, precio competitivo | Menos servicios disponibles, menor presencia global |

---

## ¿Por qué AWS para The Santy's Tours?

### 1. Madurez y fiabilidad
AWS es el proveedor cloud líder mundial con más de 15 años en el mercado y una cuota superior al 30% del sector. Su infraestructura global garantiza una disponibilidad del **99,99%**, crítica para una plataforma de reservas donde la caída del servicio implica pérdida directa de ventas e ingresos.

### 2. Cobertura geográfica en Europa
AWS dispone de regiones en Europa (Irlanda, Frankfurt, París, Estocolmo). Esto permite alojar todos los datos de clientes dentro de la Unión Europea, cumpliendo el **RGPD (Reglamento General de Protección de Datos)**, obligatorio para cualquier empresa que gestione datos personales de ciudadanos europeos como hace The Santy's Tours.

### 3. Free Tier — Arranque sin coste
AWS ofrece una capa gratuita durante los primeros 12 meses que cubre prácticamente toda la infraestructura necesaria para la fase inicial del proyecto:
- EC2 t3.micro: 750 horas/mes gratis
- RDS db.t3.micro: 750 horas/mes gratis
- S3: 5 GB gratis
- CloudFront: 1 TB de transferencia gratis

Esto permite **validar el modelo de negocio sin inversión en infraestructura**.

### 4. Escalabilidad bajo demanda
The Santy's Tours opera en un sector con picos de demanda muy marcados (verano, Semana Santa, puentes). AWS permite escalar recursos automáticamente en cuestión de minutos cuando el tráfico aumenta, y reducirlos cuando baja, pagando solo por lo que se usa.

### 5. Ecosistema de servicios completo
AWS ofrece en un mismo ecosistema todos los servicios necesarios: servidores virtuales, bases de datos gestionadas, almacenamiento de archivos, CDN, DNS y monitorización. Esto simplifica la gestión técnica y evita depender de múltiples proveedores.

---

## Región seleccionada

**eu-west-1 (Irlanda)** — elegida por:
- Localización dentro de la UE (cumplimiento RGPD)
- Menor latencia para usuarios europeos
- Disponibilidad de todos los servicios necesarios
- Precio competitivo dentro de las regiones europeas

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
