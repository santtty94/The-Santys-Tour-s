# Configuración de Hardware Propuesta
## The Santy's Tours — FHW

---

## 1. Introducción

Este documento detalla la configuración hardware propuesta para cada uno de los equipos de The Santy's Tours, con la justificación técnica de por qué cada elección es adecuada para el entorno del proyecto.

---

## 2. Equipo de desarrollo web — Lenovo Legion 5

Equipo del responsable del portal web de The Santy's Tours.

| Componente | Especificación |
|------------|----------------|
| **Modelo** | Lenovo Legion 5 Gen 7 |
| **Procesador** | Intel Core i9-12900H (14C/20T, hasta 5,0 GHz) |
| **RAM** | 32 GB DDR5 4.800 MHz (dual channel) |
| **Almacenamiento** | 1 TB SSD NVMe PCIe Gen 4 |
| **Placa base** | Intel HM670, 2× M.2, 2× SO-DIMM |
| **GPU** | NVIDIA GeForce RTX 3060 6 GB GDDR6 |
| **Pantalla** | 15.6" IPS 144Hz FHD (1920×1080) |
| **Fuente de alimentación** | 230W |
| **Conectividad** | Wi-Fi 6 (Intel AX211), Bluetooth 5.2, USB-C 3.2, USB-A 3.2, HDMI 2.1, RJ-45 |
| **Sistema Operativo** | Windows 11 Pro |
| **Precio estimado** | ~1.400 € |

**Justificación:**

El desarrollo web moderno exige ejecutar múltiples herramientas simultáneamente: servidor de desarrollo local (Node.js/React), IDE con múltiples proyectos abiertos (VS Code), navegador con herramientas de desarrollo, terminal con conexiones SSH a AWS y cliente Git. Con solo 8 o 16 GB de RAM el sistema empezaría a usar memoria virtual del disco, degradando drásticamente el rendimiento.

Los 32 GB de DDR5 garantizan que todas estas herramientas corran en RAM sin swap. El Core i9 reduce los tiempos de compilación y transpilación de código (operaciones habituales en desarrollo React/Next.js). El SSD NVMe PCIe Gen 4 con velocidades de 7.000 MB/s reduce los tiempos de arranque del servidor local y de instalación de dependencias npm.

El HDMI 2.1 permite conectar un monitor externo 4K para ampliar el espacio de trabajo, muy útil cuando se edita código en un fichero y se previsualiza el resultado en otro.

---

## 3. Equipo de desarrollo app y BBDD — Lenovo Legion 5

Equipo del responsable de la aplicación móvil y la gestión de la base de datos.

| Componente | Especificación |
|------------|----------------|
| **Modelo** | Lenovo Legion 5 Gen 7 |
| **Procesador** | Intel Core i9-12900H (14C/20T, hasta 5,0 GHz) |
| **RAM** | 32 GB DDR5 4.800 MHz (dual channel) |
| **Almacenamiento** | 1 TB SSD NVMe PCIe Gen 4 |
| **Placa base** | Intel HM670, 2× M.2, 2× SO-DIMM |
| **GPU** | NVIDIA GeForce RTX 3060 6 GB GDDR6 |
| **Pantalla** | 15.6" IPS 144Hz FHD (1920×1080) |
| **Fuente de alimentación** | 230W |
| **Conectividad** | Wi-Fi 6 (Intel AX211), Bluetooth 5.2, USB-C 3.2, USB-A 3.2, HDMI 2.1, RJ-45 |
| **Sistema Operativo** | Windows 11 Pro |
| **Precio estimado** | ~1.400 € |

**Justificación:**

El desarrollo de aplicaciones móviles es especialmente exigente en RAM porque requiere ejecutar simultáneamente: Android Studio o Xcode (IDE pesado), uno o varios emuladores de dispositivo móvil (cada emulador consume entre 2 y 4 GB de RAM), el servidor de backend local con el que se comunica la app y el cliente de base de datos para verificar que los datos se almacenan correctamente.

Sin 32 GB de RAM, el emulador se vuelve extremadamente lento o directamente inviable. El Core i9 acelera la compilación de la app (builds en Android/iOS), que puede llevar varios minutos en equipos menos potentes.

---

## 4. Equipo de administración — Gama media (pendiente de adquirir)

Equipo del responsable administrativo: gestión de reservas, atención al cliente, facturación y comunicaciones.

| Componente | Especificación recomendada |
|------------|---------------------------|
| **Modelo de referencia** | Lenovo IdeaPad 5 / HP Pavilion 15 / ASUS VivoBook 15 |
| **Procesador** | Intel Core i5-1235U / AMD Ryzen 5 5500U |
| **RAM** | 16 GB DDR4 3.200 MHz |
| **Almacenamiento** | 512 GB SSD NVMe |
| **Placa base** | Chipset integrado según modelo |
| **GPU** | Gráficos integrados Intel Iris Xe / AMD Radeon |
| **Pantalla** | 15.6" FHD IPS |
| **Fuente de alimentación** | 65W |
| **Conectividad** | Wi-Fi 6, Bluetooth 5.0, USB-A, USB-C, HDMI |
| **Sistema Operativo** | Windows 11 Home |
| **Precio estimado** | ~650–750 € |

**Justificación:**

Las tareas administrativas no requieren el mismo nivel de potencia que el desarrollo de software. Un Core i5 con 16 GB de RAM es completamente suficiente para gestionar el back-office web, el correo electrónico, videollamadas con clientes y proveedores, documentos ofimáticos y hojas de cálculo.

Elegir un equipo de gama media para este perfil permite optimizar el presupuesto: los 650-750 € ahorrados respecto a un segundo Legion 5 pueden destinarse a otros recursos del proyecto (suscripciones a servicios cloud, software, etc.).

---

## 5. Resumen comparativo de configuraciones

| Criterio | Desarrollo web | Desarrollo app/BBDD | Administración |
|----------|---------------|---------------------|----------------|
| Procesador | Core i9-12900H | Core i9-12900H | Core i5-1235U |
| RAM | 32 GB DDR5 | 32 GB DDR5 | 16 GB DDR4 |
| Almacenamiento | 1 TB SSD NVMe | 1 TB SSD NVMe | 512 GB SSD |
| GPU | RTX 3060 6GB | RTX 3060 6GB | Integrada |
| SO | Windows 11 Pro | Windows 11 Pro | Windows 11 Home |
| Precio estimado | ~1.400 € | ~1.400 € | ~700 € |
| **Total** | | | **~3.500 €** |

---

## 6. Periféricos complementarios

Además de los equipos principales, se propone el siguiente hardware periférico:

| Periférico | Modelo de referencia | Cantidad | Precio estimado | Justificación |
|------------|---------------------|----------|-----------------|---------------|
| Router Wi-Fi 6 | ASUS RT-AX88U | 1 | 250 € | Red estable para toda la oficina |
| Impresora multifunción | Brother MFC-L3770CDW | 1 | 350 € | Vouchers, tickets y documentación |
| Smartphones de trabajo | iPhone 14 / Samsung S23 | 3 | 600 € c/u | Operativa en campo |
| **Total periféricos** | | | **~2.400 €** | |
