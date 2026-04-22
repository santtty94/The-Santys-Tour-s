# Componentes de un Equipo Informático
## The Santy's Tours — FHW


---


## 1. Introducción


A continuación se describen los componentes principales de los equipos informáticos que forman parte de la infraestructura de The Santy's Tours, tomando como referencia el **Lenovo Legion 5** (equipos de desarrollo).


Comprender cómo interactúan estos componentes es fundamental para entender por qué se ha elegido cada configuración y cómo se relacionan entre sí para garantizar el rendimiento que necesita la empresa.


---


## 2. CPU — Procesador (Unidad Central de Procesamiento)


| Campo | Detalle |
|-------|---------|
| Modelo | Intel Core i9-12900H |
| Núcleos | 14 núcleos (6 de rendimiento + 8 de eficiencia) |
| Hilos | 20 hilos |
| Frecuencia base | 2,5 GHz |
| Frecuencia turbo | hasta 5,0 GHz |
| Caché L3 | 24 MB |
| Arquitectura | Alder Lake (12ª generación) |

**Función dentro del sistema:**
El procesador es el componente que ejecuta todas las instrucciones del software. En el contexto de The Santy's Tours, el Core i9 permite:
- Compilar el código del portal web sin tiempos de espera
- Ejecutar el servidor de desarrollo local mientras se edita código
- Correr emuladores de dispositivos móviles para probar la app
- Gestionar múltiples procesos simultáneos sin degradación del rendimiento

La arquitectura híbrida (núcleos P + E) permite que las tareas más exigentes usen los núcleos de rendimiento, mientras las tareas en segundo plano (antivirus, notificaciones, sincronización) usan los de eficiencia, optimizando el consumo energético.

---

## 3. Placa base

| Campo | Detalle |
|-------|---------|
| Formato | Integrada en portátil (equivalente a micro-ATX en sobremesa) |
| Chipset | Intel HM670 |
| Ranuras RAM | 2× SO-DIMM DDR5 |
| Slots de almacenamiento | 2× M.2 PCIe NVMe |
| Puertos integrados | USB-A 3.2, USB-C 3.2, HDMI 2.1, RJ-45, jack de audio |
| Conectividad inalámbrica | Wi-Fi 6 (Intel AX211), Bluetooth 5.2 |

**Función dentro del sistema:**
La placa base es el componente que conecta y comunica todos los demás componentes. Sin ella, ningún componente puede comunicarse con los demás. El chipset HM670 gestiona el flujo de datos entre el procesador, la RAM, el almacenamiento y los dispositivos periféricos. En la práctica, es la "autopista" por la que viaja toda la información del sistema.

---

## 4. Memoria RAM

| Campo | Detalle |
|-------|---------|
| Capacidad | 32 GB |
| Tipo | DDR5 |
| Frecuencia | 4.800 MHz |
| Configuración | Dual channel (2× 16 GB) |
| Latencia | CL40 |

**Función dentro del sistema:**
La RAM almacena temporalmente los datos que el procesador necesita en cada momento. A diferencia del SSD, la RAM es volátil (se borra al apagar) pero extremadamente rápida.

Con 32 GB, el equipo puede tener activos simultáneamente sin problemas:
- IDE de desarrollo (VS Code) con múltiples proyectos abiertos
- Servidor de desarrollo local (Node.js / React)
- Navegador web con 20+ pestañas abiertas
- Emulador de dispositivo móvil (Android Studio)
- Cliente de base de datos (DBeaver, TablePlus)
- Terminal con múltiples sesiones SSH

Si la RAM fuera insuficiente, el sistema usaría el disco como memoria virtual (swap), lo que ralentizaría drásticamente el trabajo.

---

## 5. Discos de almacenamiento

| Campo | Detalle |
|-------|---------|
| Tipo | SSD NVMe M.2 |
| Interfaz | PCIe Gen 4 |
| Capacidad | 1 TB |
| Velocidad de lectura secuencial | hasta 7.000 MB/s |
| Velocidad de escritura secuencial | hasta 6.500 MB/s |
| Tiempo de acceso | < 0,1 ms |

**Función dentro del sistema:**
El disco almacena de forma permanente el sistema operativo, las aplicaciones y los datos del usuario. A diferencia de la RAM, los datos persisten al apagar el equipo.

La elección de SSD NVMe frente a un HDD mecánico tradicional supone una mejora drástica en velocidad: el sistema operativo arranca en segundos, las aplicaciones se cargan casi al instante y la compilación de proyectos se reduce considerablemente.

*Comparativa de velocidad SSD vs HDD:*

| Métrica | SSD NVMe PCIe Gen 4 | HDD 7200 RPM |
|---------|---------------------|--------------|
| Lectura secuencial | 7.000 MB/s | 150 MB/s |
| Escritura secuencial | 6.500 MB/s | 150 MB/s |
| Tiempo de acceso | < 0,1 ms | 5-10 ms |
| Resistencia a golpes | Alta | Baja |

---

## 6. Tarjeta gráfica (GPU)

| Campo | Detalle |
|-------|---------|
| Modelo | NVIDIA GeForce RTX 5070 |
| VRAM | 8 GB GDDR6 |
| CUDA Cores | 4,608 |
| TGP | 80-115W |

**Función dentro del sistema:**
La GPU procesa operaciones gráficas, liberando al procesador de esa carga. En The Santy's Tours tiene varios usos prácticos:
- Renderizado de interfaces de usuario en el navegador y en las herramientas de diseño
- Edición y exportación de fotografías y vídeos de las experiencias turísticas para redes sociales
- Aceleración del renderizado de emuladores móviles
- Posible uso futuro en análisis de datos o machine learning

---

## 7. Fuente de alimentación

| Campo | Detalle |
|-------|---------|
| Tipo | Adaptador externo (cargador de portátil) |
| Potencia | 230W |
| Conector | USB-C Power Delivery / barrel connector |
| Certificación | Compatible con carga rápida |

**Función dentro del sistema:**
La fuente de alimentación convierte la corriente alterna de la red eléctrica en corriente continua a los voltajes necesarios para cada componente. Los 230W son necesarios para alimentar simultáneamente el Core i9 bajo carga completa y la RTX 3060, sin que el sistema limite el rendimiento (throttling).

---

## 8. Interacción entre componentes

El siguiente esquema muestra cómo se comunican los componentes entre sí:

```
                    ┌─────────────────┐
                    │   CPU (i9)      │
                    │  14C/20T 5GHz   │
                    └────────┬────────┘
                             │ PCIe / DMI
          ┌──────────────────┼──────────────────┐
          │                  │                  │
   ┌──────┴──────┐   ┌───────┴───────┐   ┌──────┴──────┐
   │  RAM 32GB   │   │  SSD 1TB NVMe │   │  GPU RTX    │
   │  DDR5 4800  │   │  PCIe Gen 4   │   │  3060 6GB   │
   └─────────────┘   └───────────────┘   └─────────────┘
                             │
                    ┌────────┴────────┐
                    │   Placa base    │
                    │  Chipset HM670  │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
         ┌────┴────┐   ┌─────┴─────┐  ┌────┴────┐
         │  USB/   │   │  Wi-Fi 6  │  │  HDMI   │
         │  USB-C  │   │  + BT 5.2 │  │  2.1    │
         └─────────┘   └───────────┘  └─────────┘
```
