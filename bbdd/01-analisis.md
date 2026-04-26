# 01 — Análisis de datos del sistema

## The Santy's Tours — Gestión de Bases de Datos

---

## 1. Descripción del sistema

The Santy's Tours es una empresa de turismo de ocio y aventura con sede en Barcelona que ofrece tours guiados y experiencias culturales (flamenco, gastronomía, etc.) en Barcelona y alrededores (Montserrat, Sitges, etc.).

El sistema de reservas permite a los clientes reservar plazas en sesiones programadas de tours. Los pagos se realizan de forma presencial el día del tour (efectivo o tarjeta). Los clientes que completan un tour pueden dejar una valoración con puntuación y comentario.

---

## 2. Información que necesita almacenar el sistema

### 2.1 Usuarios

El sistema necesita registrar a las personas que interactúan con la plataforma. Existen tres roles diferenciados:

- **cliente**: turistas que reservan plazas en los tours.
- **admin**: personal interno que gestiona el catálogo y las reservas.
- **guia**: rol que puede tener acceso al sistema, aunque los datos del guía como profesional se almacenan en la tabla `guias`.

Datos necesarios: nombre completo, correo electrónico, teléfono de contacto, fecha de registro, rol y estado de la cuenta (activo/inactivo).

**Por qué es necesario:** sin identificar al usuario no es posible asociar reservas, pagos ni valoraciones a una persona concreta.

---

### 2.2 Guías

Los tours son llevados por guías profesionales. Puede haber más de un guía por sesión en grupos grandes. Cada guía tiene su especialidad y los idiomas en que puede conducir un tour.

Datos necesarios: nombre completo, teléfono, correo, idiomas que habla, especialidad y estado (activo/inactivo).

**Por qué es necesario:** permite asignar el guía adecuado a cada sesión y llevar un registro de disponibilidad y especialización.

---

### 2.3 Tours

El catálogo de productos de la empresa. Cada tour representa un tipo de experiencia (tour a pie, experiencia flamenco, excursión a Montserrat, etc.), con su descripción, duración estimada, precio base por persona, ubicación y categoría.

Datos necesarios: nombre del tour, descripción, duración en minutos, precio por persona, categoría (tour/experiencia/excursión), ubicación e idioma de la sesión (es/en — guía bilingüe).

**Por qué es necesario:** es el núcleo del catálogo. Sin esta entidad no hay nada que reservar ni vender.

---

### 2.4 Sesiones de tour

Un mismo tour puede programarse múltiples veces con distintas fechas, horarios, guías y capacidades. Cada convocatoria concreta es una sesión.

Datos necesarios: tour al que pertenece, fecha y hora de inicio, capacidad máxima de plazas, plazas disponibles restantes, guía asignado y estado (programada/completada/cancelada).

**Por qué es necesario:** sin sesiones no es posible gestionar la disponibilidad real de plazas ni programar la agenda de guías.

---

### 2.5 Reservas

Registro de cada reserva realizada por un cliente para una sesión concreta. El cliente reserva un número de plazas dentro de la sesión.

Datos necesarios: cliente que reserva, sesión reservada, número de plazas, precio total calculado, fecha en que se realizó la reserva y estado (pendiente/confirmada/cancelada/completada).

**Por qué es necesario:** es el vínculo principal entre el cliente y la sesión. Sin reservas no hay control de ocupación ni trazabilidad de quién asiste.

---

### 2.6 Pagos

Cada reserva genera un pago que se realiza de forma presencial el día del tour (efectivo o tarjeta). Se registra el método, el importe y el estado del cobro.

Datos necesarios: reserva asociada, método de pago (efectivo/tarjeta), importe cobrado, fecha del pago y estado (pendiente/pagado/reembolsado).

**Por qué es necesario:** permite llevar la contabilidad del negocio, detectar reservas sin cobrar y gestionar futuros reembolsos si se implementa política de cancelaciones.

---

### 2.7 Valoraciones

Después de completar un tour, el cliente puede dejar una valoración con puntuación del 1 al 5 y un comentario opcional. Solo los clientes que tienen una reserva en estado `completada` para ese tour pueden valorar.

Datos necesarios: cliente que valora, tour valorado, puntuación (1-5), comentario y fecha de la valoración.

**Por qué es necesario:** las valoraciones son clave para la reputación online del negocio y para mejorar la calidad de los tours.

---

## 3. Relaciones entre entidades

| Relación | Tipo | Descripción |
|---|---|---|
| Usuario — Reserva | 1:N | Un usuario puede tener varias reservas |
| Tour — Sesión | 1:N | Un tour puede tener varias sesiones programadas |
| Guía — Sesión | 1:N | Un guía puede llevar varias sesiones |
| Sesión — Reserva | 1:N | Una sesión puede tener varias reservas |
| Reserva — Pago | 1:1 | Cada reserva genera un único pago |
| Usuario — Valoración | 1:N | Un usuario puede valorar varios tours |
| Tour — Valoración | 1:N | Un tour puede tener varias valoraciones |

---

## 4. Resumen de entidades

| Entidad | Tabla | Descripción |
|---|---|---|
| Usuarios | `usuarios` | Clientes, admins y personal del sistema |
| Guías | `guias` | Profesionales que conducen los tours |
| Tours | `tours` | Catálogo de tours y experiencias |
| Sesiones | `sesiones_tour` | Convocatorias concretas de cada tour |
| Reservas | `reservas` | Plazas reservadas por un cliente en una sesión |
| Pagos | `pagos` | Registro de cobros asociados a cada reserva |
| Valoraciones | `valoraciones` | Reseñas de clientes sobre tours completados |
