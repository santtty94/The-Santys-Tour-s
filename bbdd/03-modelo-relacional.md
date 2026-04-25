# 03 — Modelo Relacional

## The Santy's Tours — Gestión de Bases de Datos

---

## Modelo relacional normalizado (3FN)

Las claves primarias se indican con **PK** y las foráneas con *FK*.

---

### usuarios (**id_usuario**, nombre, apellidos, email, telefono, rol, activo, created_at)

| Campo | Tipo | Restricción |
|---|---|---|
| **id_usuario** | INT | PK, AUTO_INCREMENT |
| nombre | VARCHAR(100) | NOT NULL |
| apellidos | VARCHAR(150) | NOT NULL |
| email | VARCHAR(150) | NOT NULL, UNIQUE |
| telefono | VARCHAR(20) | NULL |
| rol | ENUM('cliente','admin','guia') | NOT NULL, DEFAULT 'cliente' |
| activo | TINYINT(1) | NOT NULL, DEFAULT 1 |
| created_at | DATETIME | NOT NULL, DEFAULT NOW() |

---

### guias (**id_guia**, nombre, apellidos, email, telefono, idiomas, especialidad, activo)

| Campo | Tipo | Restricción |
|---|---|---|
| **id_guia** | INT | PK, AUTO_INCREMENT |
| nombre | VARCHAR(100) | NOT NULL |
| apellidos | VARCHAR(150) | NOT NULL |
| email | VARCHAR(150) | NOT NULL, UNIQUE |
| telefono | VARCHAR(20) | NOT NULL |
| idiomas | VARCHAR(100) | NOT NULL |
| especialidad | VARCHAR(200) | NULL |
| activo | TINYINT(1) | NOT NULL, DEFAULT 1 |

---

### tours (**id_tour**, nombre, descripcion, duracion_min, precio_persona, categoria, ubicacion, idioma, activo)

| Campo | Tipo | Restricción |
|---|---|---|
| **id_tour** | INT | PK, AUTO_INCREMENT |
| nombre | VARCHAR(200) | NOT NULL |
| descripcion | TEXT | NULL |
| duracion_min | INT | NOT NULL |
| precio_persona | DECIMAL(8,2) | NOT NULL |
| categoria | ENUM('tour','experiencia','excursion') | NOT NULL |
| ubicacion | VARCHAR(200) | NOT NULL |
| idioma | ENUM('es','en','es/en') | NOT NULL, DEFAULT 'es/en' |
| activo | TINYINT(1) | NOT NULL, DEFAULT 1 |

---

### sesiones_tour (**id_sesion**, *id_tour*, *id_guia*, fecha_hora, capacidad_maxima, plazas_disponibles, estado)

| Campo | Tipo | Restricción |
|---|---|---|
| **id_sesion** | INT | PK, AUTO_INCREMENT |
| *id_tour* | INT | FK → tours(id_tour), NOT NULL |
| *id_guia* | INT | FK → guias(id_guia), NOT NULL |
| fecha_hora | DATETIME | NOT NULL |
| capacidad_maxima | INT | NOT NULL |
| plazas_disponibles | INT | NOT NULL |
| estado | ENUM('programada','completada','cancelada') | NOT NULL, DEFAULT 'programada' |

---

### reservas (**id_reserva**, *id_usuario*, *id_sesion*, num_plazas, precio_total, estado, created_at)

| Campo | Tipo | Restricción |
|---|---|---|
| **id_reserva** | INT | PK, AUTO_INCREMENT |
| *id_usuario* | INT | FK → usuarios(id_usuario), NOT NULL |
| *id_sesion* | INT | FK → sesiones_tour(id_sesion), NOT NULL |
| num_plazas | INT | NOT NULL, CHECK (num_plazas > 0) |
| precio_total | DECIMAL(10,2) | NOT NULL |
| estado | ENUM('pendiente','confirmada','cancelada','completada') | NOT NULL, DEFAULT 'pendiente' |
| created_at | DATETIME | NOT NULL, DEFAULT NOW() |

---

### pagos (**id_pago**, *id_reserva*, metodo_pago, importe, estado, fecha_pago)

| Campo | Tipo | Restricción |
|---|---|---|
| **id_pago** | INT | PK, AUTO_INCREMENT |
| *id_reserva* | INT | FK → reservas(id_reserva), NOT NULL, UNIQUE |
| metodo_pago | ENUM('efectivo','tarjeta') | NOT NULL |
| importe | DECIMAL(10,2) | NOT NULL |
| estado | ENUM('pendiente','pagado','reembolsado') | NOT NULL, DEFAULT 'pendiente' |
| fecha_pago | DATETIME | NULL |

---

### valoraciones (**id_valoracion**, *id_usuario*, *id_tour*, puntuacion, comentario, fecha)

| Campo | Tipo | Restricción |
|---|---|---|
| **id_valoracion** | INT | PK, AUTO_INCREMENT |
| *id_usuario* | INT | FK → usuarios(id_usuario), NOT NULL |
| *id_tour* | INT | FK → tours(id_tour), NOT NULL |
| puntuacion | TINYINT | NOT NULL, CHECK (puntuacion BETWEEN 1 AND 5) |
| comentario | TEXT | NULL |
| fecha | DATETIME | NOT NULL, DEFAULT NOW() |
| | | UNIQUE(id_usuario, id_tour) |

---

## Normalización

La base de datos cumple la **Tercera Forma Normal (3FN)**:

- **1FN**: todos los campos son atómicos, no hay grupos repetitivos.
- **2FN**: todos los atributos no clave dependen completamente de la clave primaria (todas las tablas tienen PK simple).
- **3FN**: no existen dependencias transitivas. Cada atributo no clave depende únicamente de la PK, no de otro atributo no clave.

---

## Índices recomendados

```sql
-- Búsquedas frecuentes por email
CREATE INDEX idx_usuarios_email ON usuarios(email);

-- Búsquedas de sesiones por fecha
CREATE INDEX idx_sesiones_fecha ON sesiones_tour(fecha_hora);

-- Búsquedas de reservas por usuario
CREATE INDEX idx_reservas_usuario ON reservas(id_usuario);

-- Búsquedas de valoraciones por tour
CREATE INDEX idx_valoraciones_tour ON valoraciones(id_tour);
```
