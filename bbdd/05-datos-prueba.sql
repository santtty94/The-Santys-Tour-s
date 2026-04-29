-- =============================================================
-- The Santy's Tours — Datos de prueba
-- Módulo: Gestión de Bases de Datos (0372)
-- ASIR 2025/2026
-- =============================================================
h
USE santys_tours;

-- =============================================================
-- USUARIOS (10 registros: 1 admin, 7 clientes, 2 con rol guia)
-- =============================================================
INSERT INTO usuarios (nombre, apellidos, email, telefono, rol, activo, created_at) VALUES
('Santiago',  'Martínez López',   'santiago@santystours.com',  '+34 612 345 678', 'admin',   1, '2024-01-10 09:00:00'),
('James',     'Wilson',           'james.wilson@gmail.com',    '+44 7700 900123', 'cliente', 1, '2024-02-15 11:30:00'),
('Sophie',    'Dubois',           'sophie.dubois@outlook.fr',  '+33 6 12 34 56 78','cliente',1, '2024-02-20 14:00:00'),
('Carlos',    'Fernández Ruiz',   'carlos.fernandez@gmail.com','+34 654 789 012', 'cliente', 1, '2024-03-01 10:15:00'),
('Yuki',      'Tanaka',           'yuki.tanaka@yahoo.co.jp',   '+81 90 1234 5678', 'cliente',1, '2024-03-10 08:45:00'),
('Emma',      'Schneider',        'emma.schneider@web.de',     '+49 151 23456789','cliente', 1, '2024-03-18 16:20:00'),
('Martina',   'Rossi',            'martina.rossi@libero.it',   '+39 333 456 7890','cliente', 1, '2024-04-05 12:00:00'),
('David',     'García Pérez',     'david.garcia@hotmail.com',  '+34 678 901 234', 'cliente', 1, '2024-04-12 09:30:00'),
('Laura',     'Sánchez Moreno',   'laura.sanchez@gmail.com',   '+34 691 234 567', 'cliente', 1, '2024-04-20 17:00:00'),
('Ahmed',     'El Mansouri',      'ahmed.elmansouri@gmail.com','+212 6 61 234567','cliente', 1, '2024-05-03 13:45:00');

-- =============================================================
-- GUÍAS (6 registros)
-- =============================================================
INSERT INTO guias (nombre, apellidos, email, telefono, idiomas, especialidad, activo) VALUES
('Marc',      'Puigdomènech',  'marc.puig@santystours.com',    '+34 611 111 001', 'Español, Inglés',         'Historia y arquitectura modernista de Barcelona',      1),
('Claudia',   'Romero Vidal',  'claudia.romero@santystours.com','+34 611 111 002', 'Español, Inglés',        'Gastronomía catalana y experiencias culturales',       1),
('Jordi',     'Sala Mas',      'jordi.sala@santystours.com',   '+34 611 111 003', 'Español, Inglés, Catalán','Excursiones de naturaleza y senderismo',               1),
('Natalia',   'Gómez Torres',  'natalia.gomez@santystours.com','+34 611 111 004', 'Español, Inglés',         'Arte flamenco y cultura andaluza en Barcelona',        1),
('Pau',       'Esteve Roca',   'pau.esteve@santystours.com',   '+34 611 111 005', 'Español, Inglés, Catalán','Barrios históricos y leyendas urbanas de Barcelona',   1),
('Marta',     'Llopis Serra',  'marta.llopis@santystours.com', '+34 611 111 006', 'Español, Inglés',         'Excursiones día completo y turismo familiar',          1);

-- =============================================================
-- TOURS (8 registros)
-- =============================================================
INSERT INTO tours (nombre, descripcion, duracion_min, precio_persona, categoria, ubicacion, idioma, activo) VALUES
('Lo mejor del Eixample modernista',
 'Recorrido a pie por las joyas del modernismo catalán: la Sagrada Família, la Casa Batlló y la Casa Milà (La Pedrera). El guía explica la vida y obra de Gaudí y sus contemporáneos.',
 150, 29.00, 'tour', 'Eixample, Barcelona', 'es/en', 1),

('Barrio Gótico y El Born secreto',
 'Descubre los rincones más desconocidos del Barrio Gótico y el trendy barrio de El Born. Historia, leyendas medievales y los mejores bares de vermut.',
 120, 22.00, 'tour', 'Barrio Gótico / El Born, Barcelona', 'es/en', 1),

('Experiencia flamenca en Barcelona',
 'Noche de flamenco auténtico en un tablao con cena de tapas incluida. Espectáculo de 45 minutos con artistas profesionales y explicación de la historia del flamenco.',
 180, 65.00, 'experiencia', 'El Raval, Barcelona', 'es/en', 1),

 'Excursión de día completo a la montaña de Montserrat. Incluye transporte desde Barcelona, telecabina, visita al monasterio y tiempo libre para senderismo.',
 480, 75.00, 'excursion', 'Montserrat, Barcelona', 'es/en', 1),


