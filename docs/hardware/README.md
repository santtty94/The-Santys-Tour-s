# 🖥️ FHW — Fundamentos de Hardware
## The Santy's Tours

---

## 1. Introducción

The Santy's Tours es una agencia de turismo de ocio y aventura con sede física en Barcelona. El equipo está formado por 2-3 personas que gestionan las operaciones diarias desde la oficina y en campo.

La infraestructura tecnológica de la empresa se divide en dos partes:

- **Hardware local (oficina):** los equipos físicos que usa el equipo en el día a día.
- **Infraestructura en la nube (AWS):** donde corren el portal web, la app móvil y la base de datos.

No existe servidor físico en la oficina. Esta decisión es deliberada: para una empresa en fase de arranque como The Santy's Tours, la nube ofrece menor coste inicial, mayor escalabilidad y cero mantenimiento de hardware de servidor.

---

## 2. Inventario de hardware de oficina

### 2.1 Portátil de desarrollo web — x1

Equipo del responsable del portal web de The Santy's Tours.

| Característica | Especificación |
|----------------|----------------|
| Modelo | Lenovo Legion 5 |
| Procesador | Intel Core i9 (12ª generación) |
| RAM | 32 GB DDR5 |
| Almacenamiento | 1 TB SSD NVMe |
| Pantalla | 15.6 pulgadas, 144 Hz |
| Conectividad | Wi-Fi 6, Bluetooth 5.0, USB-C, HDMI |
| Sistema Operativo | Windows 11 Pro |
| Uso principal | Desarrollo y mantenimiento del portal web |

**Justificación:** El desarrollo web moderno requiere ejecutar entornos locales (servidores de desarrollo, contenedores Docker, editores de código), navegar entre múltiples pestañas y herramientas simultáneamente, y compilar proyectos. Los 32 GB de RAM y el Core i9 garantizan que ninguna de estas tareas genere cuellos de botella. El SSD de 1 TB permite almacenar el entorno de desarrollo completo, assets multimedia y copias locales del repositorio.

---

### 2.2 Portátil de desarrollo de app y BBDD — x1

Equipo del responsable de la aplicación móvil y la gestión de la base de datos.

| Característica | Especificación |
|----------------|----------------|
| Modelo | Lenovo Legion 5 |
| Procesador | Intel Core i9 (12ª generación) |
| RAM | 32 GB DDR5 |
| Almacenamiento | 1 TB SSD NVMe |
| Pantalla | 15.6 pulgadas, 144 Hz |
| Conectividad | Wi-Fi 6, Bluetooth 5.0, USB-C, HDMI |
| Sistema Operativo | Windows 11 Pro |
| Uso principal | Desarrollo de app móvil y administración de base de datos |

**Justificación:** El desarrollo de aplicaciones móviles exige ejecutar emuladores de Android e iOS simultáneamente, gestionar entornos de base de datos locales para pruebas y mantener el servidor de desarrollo de la API. Los 32 GB de RAM son esenciales para que el emulador, el IDE y el cliente de base de datos funcionen sin problemas en paralelo.

---

### 2.3 Portátil de administración — x1 (pendiente de adquirir)

Equipo para el tercer miembro del equipo, encargado de tareas administrativas: gestión de reservas, atención al cliente, facturación y comunicaciones.

| Característica | Especificación recomendada |
|----------------|---------------------------|
| Modelo de referencia | Lenovo IdeaPad 5 / HP Pavilion 15 |
| Procesador | Intel Core i5 12ª gen / AMD Ryzen 5 |
| RAM | 16 GB DDR4 |
| Almacenamiento | 512 GB SSD |
| Pantalla | 15.6 pulgadas |
| Conectividad | Wi-Fi 6, Bluetooth, USB-A, USB-C |
| Sistema Operativo | Windows 11 Home |
| Uso principal | Back-office, reservas, facturación, comunicaciones |

**Justificación:** Las tareas administrativas no requieren la potencia de los equipos de desarrollo. Un equipo de gama media es suficiente para gestionar el panel de administración web, correo electrónico, herramientas ofimáticas y videollamadas. Se prioriza la relación calidad-precio y la duración de batería para mayor movilidad.

---

### 2.4 Smartphones de trabajo — x3

Herramienta imprescindible para la operativa en campo durante las experiencias turísticas.

