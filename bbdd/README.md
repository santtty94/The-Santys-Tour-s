# 🗄️ Gestión de Bases de Datos — The Santy's Tours

Módulo: **Gestión de Bases de Datos (0372)** · ASIR 2025/2026

---

## Descripción

Este directorio contiene todo el trabajo correspondiente al módulo de **Gestión de Bases de Datos** del Proyecto Intermodular. El objetivo es diseñar, implementar y administrar la base de datos que utiliza el sistema de reservas de **The Santy's Tours**, una empresa de turismo de ocio y aventura con base en Barcelona.

---

## Contenido del directorio

| Archivo | Descripción |
|---|---|
| `01-analisis.md` | Análisis de los datos del sistema: qué se almacena y por qué |
| `02-diagrama-er.md` | Diagrama Entidad–Relación con relaciones y cardinalidades |
| `03-modelo-relacional.md` | Modelo relacional normalizado (3FN) con todos los campos |
| `04-creacion.sql` | Script SQL de creación de la base de datos |
| `05-datos-prueba.sql` | Script SQL con datos de prueba realistas |
| `06-consultas.sql` | 12 consultas SQL útiles para el sistema |
| `07-administracion.md` | Guía de administración: backups, usuarios y mantenimiento |

---

## Diseño de la base de datos

### Motor y codificación

- **Motor:** InnoDB (soporte de transacciones y claves foráneas)
- **Codificación:** UTF-8MB4 (soporte completo de caracteres internacionales)
- **SGBD:** MySQL 8.x

### Tablas

```
santys_tours
├── usuarios        — Clientes y personal del sistema
├── guias           — Guías profesionales de los tours
├── tours           — Catálogo de tours y experiencias
├── sesiones_tour   — Convocatorias programadas de cada tour
├── reservas        — Plazas reservadas por clientes
├── pagos           — Registro de cobros (presencial: efectivo/tarjeta)
└── valoraciones    — Reseñas de clientes (1-5 estrellas + comentario)
```

### Relaciones principales

```
usuarios ──< reservas >── sesiones_tour >── tours
                │                 │
             pagos (1:1)      guias

usuarios ──< valoraciones >── tours
```

---

## Cómo ejecutar los scripts

```bash
# 1. Crear la base de datos y las tablas
mysql -u root -p < 04-creacion.sql

# 2. Insertar los datos de prueba
mysql -u root -p < 05-datos-prueba.sql

# 3. Ejecutar consultas de ejemplo
mysql -u root -p santys_tours < 06-consultas.sql
```

---

## Datos de prueba incluidos

| Tabla | Registros |
|---|---|
| usuarios | 10 (1 admin, 7 clientes, 2 más) |
| guias | 6 |
| tours | 8 |
| sesiones_tour | 12 |
| reservas | 12 |
| pagos | 12 |
| valoraciones | 8 |

Los datos de prueba son ficticios pero realistas: clientes internacionales (Reino Unido, Francia, Alemania, Italia, Japón, Marruecos), tours reales de Barcelona y alrededores, y precios coherentes con el mercado actual.

---

## Normalización

La base de datos cumple la **Tercera Forma Normal (3FN)**:

- **1FN**: todos los campos son atómicos.
- **2FN**: todos los atributos dependen completamente de la clave primaria.
- **3FN**: no existen dependencias transitivas entre atributos no clave.
