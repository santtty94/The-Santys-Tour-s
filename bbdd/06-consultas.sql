-- =============================================================
-- The Santy's Tours — Consultas SQL útiles
-- Módulo: Gestión de Bases de Datos (0372)
-- ASIR 2025/2026
-- =============================================================

USE santys_tours;

-- =============================================================
-- CONSULTA 1: Listado completo de tours activos con su precio
-- =============================================================
SELECT
    id_tour,
    nombre,
    categoria,
    ubicacion,
    duracion_min,
    CONCAT(precio_persona, ' €') AS precio_por_persona
FROM tours
WHERE activo = 1
ORDER BY categoria, precio_persona;

-- =============================================================
-- CONSULTA 2: Próximas sesiones programadas con tour y guía
-- =============================================================
SELECT
    s.id_sesion,
    t.nombre                            AS tour,
    t.categoria,
    DATE_FORMAT(s.fecha_hora, '%d/%m/%Y %H:%i') AS fecha_hora,
    CONCAT(g.nombre, ' ', g.apellidos) AS guia,
    s.capacidad_maxima,
    s.plazas_disponibles,
    (s.capacidad_maxima - s.plazas_disponibles) AS plazas_ocupadas
FROM sesiones_tour s
JOIN tours t ON s.id_tour = t.id_tour
JOIN guias  g ON s.id_guia = g.id_guia
WHERE s.estado = 'programada'
  AND s.fecha_hora >= NOW()
ORDER BY s.fecha_hora;

-- =============================================================
-- CONSULTA 3: Reservas de un cliente concreto con detalle
-- =============================================================
SELECT
    r.id_reserva,
    CONCAT(u.nombre, ' ', u.apellidos)           AS cliente,
    t.nombre                                      AS tour,
    DATE_FORMAT(s.fecha_hora, '%d/%m/%Y %H:%i')  AS fecha_sesion,
    r.num_plazas,
    CONCAT(r.precio_total, ' €')                 AS precio_total,
    r.estado                                      AS estado_reserva,
    p.estado                                      AS estado_pago,
    p.metodo_pago
FROM reservas r
JOIN usuarios     u ON r.id_usuario = u.id_usuario
JOIN sesiones_tour s ON r.id_sesion = s.id_sesion
JOIN tours        t ON s.id_tour   = t.id_tour
LEFT JOIN pagos   p ON r.id_reserva = p.id_reserva
WHERE u.email = 'james.wilson@gmail.com'
ORDER BY s.fecha_hora DESC;

-- =============================================================
-- CONSULTA 4: Ingresos totales por tour (solo pagos cobrados)
-- =============================================================
SELECT
    t.nombre                            AS tour,
    t.categoria,
    COUNT(DISTINCT r.id_reserva)        AS num_reservas,
    SUM(r.num_plazas)                   AS total_asistentes,
    CONCAT(SUM(p.importe), ' €')        AS ingresos_totales
FROM pagos p
JOIN reservas      r ON p.id_reserva = r.id_reserva
JOIN sesiones_tour s ON r.id_sesion  = s.id_sesion
JOIN tours         t ON s.id_tour    = t.id_tour
WHERE p.estado = 'pagado'
GROUP BY t.id_tour, t.nombre, t.categoria
ORDER BY SUM(p.importe) DESC;

-- =============================================================
-- CONSULTA 5: Valoración media de cada tour (ranking)
-- =============================================================
SELECT
    t.nombre                            AS tour,
    t.categoria,
    COUNT(v.id_valoracion)              AS num_valoraciones,
    ROUND(AVG(v.puntuacion), 2)         AS puntuacion_media,
    MAX(v.puntuacion)                   AS mejor_nota,
    MIN(v.puntuacion)                   AS peor_nota
FROM tours t
LEFT JOIN valoraciones v ON t.id_tour = v.id_tour
WHERE t.activo = 1
GROUP BY t.id_tour, t.nombre, t.categoria
ORDER BY puntuacion_media DESC, num_valoraciones DESC;

-- =============================================================
-- CONSULTA 6: Tours con plazas disponibles en los próximos 30 días
-- =============================================================
SELECT
    t.nombre                            AS tour,
    t.categoria,
    DATE_FORMAT(s.fecha_hora, '%d/%m/%Y %H:%i') AS fecha,
    CONCAT(g.nombre, ' ', g.apellidos) AS guia,
    s.plazas_disponibles,
    CONCAT(t.precio_persona, ' €')      AS precio_persona
