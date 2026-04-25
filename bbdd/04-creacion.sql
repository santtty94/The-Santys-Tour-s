-- =============================================================
-- The Santy's Tours — Script de creación de la base de datos
-- Módulo: Gestión de Bases de Datos (0372)
-- ASIR 2025/2026
-- =============================================================

DROP DATABASE IF EXISTS santys_tours;
CREATE DATABASE santys_tours
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE santys_tours;

-- =============================================================
-- TABLA: usuarios
-- Clientes, administradores y personal del sistema
-- =============================================================
CREATE TABLE usuarios (
    id_usuario    INT             NOT NULL AUTO_INCREMENT,
    nombre        VARCHAR(100)    NOT NULL,
    apellidos     VARCHAR(150)    NOT NULL,
    email         VARCHAR(150)    NOT NULL,
    telefono      VARCHAR(20)     NULL,
    rol           ENUM('cliente','admin','guia') NOT NULL DEFAULT 'cliente',
    activo        TINYINT(1)      NOT NULL DEFAULT 1,
    created_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_usuarios PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuarios_email UNIQUE (email)
) ENGINE=InnoDB;

-- =============================================================
-- TABLA: guias
-- Guías profesionales que conducen los tours
-- =============================================================
CREATE TABLE guias (
    id_guia       INT             NOT NULL AUTO_INCREMENT,
    nombre        VARCHAR(100)    NOT NULL,
    apellidos     VARCHAR(150)    NOT NULL,
    email         VARCHAR(150)    NOT NULL,
    telefono      VARCHAR(20)     NOT NULL,
    idiomas       VARCHAR(100)    NOT NULL COMMENT 'Ej: Español, Inglés',
    especialidad  VARCHAR(200)    NULL,
    activo        TINYINT(1)      NOT NULL DEFAULT 1,

    CONSTRAINT pk_guias PRIMARY KEY (id_guia),
    CONSTRAINT uq_guias_email UNIQUE (email)
) ENGINE=InnoDB;

-- =============================================================
-- TABLA: tours
-- Catálogo de tours y experiencias disponibles
-- =============================================================
CREATE TABLE tours (
    id_tour           INT                             NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(200)                    NOT NULL,
    descripcion       TEXT                            NULL,
    duracion_min      INT                             NOT NULL COMMENT 'Duración en minutos',
    precio_persona    DECIMAL(8,2)                    NOT NULL,
    categoria         ENUM('tour','experiencia','excursion') NOT NULL,
    ubicacion         VARCHAR(200)                    NOT NULL,
    idioma            ENUM('es','en','es/en')         NOT NULL DEFAULT 'es/en',
    activo            TINYINT(1)                      NOT NULL DEFAULT 1,

    CONSTRAINT pk_tours PRIMARY KEY (id_tour),
    CONSTRAINT chk_tours_precio CHECK (precio_persona > 0),
    CONSTRAINT chk_tours_duracion CHECK (duracion_min > 0)
) ENGINE=InnoDB;

-- =============================================================
-- TABLA: sesiones_tour
-- Convocatorias concretas de cada tour (fecha, hora, guía, plazas)
-- =============================================================
CREATE TABLE sesiones_tour (
    id_sesion           INT         NOT NULL AUTO_INCREMENT,
    id_tour             INT         NOT NULL,
    id_guia             INT         NOT NULL,
    fecha_hora          DATETIME    NOT NULL,
    capacidad_maxima    INT         NOT NULL,
    plazas_disponibles  INT         NOT NULL,
    estado              ENUM('programada','completada','cancelada') NOT NULL DEFAULT 'programada',

    CONSTRAINT pk_sesiones PRIMARY KEY (id_sesion),
    CONSTRAINT fk_sesiones_tour FOREIGN KEY (id_tour)
        REFERENCES tours(id_tour) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_sesiones_guia FOREIGN KEY (id_guia)
        REFERENCES guias(id_guia) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_sesiones_capacidad CHECK (capacidad_maxima > 0),
    CONSTRAINT chk_sesiones_plazas CHECK (plazas_disponibles >= 0),
    CONSTRAINT chk_sesiones_plazas_max CHECK (plazas_disponibles <= capacidad_maxima)
) ENGINE=InnoDB;

-- =============================================================
-- TABLA: reservas
-- Plazas reservadas por un cliente en una sesión concreta
-- =============================================================
CREATE TABLE reservas (
    id_reserva    INT             NOT NULL AUTO_INCREMENT,
    id_usuario    INT             NOT NULL,
    id_sesion     INT             NOT NULL,
    num_plazas    INT             NOT NULL,
    precio_total  DECIMAL(10,2)  NOT NULL,
    estado        ENUM('pendiente','confirmada','cancelada','completada') NOT NULL DEFAULT 'pendiente',
    created_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_reservas PRIMARY KEY (id_reserva),
    CONSTRAINT fk_reservas_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_reservas_sesion FOREIGN KEY (id_sesion)
        REFERENCES sesiones_tour(id_sesion) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_reservas_plazas CHECK (num_plazas > 0),
    CONSTRAINT chk_reservas_precio CHECK (precio_total > 0)
) ENGINE=InnoDB;

-- =============================================================
-- TABLA: pagos
-- Registro de cobros asociados a cada reserva
-- =============================================================
CREATE TABLE pagos (
    id_pago       INT             NOT NULL AUTO_INCREMENT,
    id_reserva    INT             NOT NULL,
    metodo_pago   ENUM('efectivo','tarjeta') NOT NULL,
    importe       DECIMAL(10,2)  NOT NULL,
    estado        ENUM('pendiente','pagado','reembolsado') NOT NULL DEFAULT 'pendiente',
    fecha_pago    DATETIME        NULL COMMENT 'NULL hasta que se efectúa el cobro',

    CONSTRAINT pk_pagos PRIMARY KEY (id_pago),
    CONSTRAINT fk_pagos_reserva FOREIGN KEY (id_reserva)
        REFERENCES reservas(id_reserva) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_pagos_reserva UNIQUE (id_reserva),
    CONSTRAINT chk_pagos_importe CHECK (importe > 0)
) ENGINE=InnoDB;

-- =============================================================
-- TABLA: valoraciones
-- Reseñas de clientes sobre tours completados
-- =============================================================
CREATE TABLE valoraciones (
    id_valoracion INT         NOT NULL AUTO_INCREMENT,
    id_usuario    INT         NOT NULL,
    id_tour       INT         NOT NULL,
    puntuacion    TINYINT     NOT NULL,
    comentario    TEXT        NULL,
    fecha         DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_valoraciones PRIMARY KEY (id_valoracion),
    CONSTRAINT fk_valoraciones_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_valoraciones_tour FOREIGN KEY (id_tour)
        REFERENCES tours(id_tour) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_valoraciones UNIQUE (id_usuario, id_tour),
    CONSTRAINT chk_valoraciones_puntuacion CHECK (puntuacion BETWEEN 1 AND 5)
) ENGINE=InnoDB;

-- =============================================================
-- ÍNDICES para mejorar el rendimiento en consultas frecuentes
-- =============================================================
CREATE INDEX idx_sesiones_fecha    ON sesiones_tour(fecha_hora);
CREATE INDEX idx_reservas_usuario  ON reservas(id_usuario);
CREATE INDEX idx_reservas_sesion   ON reservas(id_sesion);
CREATE INDEX idx_valoraciones_tour ON valoraciones(id_tour);
CREATE INDEX idx_pagos_estado      ON pagos(estado);
