# 🏷️ LMSGI — Lenguajes de Marcas

**Módulo:** Lenguajes de Marcas y Sistemas de Gestión de Información (0373)  
**Proyecto:** The Santy's Tours — Proyecto Intermodular ASIR 2025/2026

---

## 📁 Contenido del directorio

| Archivo | Descripción |
|---------|-------------|
| `catalogo-reservas.xml` | Exportación del catálogo de tours y reservas activas |
| `esquema.xsd` | Esquema XSD que valida el XML |
| `catalogo-error.xml` | XML con errores intencionados (demuestra que el XSD controla) |
| `docs/validacion.md` | Evidencia de validación con pantallazos de VS Code |
| `docs/Catalogo-reservas.xml.png` | Pantallazo: XML correcto — 0 errores en VS Code |
| `docs/Catalago-error.xml.png` | Pantallazo: XML con errores — 14 problemas detectados |

---

## 📄 Qué datos representa el XML

`catalogo-reservas.xml` es una **exportación estructurada** del sistema de gestión de The Santy's Tours. Representa el catálogo activo de tours junto con sus sesiones programadas y las reservas confirmadas para cada sesión.

### Estructura jerárquica

```
exportacion
├── empresa              → datos de identificación de The Santy's Tours
└── tours
    └── tour             → cada tour del catálogo (id, nombre, categoría, precio...)
        └── sesiones
            └── sesion   → cada convocatoria programada (fecha, guía, plazas...)
                └── reservas
                    └── reserva  → cada plaza reservada (cliente, plazas, pago...)
```

### Datos incluidos

- **4 tours** del catálogo: Tour Barrio Gótico, Experiencia Flamenco, Excursión Montserrat, Ruta Gastronómica Born
- **6 sesiones** programadas para mayo de 2026
- **8 reservas** activas con datos de clientes internacionales (UK, Francia, Alemania, Italia, Japón, Marruecos)
- **8 pagos** presenciales asociados (efectivo o tarjeta, pendientes de cobro el día del tour)

---

## ✅ Cómo se valida

La validación se realiza con **VS Code** usando la extensión **XML de Red Hat**, que valida automáticamente el XML contra el XSD referenciado en la cabecera del archivo.

### Herramienta utilizada

- **Editor:** Visual Studio Code
- **Extensión:** XML (Red Hat)
- **Evidencia:** pantallazos en `docs/`

### El archivo `esquema.xsd` valida comprobando:

**Tipos de datos**
- `xs:string`, `xs:integer`, `xs:decimal`, `xs:boolean`, `xs:date`, `xs:dateTime`

**Enumeraciones** (extraídas directamente de los ENUMs de la BBDD `santys_tours`)
- **Categoría de tour:** `tour` | `experiencia` | `excursion`
- **Idioma:** `es` | `en` | `es/en`
- **Estado sesión:** `programada` | `completada` | `cancelada`
- **Estado reserva:** `pendiente` | `confirmada` | `cancelada` | `completada`
- **Método de pago:** `efectivo` | `tarjeta` *(pago presencial el día del tour)*
- **Estado pago:** `pendiente` | `pagado` | `reembolsado`
- **Entorno sistema:** `produccion` | `desarrollo` | `pruebas`

**Restricciones de valor**
- Precio mínimo: `0.01` (no puede ser negativo ni cero)
- Duración mínima: `30 minutos` — máxima: `1440 minutos`
- Plazas por reserva: entre `1` y `20`
- Email: patrón regex `[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}`
- Nombres: entre 2 y 150 caracteres

**Cardinalidades**
- Un tour debe tener **entre 1 y 52 sesiones**
- Una sesión puede tener **0 o más reservas**
- El catálogo debe incluir **al menos 1 tour**

### Resultado de la validación

| Archivo | Resultado |
|---------|-----------|
| `catalogo-reservas.xml` | ✅ **0 errores** — "No se ha detectado ningún problema en el área de trabajo" |
| `catalogo-error.xml` | ❌ **14 errores** detectados — el XSD rechaza los datos incorrectos |

---

## 🔗 Integración con el proyecto

Este XML **no es un documento aislado**: está directamente conectado con el resto del proyecto intermodular.

| Módulo | Conexión |
|--------|----------|
| **GBD** | Las enumeraciones del XSD son exactamente los mismos `ENUM` de la BBDD MySQL `santys_tours`. Los `id_tour`, `id_sesion`, `id_reserva` corresponden a las PKs de las tablas. Los precios respetan `DECIMAL(8,2)`. |
| **MPO** | El XML simula una exportación generada por la API REST (Node.js en EC2) desde la base de datos RDS MySQL (región `eu-west-1`). El atributo `base_datos="santys_tours"` y `entorno="produccion"` reflejan la arquitectura AWS documentada. |
| **PAR** | Los datos de clientes internacionales (UK, FR, DE, IT, JP, MA) son coherentes con la red diseñada para dar servicio a turistas de todo el mundo. |

### Caso de uso real

La API REST de The Santy's Tours podría generar este XML como **exportación del catálogo** para:
- Sincronizar datos con plataformas externas (Booking, Airbnb Experiences, GetYourGuide)
- Generar informes de ocupación para gestión interna
- Integrar con sistemas de facturación o contabilidad

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