FROM sesiones_tour s
JOIN tours t ON s.id_tour = t.id_tour
JOIN guias g ON s.id_guia = g.id_guia
WHERE s.estado = 'programada'
  AND s.plazas_disponibles > 0
  AND s.fecha_hora BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 30 DAY)
ORDER BY s.fecha_hora;

-- =============================================================
-- CONSULTA 7: Sesiones completas (sin plazas) en los próximos 30 días
-- =============================================================
SELECT
    t.nombre                            AS tour,
    DATE_FORMAT(s.fecha_hora, '%d/%m/%Y %H:%i') AS fecha,
    s.capacidad_maxima                  AS aforo
FROM sesiones_tour s
JOIN tours t ON s.id_tour = t.id_tour
WHERE s.estado = 'programada'
  AND s.plazas_disponibles = 0
  AND s.fecha_hora BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 30 DAY)
ORDER BY s.fecha_hora;

-- =============================================================
-- CONSULTA 8: Guías con mayor número de sesiones completadas
-- =============================================================
SELECT
    CONCAT(g.nombre, ' ', g.apellidos) AS guia,
    g.idiomas,
    g.especialidad,
    COUNT(s.id_sesion)                 AS sesiones_completadas
FROM guias g
LEFT JOIN sesiones_tour s ON g.id_guia = s.id_guia
    AND s.estado = 'completada'
GROUP BY g.id_guia, g.nombre, g.apellidos, g.idiomas, g.especialidad
ORDER BY sesiones_completadas DESC;

-- =============================================================
-- CONSULTA 9: Clientes más activos (más reservas realizadas)
-- =============================================================
SELECT
    CONCAT(u.nombre, ' ', u.apellidos) AS cliente,
    u.email,
    COUNT(r.id_reserva)                AS num_reservas,
    SUM(r.num_plazas)                  AS total_plazas,
    CONCAT(SUM(r.precio_total), ' €')  AS gasto_total
FROM usuarios u
JOIN reservas r ON u.id_usuario = r.id_usuario
WHERE u.rol = 'cliente'
GROUP BY u.id_usuario, u.nombre, u.apellidos, u.email
ORDER BY num_reservas DESC, gasto_total DESC;

-- =============================================================
-- CONSULTA 10: Pagos pendientes de cobro
-- =============================================================
SELECT
    p.id_pago,
    CONCAT(u.nombre, ' ', u.apellidos)          AS cliente,
    u.telefono,
    t.nombre                                     AS tour,
    DATE_FORMAT(s.fecha_hora, '%d/%m/%Y %H:%i') AS fecha_sesion,
    CONCAT(p.importe, ' €')                      AS importe_pendiente,
    DATE_FORMAT(r.created_at, '%d/%m/%Y')        AS fecha_reserva
FROM pagos p
JOIN reservas      r ON p.id_reserva = r.id_reserva
JOIN usuarios      u ON r.id_usuario = u.id_usuario
JOIN sesiones_tour s ON r.id_sesion  = s.id_sesion
JOIN tours         t ON s.id_tour    = t.id_tour
WHERE p.estado = 'pendiente'
ORDER BY s.fecha_hora;

-- =============================================================
-- CONSULTA 11: Comentarios y valoraciones de un tour concreto
-- =============================================================
SELECT
    CONCAT(u.nombre, ' ', u.apellidos)   AS cliente,
    v.puntuacion,
    REPEAT('★', v.puntuacion)            AS estrellas,
    v.comentario,
    DATE_FORMAT(v.fecha, '%d/%m/%Y')     AS fecha
FROM valoraciones v
JOIN usuarios u ON v.id_usuario = u.id_usuario
JOIN tours    t ON v.id_tour    = t.id_tour
WHERE t.nombre = 'Lo mejor del Eixample modernista'
ORDER BY v.fecha DESC;

-- =============================================================
-- CONSULTA 12: Resumen general del negocio (dashboard)
-- =============================================================
SELECT
    (SELECT COUNT(*) FROM usuarios WHERE rol = 'cliente' AND activo = 1)  AS clientes_activos,
    (SELECT COUNT(*) FROM tours    WHERE activo = 1)                       AS tours_activos,
    (SELECT COUNT(*) FROM guias    WHERE activo = 1)                       AS guias_activos,
    (SELECT COUNT(*) FROM reservas WHERE estado IN ('confirmada','completada')) AS reservas_totales,
    (SELECT CONCAT(SUM(importe), ' €') FROM pagos WHERE estado = 'pagado') AS ingresos_totales,
    (SELECT ROUND(AVG(puntuacion),2) FROM valoraciones)                    AS valoracion_media_global;
