# 07 — Administración básica de la base de datos

## The Santy's Tours — Gestión de Bases de Datos

---

## 1. Copias de seguridad con `mysqldump`

Las copias de seguridad permiten recuperar los datos ante cualquier fallo del sistema, error humano o pérdida de datos. En un entorno de producción como el de The Santy's Tours, donde los datos de clientes y reservas son críticos, es imprescindible tener una política de backups.

### 1.1 Backup completo de la base de datos

```bash
mysqldump -u root -p santys_tours > backup_santys_tours_$(date +%Y%m%d).sql
```

Este comando genera un archivo `.sql` con toda la estructura y los datos de la base de datos. El nombre incluye la fecha automáticamente para facilitar la organización.

### 1.2 Backup solo de la estructura (sin datos)

```bash
mysqldump -u root -p --no-data santys_tours > estructura_santys_tours.sql
```

Útil para replicar la base de datos en otro entorno (desarrollo, pruebas) sin incluir datos reales de clientes.

### 1.3 Backup de una tabla concreta

```bash
mysqldump -u root -p santys_tours reservas > backup_reservas_$(date +%Y%m%d).sql
```

### 1.4 Restaurar un backup

```bash
mysql -u root -p santys_tours < backup_santys_tours_20250601.sql
```

### 1.5 Automatización del backup (Linux/cron)

Para ejecutar el backup automáticamente cada día a las 3:00 AM, se añade la siguiente línea al crontab del servidor:

```bash
# Editar crontab
crontab -e

# Línea a añadir (backup diario a las 3:00 AM)
0 3 * * * mysqldump -u root -pCONTRASEÑA santys_tours > /backups/santys_tours_$(date +\%Y\%m\%d).sql
```

---

## 2. Exportación de datos

### 2.1 Exportar a CSV (desde MySQL)

```sql
SELECT * FROM reservas
INTO OUTFILE '/tmp/reservas_export.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

### 2.2 Exportar con mysqldump en formato CSV (alternativa)

```bash
mysql -u root -p -e "SELECT * FROM santys_tours.reservas" > reservas.tsv
```

---

## 3. Gestión de usuarios MySQL

En un entorno real, nunca se usa el usuario `root` para las conexiones de la aplicación. Se crean usuarios con permisos mínimos necesarios.

### 3.1 Crear usuario para la aplicación web (solo lectura/escritura)

```sql
-- Usuario para la aplicación (operaciones normales)
CREATE USER 'app_santys'@'localhost' IDENTIFIED BY 'password_segura_app';

GRANT SELECT, INSERT, UPDATE ON santys_tours.* TO 'app_santys'@'localhost';

FLUSH PRIVILEGES;
```

### 3.2 Crear usuario de solo lectura (para informes y consultas)

```sql
-- Usuario para consultas e informes (sin modificar datos)
CREATE USER 'reports_santys'@'localhost' IDENTIFIED BY 'password_segura_reports';

GRANT SELECT ON santys_tours.* TO 'reports_santys'@'localhost';

FLUSH PRIVILEGES;
```

### 3.3 Crear usuario administrador de backup

```sql
-- Usuario para realizar backups automáticos
CREATE USER 'backup_santys'@'localhost' IDENTIFIED BY 'password_segura_backup';

GRANT SELECT, LOCK TABLES, SHOW VIEW, EVENT, TRIGGER ON santys_tours.* TO 'backup_santys'@'localhost';

FLUSH PRIVILEGES;
```

### 3.4 Consultar usuarios existentes

```sql
SELECT User, Host FROM mysql.user;
```

### 3.5 Ver permisos de un usuario

```sql
SHOW GRANTS FOR 'app_santys'@'localhost';
```

### 3.6 Revocar permisos

```sql
REVOKE INSERT, UPDATE ON santys_tours.* FROM 'app_santys'@'localhost';
```

### 3.7 Eliminar un usuario

```sql
DROP USER 'app_santys'@'localhost';
FLUSH PRIVILEGES;
```

---

## 4. Verificación de la integridad de la base de datos

```sql
-- Comprobar el estado de las tablas
CHECK TABLE usuarios, guias, tours, sesiones_tour, reservas, pagos, valoraciones;

-- Reparar una tabla si está dañada (solo MyISAM, no necesario en InnoDB)
-- REPAIR TABLE nombre_tabla;
```

---

## 5. Ver el tamaño de la base de datos

```sql
SELECT
    table_name                          AS tabla,
    ROUND(data_length / 1024, 2)       AS datos_KB,
    ROUND(index_length / 1024, 2)      AS indices_KB,
    ROUND((data_length + index_length) / 1024, 2) AS total_KB
FROM information_schema.tables
WHERE table_schema = 'santys_tours'
ORDER BY (data_length + index_length) DESC;
```

---

## 6. Resumen de buenas prácticas aplicadas

| Práctica | Implementación |
|---|---|
| Backups diarios automatizados | `cron` + `mysqldump` |
| Usuarios con mínimos privilegios | Usuarios `app_`, `reports_`, `backup_` separados |
| Motor InnoDB | Soporte de transacciones y claves foráneas |
| Restricciones de integridad | `FOREIGN KEY`, `CHECK`, `UNIQUE` en todas las tablas |
| Índices en columnas clave | Búsquedas por fecha, usuario y estado optimizadas |
| Codificación UTF-8 | `utf8mb4` para soporte completo de caracteres internacionales |
