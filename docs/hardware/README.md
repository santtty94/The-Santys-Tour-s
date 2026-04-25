# 🖥️ FHW — Fundamentos de Hardware

**Proyecto:** The Santy's Tours
**Módulo:** Fundamentos de Hardware (FHW)
**Ciclo:** ASIR — Administración de Sistemas Informáticos en Red
**Curso:** 2025/2026

---

## 1. Análisis de necesidades de hardware

The Santy's Tours es una agencia de turismo de ocio y aventura con sede física en Barcelona. El equipo está formado por 2-3 personas que gestionan las operaciones diarias desde la oficina y en campo.

La infraestructura tecnológica de la empresa se divide en dos partes:

- **Hardware local (oficina):** los equipos físicos que usa el equipo día a día.
- **Infraestructura en la nube (AWS):** donde corren el portal web, la app móvil y la base de datos.

No existe servidor físico en la oficina. Para una empresa en fase de arranque como The Santy's Tours, la nube ofrece menor coste inicial, mayor escalabilidad y cero mantenimiento de hardware de servidor.

### Resumen de equipos necesarios

| Tipo de equipo | Cantidad | Función principal |
|---|---|---|
| Portátil de desarrollo web | 1 | Desarrollo y mantenimiento del portal web |
| Portátil de desarrollo app/BBDD | 1 | Desarrollo de app móvil y gestión de base de datos |
| Portátil de administración | 1 | Reservas, atención al cliente, facturación |
| Smartphone de trabajo | 3 | Operativa en campo durante las experiencias |
| Router fibra óptica | 1 | Conexión a internet y gateway de la red local |
| Access Point Wi-Fi 6 | 1 | Cobertura inalámbrica extendida en la oficina |
| Impresora multifunción | 1 | Vouchers, tickets, documentación administrativa |

---

## 2. Componentes de un equipo informático

A continuación se describen los componentes principales que forman los equipos del sistema, tomando como referencia el Lenovo Legion 5.

### 2.1 CPU — Procesador

| Campo | Detalle |
|---|---|
| Modelo | Intel Core i9-12900H |
| Núcleos | 14 núcleos (6P + 8E) / 20 hilos |
| Frecuencia base | 2,5 GHz |
| Frecuencia turbo | hasta 5,0 GHz |
| Caché | 24 MB L3 |

**Función:** El procesador es el cerebro del equipo. Ejecuta todas las instrucciones del software: compilar código, ejecutar emuladores, procesar datos y gestionar múltiples procesos simultáneos. Un Core i9 garantiza que tareas exigentes como compilar el portal web, ejecutar un emulador de móvil y tener el entorno de base de datos activo al mismo tiempo no generen cuellos de botella.

### 2.2 Placa base

| Campo | Detalle |
|---|---|
| Formato | Integrada (portátil) — equivalente a micro-ATX |
| Chipset | Intel HM670 |
| Ranuras RAM | 2x SO-DIMM DDR5 |
| Almacenamiento | 2x M.2 PCIe NVMe |
| Puertos | USB-A 3.2, USB-C 3.2, HDMI 2.1, RJ-45 |

**Función:** La placa base es el elemento que conecta y comunica todos los componentes del equipo. El chipset HM670 permite sacar el máximo rendimiento al Core i9 y soporta configuraciones de RAM de alta velocidad (DDR5), fundamentales para los entornos de desarrollo.

### 2.3 Memoria RAM

| Campo | Detalle |
|---|---|
| Capacidad | 32 GB |
| Tipo | DDR5 |
| Frecuencia | 4.800 MHz |
| Canales | Dual channel (2x 16 GB) |

**Función:** La RAM almacena temporalmente los datos que el procesador está usando en ese momento. 32 GB permiten tener activos simultáneamente: el IDE de desarrollo (VS Code), el servidor local, el navegador con múltiples pestañas, el emulador de móvil y el cliente de base de datos, sin que el sistema tenga que recurrir a la memoria virtual del disco.

### 2.4 Almacenamiento

| Campo | Detalle |
|---|---|
| Tipo | SSD NVMe M.2 |
| Capacidad | 1 TB |
| Interfaz | PCIe Gen 4 |
| Velocidad lectura | hasta 7.000 MB/s |
| Velocidad escritura | hasta 6.500 MB/s |

**Función:** El disco SSD almacena el sistema operativo, las aplicaciones y los proyectos de desarrollo. La velocidad NVMe PCIe Gen 4 reduce drásticamente los tiempos de carga del sistema y de compilación de proyectos respecto a un HDD tradicional.

