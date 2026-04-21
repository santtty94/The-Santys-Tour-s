# Mejoras y Evolución del Hardware
## The Santy's Tours — FHW

---

## 1. Situación actual

La infraestructura hardware actual está dimensionada para un equipo de 2-3 personas trabajando desde la oficina de Barcelona, con toda la infraestructura de servidor en la nube (AWS). Es una configuración eficiente y de bajo coste de mantenimiento para la fase de arranque de la empresa.

**Inversión hardware actual estimada:**

| Categoría | Coste estimado |
|-----------|----------------|
| 2x Lenovo Legion 5 (desarrollo) | 2.800 EUR |
| 1x Portátil administración (gama media) | 700 EUR |
| 3x Smartphones de trabajo | 1.800 EUR |
| Router ASUS RT-AX88U | 250 EUR |
| Impresora Brother MFC-L3770CDW | 350 EUR |
| **TOTAL hardware** | **5.900 EUR** |

---

## 2. Diferencias entre configuraciones actuales

La infraestructura actual contempla dos niveles de equipamiento claramente diferenciados:

| Criterio | Equipos de desarrollo (x2) | Equipo de administración (x1) |
|----------|---------------------------|-------------------------------|
| Rendimiento | Alto (Core i9, 32 GB RAM) | Medio (Core i5, 16 GB RAM) |
| Uso del equipo | Intensivo y continuo | Moderado |
| GPU | Dedicada RTX 3060 | Integrada |
| Coste | ~1.400 EUR c/u | ~700 EUR |
| Justificación | Desarrollo software exigente | Tareas ofimáticas y gestión |

Esta diferenciación es una decisión racional: no tiene sentido gastar en hardware de alto rendimiento para tareas que no lo requieren. Se invierte donde el rendimiento impacta directamente en la productividad.

---

## 3. Posibles mejoras a corto plazo (0-12 meses)

A medida que la empresa crezca y el flujo de caja lo permita, se proponen las siguientes mejoras:

| Mejora | Coste estimado | Justificación |
|--------|----------------|---------------|
| Monitor externo 27" 4K para cada desarrollador (x2) | 300-500 EUR c/u | Aumenta productividad al disponer de más espacio de pantalla para código, terminal y navegador simultáneamente |
| Switch de red gestionable 8 puertos | 100-150 EUR | Permite segmentar la red de oficina por VLANs: desarrollo, administración e invitados |
| SAI (Sistema de Alimentación Ininterrumpida) | 150-200 EUR | Protege los equipos ante cortes de luz que podrían corromper datos o interrumpir despliegues en curso |
| Disco SSD externo 2 TB para backups locales | 80-120 EUR | Complementa los backups de AWS con una copia local para recuperación rápida sin depender de internet |
| Webcam profesional para videollamadas | 80-150 EUR | Mejora la calidad de reuniones con clientes y proveedores |

---

## 4. Evolución a medio plazo (1-3 años)

Si la empresa consolida su crecimiento y amplía el equipo, la infraestructura evolucionaría de la siguiente manera:

### Escenario: equipo de 5-10 personas

| Necesidad | Hardware adicional | Coste estimado |
|-----------|-------------------|----------------|
| Nuevos desarrolladores | 2-5 portátiles gama alta | 1.400 EUR c/u |
| Red de oficina ampliada | Switch gestionable 16 puertos | 300-500 EUR |
| Almacenamiento compartido interno | NAS Synology DS923+ con 4x HDD 4TB | 800-1.200 EUR |
| Sala de reuniones | Pantalla 65", sistema videoconferencia | 1.500-2.500 EUR |
| Conectividad redundante | Segunda línea de fibra de backup | ~30 EUR/mes |

### Escenario: equipo de diseño o marketing

Si se incorpora un equipo de diseño gráfico o marketing visual para el portal y las redes sociales:

| Necesidad | Hardware recomendado |
|-----------|---------------------|
| Edición de vídeo e imagen | Apple Mac Studio M2 / PC con GPU RTX 4070 |
| Pantalla de color calibrado | Monitor 4K con cobertura DCI-P3 |
| Tableta gráfica | Wacom Intuos Pro M |

---

## 5. Ventaja estratégica del modelo cloud-first

La decisión más importante de esta infraestructura no es el hardware de los portátiles, sino la elección de no tener servidor físico propio. Esta decisión tiene un impacto directo en cómo evoluciona la empresa:

| Aspecto | Con servidor físico | Con AWS (modelo actual) |
|---------|--------------------|-----------------------|
| Coste inicial | 2.000-5.000 EUR en hardware | 0 EUR en hardware de servidor |
| Escalabilidad | Requiere comprar nuevo hardware | Escala en minutos sin hardware |
| Mantenimiento | Requiere técnico propio o externo | Gestionado por AWS |
| Disponibilidad en temporada alta | Limitada por el hardware existente | Escala automáticamente |
| Backups | Requiere configuración manual | Automáticos con AWS |
| Coste mensual | Fijo (amortización hardware) | Variable según uso real |

En temporada alta de turismo (verano en Barcelona), la app y el portal web pueden recibir 10 veces más tráfico que en invierno. Con AWS, los recursos se ajustan automáticamente sin necesidad de intervención ni inversión en hardware adicional.

---

## 6. Reflexión final

La infraestructura hardware actual de The Santy's Tours representa un equilibrio entre rendimiento, coste y escalabilidad adecuado para una empresa en fase de arranque. Las decisiones tomadas (Legion 5 para desarrollo, gama media para administración, nube para servidores) están justificadas técnica y económicamente.

El margen de mejora existe y está planificado, pero se ejecutará de forma progresiva conforme la empresa genere ingresos y el equipo crezca, evitando inversiones innecesarias en fases tempranas.