| Característica | Especificación |
|----------------|----------------|
| Modelo de referencia | iPhone 14 / Samsung Galaxy S23 |
| RAM | 8 GB mínimo |
| Almacenamiento | 128 GB |
| Conectividad | 5G, Wi-Fi 6, NFC |
| Cámara | 12 MP mínimo (fotos y vídeo para RRSS) |
| Batería | 4.000 mAh mínimo |

**Justificación:** Los guías usan el móvil para gestionar la app interna, hacer check-in de reservas en tiempo real, comunicarse con los clientes y capturar contenido fotográfico y de vídeo de las experiencias para redes sociales. El NFC permite validación de tickets y pagos en campo. La batería es crítica dado que las experiencias pueden durar varias horas fuera de la oficina.

---

### 2.5 Router de fibra óptica — x1

| Característica | Especificación |
|----------------|----------------|
| Modelo de referencia | ASUS RT-AX88U |
| Estándar Wi-Fi | Wi-Fi 6 (802.11ax) |
| Velocidad contratada | 600 Mbps simétricos |
| Puertos LAN | 4x Gigabit Ethernet |
| Funcionalidades | QoS, VPN, firewall integrado |

**Justificación:** Una conexión de fibra óptica simétrica es imprescindible para el equipo de desarrollo: subir código al repositorio, desplegar actualizaciones en AWS, realizar videollamadas y acceder al back-office en la nube sin latencia. El Wi-Fi 6 garantiza velocidad y estabilidad para los 3 portátiles y los móviles simultáneamente. El QoS permite priorizar el tráfico de trabajo sobre otros usos.

---

### 2.6 Impresora multifunción — x1

| Característica | Especificación |
|----------------|----------------|
| Modelo de referencia | Brother MFC-L3770CDW |
| Tipo | Láser color multifunción |
| Funciones | Impresión, escaneado, fotocopiado |
| Conectividad | Wi-Fi, Ethernet, USB |
| Velocidad | 24 ppm en negro, 24 ppm en color |
| Formato | A4 |

**Justificación:** Necesaria para imprimir vouchers y tickets de las experiencias, documentación administrativa, contratos y facturas para clientes que lo requieran. La conectividad Wi-Fi permite que cualquier miembro del equipo imprima directamente desde su portátil o móvil sin cables.

---

## 3. Justificación: sin servidor físico en oficina

The Santy's Tours no dispone de servidor físico en la oficina. Toda la infraestructura de servidor (portal web, app móvil, base de datos, almacenamiento de archivos) corre en **Amazon Web Services (AWS)**.

| Razón | Explicación |
|-------|-------------|
| Coste inicial | Un servidor físico supone una inversión de 2.000-5.000€ que una empresa en arranque no necesita asumir |
| Mantenimiento | La nube elimina la necesidad de gestionar hardware de servidor, actualizaciones de firmware y fallos de disco |
| Escalabilidad | AWS permite escalar recursos en minutos si la demanda crece, sin comprar hardware nuevo |
| Disponibilidad | AWS garantiza 99,99% de uptime, imposible de igualar con un servidor de oficina |
| Seguridad | Copias de seguridad automáticas, cifrado y protección gestionados por AWS |
| Movilidad | El equipo puede acceder al back-office y los sistemas desde cualquier lugar con internet |

---

## 4. Resumen de inversión en hardware

| Equipo | Cantidad | Coste estimado unitario | Total estimado |
|--------|----------|------------------------|----------------|
| Lenovo Legion 5 (Core i9, 32 GB, 1 TB) | 2 | 1.400 € | 2.800 € |
| Portátil administración (gama media) | 1 | 700 € | 700 € |
| Smartphones de trabajo | 3 | 600 € | 1.800 € |
| Router ASUS RT-AX88U | 1 | 250 € | 250 € |
| Impresora Brother MFC-L3770CDW | 1 | 350 € | 350 € |
| **TOTAL** | | | **5.900 €** |

> Los costes de infraestructura en la nube (AWS) se detallan en el módulo MPO (Fundamentos en la Nube).

---

## 5. Diagrama de infraestructura de oficina

```
                        INTERNET (Fibra 600 Mbps)
                                |
                         [Router Wi-Fi 6]
                                |
              ┌─────────────────┼─────────────────┐
              |                 |                 |
    [Portátil Web]    [Portátil App/BBDD]  [Portátil Admin]
    Core i9 / 32GB     Core i9 / 32GB      Core i5 / 16GB
              |                 |                 |
              └─────────────────┴─────────────────┘
                                |
                        [Impresora Wi-Fi]
                                |
                    ════════════════════════
                         NUBE (AWS)
                    ════════════════════════
                    Portal Web | App | BBDD
```