### 2.5 Tarjeta gráfica (GPU)

| Campo | Detalle |
|---|---|
| Modelo | NVIDIA GeForce RTX 3060 (6 GB VRAM) |
| Uso principal | Aceleración gráfica para diseño web y edición multimedia |

**Función:** Aunque The Santy's Tours no es una empresa de videojuegos, la GPU tiene un papel importante: acelera el renderizado de interfaces en el navegador, permite editar fotografías y vídeos de las experiencias turísticas con fluidez y puede usarse para tareas de machine learning en el futuro si la empresa necesita análisis de datos.

### 2.6 Fuente de alimentación

| Campo | Detalle |
|---|---|
| Tipo | Adaptador externo (portátil) |
| Potencia | 230W |
| Conector | USB-C / barrel connector |

**Función:** Proporciona la energía eléctrica necesaria para que todos los componentes funcionen de forma estable. Los 230W son necesarios para alimentar tanto el procesador i9 como la GPU RTX 3060 bajo carga máxima sin que el sistema se limite a sí mismo.

---

## 3. Configuración de hardware propuesta

### Equipo de desarrollo (x2) — Lenovo Legion 5

Configuración real de los equipos de desarrollo web y app/BBDD:

| Componente | Especificación |
|---|---|
| Procesador | Intel Core i9-12900H (14C/20T, hasta 5,0 GHz) |
| RAM | 32 GB DDR5 4.800 MHz (dual channel) |
| Almacenamiento | 1 TB SSD NVMe PCIe Gen 4 |
| Placa base | Intel HM670, 2x M.2, 2x SO-DIMM |
| GPU | NVIDIA GeForce RTX 3060 6 GB |
| Pantalla | 15.6" IPS 144Hz FHD |
| Fuente de alimentación | 230W |
| Conectividad | Wi-Fi 6, Bluetooth 5.0, USB-C, USB-A 3.2, HDMI 2.1, RJ-45 |
| Sistema Operativo | Windows 11 Pro |

**Justificación:** Esta configuración está diseñada para soportar entornos de desarrollo exigentes. El Core i9 con 32 GB de RAM garantiza que los dos desarrolladores puedan trabajar con múltiples herramientas abiertas simultáneamente sin degradación del rendimiento. El SSD NVMe reduce los tiempos de compilación y el HDMI 2.1 permite conectar un monitor externo para aumentar la productividad. Se conectan al router por **cable Ethernet** para garantizar la máxima estabilidad en tareas de desarrollo y acceso SSH al servidor EC2.

### Equipo de administración (x1) — Gama media (por adquirir)

| Componente | Especificación recomendada |
|---|---|
| Procesador | Intel Core i5-1235U / AMD Ryzen 5 5500U |
| RAM | 16 GB DDR4 3.200 MHz |
| Almacenamiento | 512 GB SSD NVMe |
| Pantalla | 15.6" FHD |
| Fuente de alimentación | 65W |
| Conectividad | Wi-Fi 6, USB-A, USB-C, HDMI |
| Sistema Operativo | Windows 11 Home |

**Justificación:** Las tareas administrativas (back-office, correo, videollamadas, ofimática) no requieren la potencia de los equipos de desarrollo. Un Core i5 con 16 GB es más que suficiente y permite optimizar el presupuesto. Se conecta a la red por **Wi-Fi** a través del Access Point.

### Access Point Wi-Fi 6 — TP-Link EAP670 (o similar)

| Componente | Especificación |
|---|---|
| Estándar | 802.11ax (Wi-Fi 6) |
| Bandas | 2.4 GHz + 5 GHz |
| Velocidad máxima | hasta 3.000 Mbps (AX3000) |
| Conexión al router | Ethernet Gigabit (modo AP puro) |
| IP de gestión | 192.168.10.5 |

**Justificación:** El router cubre la conectividad Ethernet para los portátiles de desarrollo, pero se necesita un Access Point dedicado para garantizar cobertura Wi-Fi de calidad en toda la oficina. El portátil de administración, los smartphones y la impresora se conectan a través de él. El modo AP puro asegura que todos los dispositivos estén en la misma red (192.168.10.0/24) sin crear subredes adicionales.

---

## 4. Sistema de almacenamiento

### 4.1 Almacenamiento local (equipos de oficina)

Todos los equipos de The Santy's Tours usan discos SSD NVMe como almacenamiento principal.

