# Sistema de Almacenamiento
## The Santy's Tours — FHW

---

## 1. Introducción

Este documento analiza el sistema de almacenamiento de The Santy's Tours, tanto a nivel local (en los equipos de oficina) como en la nube (AWS). El objetivo es demostrar que se comprende cómo se gestionan los datos a nivel físico y por qué se han tomado las decisiones de almacenamiento que se describen.

---

## 2. Almacenamiento local — equipos de oficina

Todos los equipos de The Santy's Tours utilizan discos SSD NVMe como almacenamiento principal.

| Equipo | Tipo de disco | Capacidad | Interfaz | Uso principal |
|--------|---------------|-----------|----------|---------------|
| Portátil desarrollo web | SSD NVMe M.2 | 1 TB | PCIe Gen 4 | SO, entorno de desarrollo, repositorio, assets |
| Portátil desarrollo app/BBDD | SSD NVMe M.2 | 1 TB | PCIe Gen 4 | SO, entorno de desarrollo, emuladores, BBDD local |
| Portátil administración | SSD NVMe M.2 | 512 GB | PCIe Gen 3/4 | SO, ofimática, documentos administrativos |

---

## 3. Comparativa SSD vs HDD

La elección de SSD NVMe frente a discos HDD mecánicos es deliberada y se justifica con la siguiente comparativa:

| Característica | SSD NVMe PCIe Gen 4 | HDD mecánico 7200 RPM |
|----------------|---------------------|-----------------------|
| Velocidad lectura secuencial | hasta 7.000 MB/s | 80-160 MB/s |
| Velocidad escritura secuencial | hasta 6.500 MB/s | 80-160 MB/s |
| Tiempo de acceso aleatorio | menos de 0,1 ms | 5-10 ms |
| Resistencia a golpes | Alta (sin partes móviles) | Baja (disco giratorio) |
| Consumo energético | Bajo (2-5W) | Alto (6-10W) |
| Ruido | Ninguno | Audible (motor giratorio) |
| Durabilidad media | Alta | Media |
| Coste por GB | Mayor | Menor |
| Formato | M.2 compacto | 2.5" o 3.5" |

**Conclusión:** El mayor coste por GB del SSD queda ampliamente justificado por la mejora de rendimiento. Para los perfiles de uso de The Santy's Tours (desarrollo de software, gestión de emuladores), la diferencia en tiempo de acceso es crítica.

---

## 4. Uso previsto del almacenamiento local

### 4.1 Portátiles de desarrollo (1 TB cada uno)

Estimación del uso del espacio en disco:

| Contenido | Espacio estimado |
|-----------|-----------------|
| Sistema operativo (Windows 11 Pro) | ~30 GB |
| Aplicaciones de desarrollo (VS Code, Android Studio, Docker...) | ~50 GB |
| Proyectos y repositorios locales | ~20 GB |
| Dependencias npm / librerías | ~10 GB |
| Base de datos local de pruebas | ~5 GB |
| Assets multimedia (fotos, vídeos de experiencias) | ~100 GB |
| Caché, temporales, logs | ~20 GB |
| **Total estimado** | **~235 GB** |
| **Espacio libre disponible** | **~765 GB** |

El SSD de 1 TB proporciona amplio margen para el crecimiento del proyecto sin necesidad de ampliar el almacenamiento a corto plazo.

### 4.2 Portátil de administración (512 GB)

| Contenido | Espacio estimado |
|-----------|-----------------|
| Sistema operativo (Windows 11 Home) | ~25 GB |
| Suite ofimática y herramientas administrativas | ~10 GB |
| Documentos, facturas, contratos | ~20 GB |
| Correo y adjuntos | ~5 GB |
| Caché y temporales | ~10 GB |
| **Total estimado** | **~70 GB** |
| **Espacio libre disponible** | **~442 GB** |

---

## 5. Almacenamiento en la nube — AWS

Los datos críticos del negocio no se almacenan únicamente en los discos locales, sino principalmente en AWS, garantizando disponibilidad, redundancia y seguridad:

| Servicio AWS | Tipo | Uso en The Santy's Tours | Capacidad inicial |
|--------------|------|--------------------------|-------------------|
| Amazon S3 | Almacenamiento de objetos | Imágenes de experiencias, documentos, backups, assets estáticos del portal web | Ilimitado (pago por uso) |
| Amazon RDS (MySQL) | Base de datos gestionada | Clientes, reservas, experiencias, pagos | 20 GB (ampliable) |
| Amazon EBS | Disco de instancia EC2 | Sistema operativo del servidor web y app | 20 GB SSD gp3 |

### Ventajas del almacenamiento cloud frente al local

| Ventaja | Descripción |
|---------|-------------|
| Redundancia | AWS replica los datos automáticamente en múltiples zonas |
| Backups automáticos | RDS hace snapshots diarios sin intervención manual |
| Escalabilidad | Se puede aumentar capacidad en minutos sin hardware |
| Seguridad | Cifrado en reposo y en tránsito por defecto |
| Accesibilidad | Disponible desde cualquier lugar con internet |
| Sin pérdida por fallo hardware | Si un portátil falla, los datos de negocio están seguros en AWS |

---

## 6. Estrategia de copias de seguridad

Para garantizar la integridad de los datos se combina almacenamiento local y cloud:

| Tipo de dato | Almacenamiento primario | Backup |
|--------------|------------------------|--------|
| Código fuente | Disco local + GitHub | GitHub (repositorio remoto) |
| Base de datos de producción | Amazon RDS | Snapshots automáticos AWS (7 días) |
| Imágenes y assets | Amazon S3 | Versionado S3 activado |
| Documentos administrativos | Disco local | Google Drive / OneDrive |
| Configuraciones de servidor | Amazon EBS | AMI (imagen de la instancia EC2) |
