# 04 — Gestión de Usuarios y Permisos

**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**

---

> **Nota sobre las evidencias:** Los procedimientos descritos corresponden al entorno de producción real. Las capturas aportadas fueron tomadas en un entorno de laboratorio (AWS Academy + VirtualBox) como evidencia práctica del proyecto intermodular ASIR.

---

## 1. Alcance de este documento

La gestión de usuarios se aplica en los dos sistemas con sistema operativo administrado directamente:

| Sistema | Plataforma | Acceso para ejecutar comandos |
|---------|-----------|-------------------------------|
| Servidor Ubuntu Server 22.04 LTS | AWS EC2 | PuTTY desde equipos Windows 11 Pro de la oficina |
| Equipos cliente Windows 11 Pro | Equipos físicos de oficina | Directamente en el equipo |

---

## 2. PARTE A — Usuarios y permisos en el servidor Ubuntu (AWS EC2)

> Conectarse primero al servidor mediante PuTTY con la clave privada descargada de AWS.

### 2.1 Planificación de usuarios

| Usuario | Rol | Nivel de acceso |
|---------|-----|-----------------|
| `ubuntu` | Usuario por defecto de AWS | sudo completo — creado automáticamente por AWS |
| `admin_tours` | Administrador de sistemas del proyecto | sudo completo |
| `empleado` | Empleado de oficina | Lectura/escritura en carpetas de trabajo |
| `guia` | Guía turístico | Solo lectura en rutas y documentos |
| `readonly` | Consultas externas / auditoría | Solo lectura general |

### 2.2 Creación de grupos

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

### 2.3 Creación de usuarios

```bash
sudo adduser admin_tours
sudo adduser empleado
sudo adduser guia
sudo adduser readonly
```

Asignar grupos:
```bash
sudo usermod -aG sudo admin_tours
sudo usermod -aG tours_admin admin_tours
sudo usermod -aG tours_staff empleado
sudo usermod -aG tours_guias guia
sudo usermod -aG tours_readonly readonly
```

> **Nota:** El usuario `ubuntu` es el usuario por defecto de AWS con acceso `sudo` completo. No es necesario crearlo.

Verificar grupos asignados:
```bash
groups empleado && groups guia
```

![groups empleado y groups guia mostrando tours_staff y tours_guias](capturas/Captura%20de%20pantalla%2014.png)
*Captura 14 — Verificación de grupos: empleado pertenece a tours_staff, guia pertenece a tours_guias*

### 2.4 Estructura de directorios del servidor

```bash
sudo mkdir -p /srv/santysTours/{admin,tours,rutas,documentos,publico}
```

```
/srv/santysTours/
├── admin/          → Solo ubuntu y admin_tours
├── tours/          → Empleados r/w, Guías r/x
├── rutas/          → Guías y Empleados solo lectura
├── documentos/     → Empleados lectura/escritura (share Samba)
└── publico/        → Todos los usuarios (solo lectura, share Samba)
```

### 2.5 Asignación de permisos

```bash
# admin/ — solo administradores
sudo chown ubuntu:tours_admin /srv/santysTours/admin
sudo chmod 770 /srv/santysTours/admin

# tours/ — empleados r/w, guías r/x (ACL)
sudo apt install acl -y
sudo chown ubuntu:tours_staff /srv/santysTours/tours
sudo chmod 775 /srv/santysTours/tours
sudo setfacl -m g:tours_guias:r-x /srv/santysTours/tours

# rutas/ — solo lectura para guías y empleados
sudo chown ubuntu:tours_guias /srv/santysTours/rutas
sudo chmod 750 /srv/santysTours/rutas
sudo setfacl -m g:tours_staff:r-x /srv/santysTours/rutas

# documentos/ — empleados lectura/escritura
sudo chown ubuntu:tours_staff /srv/santysTours/documentos
sudo chmod 770 /srv/santysTours/documentos

# publico/ — todos pueden leer
sudo chown ubuntu:tours_readonly /srv/santysTours/publico
sudo chmod 755 /srv/santysTours/publico
```

### 2.6 Verificación de permisos

```bash
ls -la /srv/santysTours/
```

![ls -la /srv/santysTours/ mostrando las 5 carpetas con sus permisos](capturas/Captura%20de%20pantalla%2013.png)
*Captura 13 — Estructura de carpetas /srv/santysTours/ con permisos aplicados*

Verificar ACL:
```bash
getfacl /srv/santysTours/tours
getfacl /srv/santysTours/rutas
```

### 2.7 Política de contraseñas

```bash
sudo apt install libpam-pwquality -y
sudo nano /etc/security/pwquality.conf
```

```ini
minlen = 12
ucredit = -1
lcredit = -1
dcredit = -1
ocredit = -1
```

Expiración de contraseñas:
```bash
sudo chage -M 90 empleado
sudo chage -M 90 guia
sudo chage -M 90 readonly
sudo chage -M 180 admin_tours
```

### 2.8 Resumen de permisos por usuario

| Usuario | `admin/` | `tours/` | `rutas/` | `documentos/` | `publico/` |
|---------|---------|---------|---------|--------------|----------|
| `ubuntu` / `admin_tours` | rwx | rwx | rwx | rwx | rwx |
| `empleado` | ❌ | rwx | r-x | rwx | r-x |
| `guia` | ❌ | r-x | r-x | ❌ | r-x |
| `readonly` | ❌ | ❌ | ❌ | ❌ | r-x |

> Los usuarios acceden a estas carpetas tanto desde PuTTY (terminal) como mediante **unidades de red Samba** desde sus equipos Windows 11 Pro.

---

## 3. PARTE B — Usuarios en los equipos Windows 11 Pro

En cada equipo físico Windows 11 Pro de la oficina se configuran cuentas locales que representan los roles del personal.

### 3.1 Usuarios locales de Windows

| Cuenta Windows | Rol | Tipo de cuenta |
|---------------|-----|----------------|
| `Admin_SantysTours` | Administrador del equipo | Administrador local |
| `Empleado_Oficina` | Empleado de oficina | Usuario estándar |

### 3.2 Crear usuario estándar en Windows 11 Pro

1. Inicio → Configuración → Cuentas → **Otros usuarios**
2. Clic en **Agregar cuenta**
3. Seleccionar **No tengo la información de inicio de sesión de esta persona**
4. Seleccionar **Agregar un usuario sin cuenta Microsoft**
5. Nombre: `Empleado_Oficina` → establecer contraseña → Siguiente
6. El usuario se crea como **Usuario estándar** por defecto

### 3.3 Acceso Samba desde Windows 11 Pro

Las credenciales usadas para acceder a Samba son las del servidor Ubuntu (`empleado`, `guia`, etc.), no las cuentas locales de Windows.

1. Explorador de archivos → barra de dirección → `\\IP_SERVIDOR` o `\\thesantystours.com`
2. Introducir credenciales Samba: usuario `empleado` / contraseña del servidor
3. Aparecen los shares: `documentos`, `rutas`, `publico`
4. Clic derecho en `documentos` → **Conectar a unidad de red** → asignar letra (ej: Z:)

---

*Documento elaborado para el Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