('Mercado de La Boqueria y taller de cocina catalana',
 'Visita guiada al Mercado de La Boqueria con el chef seleccionando ingredientes frescos, seguida de un taller de cocina donde aprenderás a elaborar pan con tomate, escalivada y crema catalana.',
 240, 89.00, 'experiencia', 'La Rambla, Barcelona', 'es/en', 1),


('Sitges en un día: pueblo, playas y cava',
 'Excursión a Sitges, la joya del Mediterráneo. Visita del casco histórico, tiempo libre en la playa y cata de cava en una bodega local.',
 420, 68.00, 'excursion', 'Sitges, Garraf', 'es/en', 1),


('Montjuïc: castillo, jardines y vistas',
 'Subida en teleférico al castillo de Montjuïc, visita a los jardines de Laribal y a la Fundació Joan Miró. Las mejores vistas panorámicas de Barcelona.',
 180, 35.00, 'tour', 'Montjuïc, Barcelona', 'es/en', 1),


('Gràcia y el Parque Güell al atardecer',
 'Paseo por el bohemio barrio de Gràcia hasta llegar al Parque Güell para disfrutar del atardecer desde la terraza principal. El tour incluye parada en una heladería artesanal del barrio.',
 150, 25.00, 'tour', 'Gràcia / Parque Güell, Barcelona', 'es/en', 1);


-- =============================================================
-- SESIONES DE TOUR (12 registros — tours repetidos en distintas fechas)
-- Nota: plazas_disponibles = capacidad_maxima - plazas reservadas en este script
-- ================================================cancelada'),
INSERT INTO sesiones_tour (id_tour, id_guia, fecha_hora, capacidad_maxima, plazas_disponibles, estado) VALUES
-- Tour Eixample modernista (id_tour=1): 4 sesiones
-- Sesión 1: 2+3+2=7 plazas reservadas, disponibles=8
(1, 1, '2025-06-02 10:00:00', 15, 8,  'completada'),
-- Sesión 2: sin reservas, sesión cancelada, disponibles=15
(1, 1, '2025-06-09 10:00:00', 15, 15, 'cancelada' ),
-- Sesión 3: programada, sin reservas aún
(1, 5, '2025-06-16 10:00:00', 15, 15, 'programada'),
-- Sesión 4: programada, sin reservas aún
(1, 1, '2025-06-23 10:00:00', 15, 15, 'programada'),




-- Barrio Gótico (id_tour=2): 2 sesiones
-- Sesión 5: 2+4=6 plazas reservadas, disponibles=6
(2, 5, '2025-06-03 17:00:00', 12, 6,  'completada'),
-- Sesión 6: 2 plazas reservadas (confirmada), disponibles=10
(2, 5, '2025-06-10 17:00:00', 12, 10, 'programada'),




-- Experiencia flamenca (id_tour=3): 2 sesiones
-- Sesión 7: 2+3=5 plazas reservadas, disponibles=15
(3, 4, '2025-06-06 21:00:00', 20, 15, 'completada'),
-- Sesión 8: programada, sin reservas aún
(3, 4, '2025-06-13 21:00:00', 20, 20, 'programada'),




-- Excursión Montserrat (id_tour=4): 2 sesiones
-- Sesión 9: 4+2=6 plazas reservadas, disponibles=19
(4, 3, '2025-06-07 08:30:00', 25, 19, 'completada'),
-- Sesión 10: programada, sin reservas aún
(4, 3, '2025-06-14 08:30:00', 25, 25, 'programada'),




-- Mercado de La Boqueria + taller de cocina (id_tour=5): 1 sesión
-- Sesión 11: 2 plazas reservadas, disponibles=8
(5, 2, '2025-06-05 10:00:00', 10, 8,  'completada'),




-- Gràcia y Parque Güell (id_tour=8): 1 sesión
-- Sesión 12: 2 plazas reservadas, disponibles=13
(8, 5, '2025-06-04 18:30:00', 15, 13, 'completada');




-- =============================================================
-- RESERVAS (12 registros)
-- =============================================================
INSERT INTO reservas (id_usuario, id_sesion, num_plazas, precio_total, estado, created_at) VALUES
-- Sesión 1 (Eixample modernista, completada)
(2, 1, 2, 58.00,  'completada', '2025-05-20 10:30:00'),
(3, 1, 3, 87.00,  'completada', '2025-05-21 14:00:00'),
(4, 1, 2, 58.00,  'completada', '2025-05-22 09:15:00'),




-- Sesión 5 (Gótico, completada)
(5, 5, 2, 44.00,  'completada', '2025-05-25 11:00:00'),
(6, 5, 4, 88.00,  'completada', '2025-05-26 16:30:00'),