| Equipo | Tipo | Capacidad | Uso |
|---|---|---|---|
| Portátil desarrollo web | SSD NVMe PCIe Gen 4 | 1 TB | Entorno de desarrollo, repositorio, assets |
| Portátil desarrollo app/BBDD | SSD NVMe PCIe Gen 4 | 1 TB | Entorno de desarrollo, emuladores, BBDD local |
| Portátil administración | SSD NVMe | 512 GB | Sistema, ofimática, documentos |

### 4.2 Comparativa SSD vs HDD

| Característica | SSD NVMe | HDD mecánico |
|---|---|---|
| Velocidad de lectura | hasta 7.000 MB/s | 80-160 MB/s |
| Velocidad de escritura | hasta 6.500 MB/s | 80-160 MB/s |
| Tiempo de acceso | < 0,1 ms | 5-10 ms |
| Resistencia a golpes | Alta (sin partes móviles) | Baja (disco giratorio) |
| Consumo energético | Bajo | Alto |
| Coste por GB | Mayor | Menor |
| Durabilidad | Alta | Media |

**Decisión:** Se usa SSD NVMe en todos los equipos porque la velocidad de acceso impacta directamente en la productividad del equipo de desarrollo.

### 4.3 Almacenamiento en la nube (AWS)

Los datos críticos del negocio no se almacenan en los discos locales sino en AWS:

| Servicio AWS | Uso |
|---|---|
| Amazon RDS | Base de datos de clientes y reservas |
| Amazon S3 | Imágenes de experiencias, documentos, backups |
| Amazon EBS | Disco del servidor web y de la app |

Esto garantiza que si un portátil se estropea o es robado, ningún dato del negocio se pierde.

---

## 5. Mejora y evolución del hardware

### 5.1 Situación actual (fase de arranque)

La infraestructura actual está dimensionada para un equipo de 2-3 personas trabajando desde una oficina, con toda la infraestructura de servidor en la nube. Es una configuración eficiente y de bajo coste de mantenimiento para esta fase.

### 5.2 Mejoras a corto plazo (0-12 meses)

| Mejora | Justificación |
|---|---|
| Monitor externo 27" para cada desarrollador | Aumenta la productividad al tener más espacio de pantalla para código y herramientas |
| Switch gestionable de red | Permite segmentar la red de oficina en VLANs (desarrollo / administración / invitados) |
| SAI (Sistema de Alimentación Ininterrumpida) | Protege los equipos de cortes de luz que podrían corromper datos o interrumpir despliegues |
| Disco externo SSD para backups locales | Complementa los backups en AWS con una copia local para recuperación rápida |

### 5.3 Evolución a medio plazo (1-3 años)

| Escenario | Hardware adicional necesario |
|---|---|
| 5-10 empleados | 2-7 portátiles adicionales según el rol, switch gestionable de 16 puertos, NAS para almacenamiento compartido interno |
| Oficina con sala de reuniones | Pantalla de proyección, sistema de videoconferencia, AP Wi-Fi adicional |
| Equipo de diseño/marketing | Equipos con GPU dedicada, tabletas gráficas (Wacom), monitores de alta resolución |
| Mayor volumen de reservas | Escalar los recursos de AWS automáticamente, sin necesidad de nuevo hardware físico |

### 5.4 Ventaja del modelo cloud-first

La decisión de no tener servidor físico desde el inicio permite que el crecimiento de la empresa no dependa de comprar nuevo hardware de servidor. AWS escala automáticamente según la demanda: si en verano el portal web recibe 10 veces más reservas que en invierno, los recursos se ajustan solos sin intervención manual ni inversión en hardware adicional.

---

## 6. Diagrama de infraestructura de oficina

```
           INTERNET (Fibra 600 Mbps simétricos)
                          |
                  [Router ASUS Wi-Fi 6]
                  192.168.10.1 (GW)
                  /        |         \
           Ethernet     Ethernet    Ethernet (uplink AP)
              |             |              |
  [Portátil Dev Web]  [Portátil App/BBDD]  [Access Point Wi-Fi 6]
  192.168.10.20       192.168.10.21        192.168.10.5
  Legion 5 i9/32GB    Legion 5 i9/32GB          |
  1TB SSD NVMe        1TB SSD NVMe           Wi-Fi 6
                                        /        |       \
                              [Portátil Admin] [Smartphones x3] [Impresora]
                              192.168.10.30    DHCP .100+       192.168.10.40
                              i5/16GB          Wi-Fi / 5G       Wi-Fi

══════════════════════════════ NUBE — AWS ══════════════════════════════
         Portal Web (EC2) | App (EC2) | Base de Datos (RDS) | Archivos (S3)
```

---

*Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
