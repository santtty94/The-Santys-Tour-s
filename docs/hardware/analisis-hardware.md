# Análisis de Necesidades de Hardware
## The Santy's Tours

---

## 1. Descripción del entorno

The Santy's Tours es una agencia de turismo de ocio y aventura con sede física en Barcelona. Opera con un equipo de 2-3 personas que trabajan tanto desde la oficina como en campo durante la ejecución de las experiencias turísticas.

El sistema tecnológico de la empresa se compone de dos capas:

- **Hardware local:** equipos físicos en la oficina para el desarrollo del portal web, la app móvil, la gestión de la base de datos y las tareas administrativas.
- **Infraestructura cloud (AWS):** donde se despliega y opera el portal web, la aplicación móvil y la base de datos en producción. No se requiere ningún servidor físico en la oficina.

---

## 2. Necesidades identificadas

### 2.1 Equipos de desarrollo (alto rendimiento)

La empresa necesita equipos potentes para dos perfiles técnicos:

**Desarrollador web** — responsable del portal de reservas online:
- Ejecutar entornos de desarrollo local (servidores Node.js, React, etc.)
- Gestionar repositorios Git y despliegues a AWS
- Trabajar con múltiples herramientas abiertas simultáneamente (IDE, navegador, terminal, servidor local)

**Desarrollador de app y BBDD** — responsable de la aplicación móvil y la base de datos:
- Ejecutar emuladores de dispositivos móviles (Android/iOS)
- Gestionar bases de datos locales para pruebas
- Conectar con la instancia RDS de AWS para administración

Ambos perfiles requieren equipos de **alto rendimiento** con gran cantidad de RAM y procesador potente.

### 2.2 Equipo de administración (gama media)

Un tercer miembro del equipo gestiona las operaciones diarias no técnicas:
- Gestión del back-office (reservas, clientes, facturación)
- Comunicación con clientes y proveedores
- Coordinación de guías turísticos

Este perfil no requiere alto rendimiento técnico. Un equipo de gama media es suficiente.

### 2.3 Dispositivos móviles (operativa en campo)

Los 3 miembros del equipo necesitan smartphones durante las experiencias turísticas:
- Check-in de reservas en tiempo real
- Comunicación con clientes
- Fotografía y vídeo para redes sociales
- Validación de tickets

### 2.4 Conectividad de oficina

La oficina necesita:
- Conexión a internet de alta velocidad y simétrica para trabajar con AWS
- Red Wi-Fi estable para todos los dispositivos
- Router con capacidades de gestión avanzada

### 2.5 Periféricos

- **Impresora multifunción** para vouchers, tickets, contratos y documentación administrativa

---

## 3. Tabla resumen de equipos necesarios

| Tipo de equipo | Cantidad | Perfil de usuario | Nivel de rendimiento |
|----------------|----------|-------------------|----------------------|
| Portátil desarrollo web | 1 | Desarrollador web | Alto |
| Portátil desarrollo app/BBDD | 1 | Desarrollador app y BBDD | Alto |
| Portátil administración | 1 | Responsable administrativo | Medio |
| Smartphone de trabajo | 3 | Todo el equipo | Estándar |
| Router fibra óptica | 1 | Infraestructura de red | — |
| Impresora multifunción | 1 | Uso compartido de oficina | — |

---

## 4. Justificación de la ausencia de servidor físico

The Santy's Tours no dispone de servidor físico en la oficina por las siguientes razones:

- **Coste:** un servidor físico supone una inversión inicial de 2.000–5.000 € que no es necesaria en fase de arranque.
- **Escalabilidad:** AWS permite ajustar los recursos automáticamente según la demanda (temporada alta/baja de turismo).
- **Mantenimiento:** eliminamos la necesidad de gestionar hardware de servidor, actualizaciones de firmware y posibles fallos físicos.
- **Disponibilidad:** AWS garantiza 99,99% de uptime, imposible de alcanzar con un servidor de oficina.
- **Seguridad:** backups automáticos, cifrado y protección gestionados por AWS.
- **Movilidad:** el equipo puede trabajar y acceder a los sistemas desde cualquier ubicación con internet.
