# 02 — Diagrama Entidad–Relación

## The Santy's Tours — Gestión de Bases de Datos

---

## Diagrama E/R

```
+----------------+        +------------------+        +--------------+
|    USUARIOS    |        |      GUIAS       |        |    TOURS     |
+----------------+        +------------------+        +--------------+
| PK id_usuario  |        | PK id_guia       |        | PK id_tour   |
|    nombre      |        |    nombre        |        |    nombre    |
|    apellidos   |        |    apellidos     |        |    descripcion|
|    email       |        |    email         |        |    duracion  |
|    telefono    |        |    telefono      |        |    precio    |
|    rol         |        |    idiomas       |        |    categoria |
|    activo      |        |    especialidad  |        |    ubicacion |
|    created_at  |        |    activo        |        |    idioma    |
+----------------+        +------------------+        |    activo    |
        |                          |                  +--------------+
        | 1                        | 1                       | 1
        |                          |                         |
        | N                        | N                       | N
        v                          v                         v
+----------------+        +------------------+        +--------------+
|   RESERVAS     |        |  SESIONES_TOUR   |<-------| SESIONES_TOUR|
+----------------+        +------------------+        +--------------+
| PK id_reserva  |        | PK id_sesion     |        (misma tabla)
| FK id_usuario  |------->| FK id_tour       |
| FK id_sesion   |        | FK id_guia       |
|    num_plazas  |        |    fecha_hora    |
|    precio_total|        |    cap_maxima    |
|    estado      |        |    plazas_disp   |
|    created_at  |        |    estado        |
+----------------+        +------------------+
        | 1
        |
        | 1
        v
+----------------+
|     PAGOS      |
+----------------+
| PK id_pago     |
| FK id_reserva  |
|    metodo_pago |
|    importe     |
|    estado      |
|    fecha_pago  |
+----------------+

        +----------------+
        |  VALORACIONES  |
        +----------------+
        | PK id_valoracion|
        | FK id_usuario  |-----> USUARIOS
        | FK id_tour     |-----> TOURS
        |    puntuacion  |
        |    comentario  |
        |    fecha       |
        +----------------+
```

---

## Descripción de relaciones

### USUARIOS — RESERVAS (1:N)
Un usuario puede realizar múltiples reservas a lo largo del tiempo. Cada reserva pertenece a un único usuario. Relación obligatoria: no puede existir una reserva sin usuario.

### TOURS — SESIONES_TOUR (1:N)
Un tour del catálogo puede programarse en múltiples sesiones con distintas fechas, horas y guías. Cada sesión pertenece a un único tour. Sin tour no puede existir sesión.

### GUIAS — SESIONES_TOUR (1:N)
Un guía puede ser asignado a múltiples sesiones. En grupos grandes puede haber más de un guía (gestionado a nivel de aplicación). Cada sesión tiene un guía principal asignado.

### SESIONES_TOUR — RESERVAS (1:N)
Una sesión puede tener múltiples reservas hasta cubrir su capacidad máxima. Cada reserva está ligada a una única sesión.

### RESERVAS — PAGOS (1:1)
Cada reserva genera exactamente un registro de pago. El pago puede estar pendiente (se realiza el día del tour de forma presencial).

### USUARIOS — VALORACIONES (1:N)
Un usuario puede valorar múltiples tours, siempre que los haya completado. Cada valoración pertenece a un único usuario.

### TOURS — VALORACIONES (1:N)
Un tour puede acumular múltiples valoraciones de distintos clientes. Cada valoración hace referencia a un único tour.

---

## Cardinalidades resumidas

| Entidad A | Relación | Entidad B | Cardinalidad |
|---|---|---|---|
| USUARIOS | realiza | RESERVAS | 1:N |
| TOURS | se programa en | SESIONES_TOUR | 1:N |
| GUIAS | conduce | SESIONES_TOUR | 1:N |
| SESIONES_TOUR | contiene | RESERVAS | 1:N |
| RESERVAS | genera | PAGOS | 1:1 |
| USUARIOS | deja | VALORACIONES | 1:N |
| TOURS | recibe | VALORACIONES | 1:N |

---

## Restricciones de integridad destacadas

- Un cliente solo puede valorar un tour si tiene una reserva en estado `completada` para ese tour.
- Las plazas disponibles de una sesión no pueden ser negativas.
- El precio total de una reserva debe coincidir con `num_plazas × precio_por_persona` del tour.
- No pueden existir dos valoraciones del mismo usuario para el mismo tour.
