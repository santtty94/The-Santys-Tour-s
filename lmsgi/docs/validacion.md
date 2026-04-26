# Evidencia de Validación — LMSGI

**Proyecto:** The Santy's Tours  
**Módulo:** Lenguajes de Marcas y Sistemas de Gestión de Información (0373)  
**Herramienta:** lxml (Python) — equivalente a xmllint  
**Fecha:** 2026-04-26

---

## 1. Validación correcta — `catalogo-reservas.xml`

### Comando ejecutado

```python
from lxml import etree

with open('esquema.xsd', 'rb') as f:
    schema_doc = etree.parse(f)
schema = etree.XMLSchema(schema_doc)

with open('catalogo-reservas.xml', 'rb') as f:
    xml_doc = etree.parse(f)

schema.validate(xml_doc)  # → True
```

### Resultado

```
VALIDACION CORRECTA: El XML cumple el esquema XSD
```

✅ El archivo `catalogo-reservas.xml` **valida correctamente** contra `esquema.xsd`. No se detectaron errores.

---

## 2. Validación fallida — `catalogo-error.xml`

Este archivo contiene **7 errores intencionados** para demostrar que el XSD controla las restricciones de forma real.

### Resultado

```
CORRECTO: El XML de error NO valida. Errores detectados por el XSD:

  [1] Linea 31: Element 'categoria': [facet 'enumeration'] The value 'visita'
      is not an element of the set {'tour', 'experiencia', 'excursion'}.

  [2] Linea 36: Element 'duracion_minutos': [facet 'minInclusive'] The value '20'
      is less than the minimum value allowed ('30').

  [3] Linea 39: Element 'precio_persona': [facet 'minInclusive'] The value '-5.00'
      is less than the minimum value allowed ('0.01').

  [4] Linea 60: Element 'email': [facet 'pattern'] The value
      'james.wilson.email.co.uk' is not accepted by the pattern
      '[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}'.

  [5] Linea 64: Element 'num_plazas': [facet 'minInclusive'] The value '0'
      is less than the minimum value allowed ('1').

  [6] Linea 68: Element 'estado': [facet 'enumeration'] The value 'en_espera'
      is not an element of the set {'pendiente', 'confirmada', 'cancelada', 'completada'}.

  [7] Linea 73: Element 'metodo': [facet 'enumeration'] The value 'bizum'
      is not an element of the set {'efectivo', 'tarjeta'}.
```

### Errores introducidos intencionalmente

| # | Elemento | Error introducido | Restricción XSD que lo detecta |
|---|----------|-------------------|-------------------------------|
| 1 | `<categoria>` | Valor `visita` (no existe) | `enumeration`: tour \| experiencia \| excursion |
| 2 | `<duracion_minutos>` | Valor `20` (demasiado corto) | `minInclusive`: 30 minutos |
| 3 | `<precio_persona>` | Valor `-5.00` (negativo) | `minInclusive`: 0.01 |
| 4 | `<email>` | Sin `@` en la dirección | `pattern`: regex de email |
| 5 | `<num_plazas>` | Valor `0` (no puede ser cero) | `minInclusive`: 1 |
| 6 | `<estado>` reserva | Valor `en_espera` (no existe) | `enumeration`: pendiente \| confirmada \| cancelada \| completada |
| 7 | `<metodo>` pago | Valor `bizum` (no permitido) | `enumeration`: efectivo \| tarjeta |

---

## 3. Conclusión

El XSD no es decorativo: **detecta y rechaza datos incorrectos** con mensajes de error precisos que indican la línea exacta del problema y la restricción que se viola. Esto garantiza la integridad de los datos exportados desde `santys_tours` hacia cualquier sistema externo que consuma el XML.
