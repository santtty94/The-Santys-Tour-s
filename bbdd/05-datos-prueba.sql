-- =============================================================
-- The Santy's Tours — Datos de prueba
-- Módulo: Gestión de Bases de Datos (0372)
-- ASIR 2025/2026
-- =============================================================

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
