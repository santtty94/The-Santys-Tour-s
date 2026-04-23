# 04 — Gestión de Usuarios y Permisos

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

## 1. Planificación de usuarios

The Santy's Tours necesita una estructura de usuarios que refleje los roles internos de la empresa:

| Usuario | Rol en la empresa | Nivel de acceso |
|---------|------------------|-----------------|
| `admin_tours` | Administrador de sistemas | Acceso total + sudo |
| `empleado` | Empleado de oficina | Lectura/escritura en carpetas de trabajo |
| `guia` | Guía turístico | Solo lectura en rutas y documentos de tours |
| `readonly` | Consultas externas / auditoría | Solo lectura general |

> Los equipos cliente con **Windows 11 Pro** acceden al servidor mediante Samba con las credenciales de cada usuario.

---

## 2. Estructura de grupos

```
tours_admin     → administradores del sistema
tours_staff     → empleados con acceso de escritura
tours_guias     → guías con acceso de lectura en rutas
tours_readonly  → acceso de solo lectura general
```

---

## 3. Creación de grupos

```bash
sudo groupadd tours_admin
sudo groupadd tours_staff
sudo groupadd tours_guias
sudo groupadd tours_readonly
```

Verificar:

```bash
getent group | grep tours
```

---

## 4. Creación de usuarios

### 4.1 Usuario: `admin_tours` (creado durante la instalación)

Añadir a los grupos necesarios:

```bash
sudo usermod -aG sudo admin_tours
sudo usermod -aG tours_admin admin_tours
```

### 4.2 Usuario: `empleado`

```bash
sudo adduser empleado
sudo usermod -aG tours_staff empleado
```

### 4.3 Usuario: `guia`

```bash
sudo adduser guia
sudo usermod -aG tours_guias guia
```

### 4.4 Usuario: `readonly`

```bash
sudo adduser readonly
sudo usermod -aG tours_readonly readonly
```

---

## 5. Estructura de directorios

```bash
sudo mkdir -p /srv/santysTours/{admin,tours,rutas,documentos,publico}
```

Estructura creada:

```
/srv/santysTours/
├── admin/          → Solo accesible por admin_tours
├── tours/          → Lectura/escritura para empleados; lectura para guías
├── rutas/          → Solo lectura para guías y empleados
├── documentos/     → Lectura/escritura para empleados
└── publico/        → Lectura para todos los usuarios
```

---

## 6. Asignación de propietarios y permisos

### 6.1 Carpeta `admin/` — Solo administradores

```bash
sudo chown admin_tours:tours_admin /srv/santysTours/admin
sudo chmod 770 /srv/santysTours/admin
```

### 6.2 Carpeta `tours/` — Empleados r/w, guías r/x

```bash
sudo apt install acl -y
sudo chown admin_tours:tours_staff /srv/santysTours/tours
sudo chmod 775 /srv/santysTours/tours
sudo setfacl -m g:tours_guias:r-x /srv/santysTours/tours
```

### 6.3 Carpeta `rutas/` — Solo lectura para guías y empleados

```bash
sudo chown admin_tours:tours_guias /srv/santysTours/rutas
sudo chmod 750 /srv/santysTours/rutas
sudo setfacl -m g:tours_staff:r-x /srv/santysTours/rutas
```

### 6.4 Carpeta `documentos/` — Empleados lectura/escritura

```bash
sudo chown admin_tours:tours_staff /srv/santysTours/documentos
sudo chmod 770 /srv/santysTours/documentos
```

### 6.5 Carpeta `publico/` — Todos pueden leer

```bash
sudo chown admin_tours:tours_readonly /srv/santysTours/publico
sudo chmod 755 /srv/santysTours/publico
```

---

## 7. Verificación de permisos

```bash
ls -la /srv/santysTours/
```

Resultado esperado:

```
drwxrwx---  admin_tours  tours_admin    admin/
drwxrwxr-x  admin_tours  tours_staff    tours/
drwxr-x---  admin_tours  tours_guias    rutas/
drwxrwx---  admin_tours  tours_staff    documentos/
drwxr-xr-x  admin_tours  tours_readonly publico/
```

Verificar ACL aplicadas:

```bash
getfacl /srv/santysTours/tours
getfacl /srv/santysTours/rutas
```

---

## 8. Verificación de membresía de grupos

```bash
groups admin_tours
groups empleado
groups guia
groups readonly
```

Resultados esperados:

```
admin_tours : admin_tours sudo tours_admin
empleado    : empleado tours_staff
guia        : guia tours_guias
readonly    : readonly tours_readonly
```

---

## 9. Política de contraseñas

### 9.1 Instalar herramienta de políticas

```bash
sudo apt install libpam-pwquality -y
```

### 9.2 Configurar política mínima

```bash
sudo nano /etc/security/pwquality.conf
```

Parámetros a establecer:

```ini
# Longitud mínima
minlen = 12
# Requerir mayúscula
ucredit = -1
# Requerir minúscula
lcredit = -1
# Requerir número
dcredit = -1
# Requerir carácter especial
ocredit = -1
```

### 9.3 Expiración de contraseñas

```bash
sudo chage -M 90 empleado
sudo chage -M 90 guia
sudo chage -M 90 readonly
sudo chage -M 180 admin_tours
04_gestion_usuarios_permisos.md
---

## 10. Resumen de permisos por usuario

| Usuario | `admin/` | `tours/` | `rutas/` | `documentos/` | `publico/` |
|---------|---------|---------|---------|--------------|----------|
| `admin_tours` | rwx | rwx | rwx | rwx | rwx |
| `empleado` | ❌ | rwx | r-x | rwx | r-x |
| `guia` | ❌ | r-x | r-x | ❌ | r-x |
| `readonly` | ❌ | ❌ | ❌ | ❌ | r-x |

> Los usuarios acceden a estas carpetas tanto desde la terminal del servidor como mediante **unidades de red Samba** desde sus equipos **Windows 11 Pro**.

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
