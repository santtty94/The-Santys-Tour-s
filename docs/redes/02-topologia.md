# 🗺️ Diseño de Topología de Red

**Módulo:** PAR — Planificación y Administración de Redes
**Proyecto:** The Santy's Tours — Proyecto Intermodular ASIR 2025/2026

---

## 1. Tipo de topología

La red de The Santy's Tours utiliza una **topología en estrella** con un router central como nodo principal, al que se conectan directamente todos los dispositivos por cable Ethernet o de forma inalámbrica a través del Access Point.

Esta topología se ha elegido porque:

- Es la más habitual en redes de oficina pequeñas
- Facilita el diagnóstico de fallos: un dispositivo caído no afecta al resto
- Permite añadir nuevos dispositivos sin interrumpir la red
- El router centraliza el control de acceso a internet y la asignación de IPs

---

## 2. Diagrama de topología de red

```
                    INTERNET (Fibra 600 Mbps simétricos)
                                    │
                      ┌─────────────▼─────────────┐
                      │     ROUTER / MÓDEM FIBRA   │
                      │     192.168.10.1 (GW)      │
                      │     DHCP + NAT + Firewall  │
                      └──────┬───────────┬─────────┘
                             │           │
                  Ethernet   │           │ Ethernet (uplink AP)
             ┌───────────────┤           │
             │               │    ┌──────▼──────────┐
  ┌──────────▼─────────┐     │    │  ACCESS POINT   │
  │ Portátil Dev Web   │     │    │  192.168.10.5   │
  │ 192.168.10.20      │     │    │  Wi-Fi 6        │
  │ Lenovo Legion 5    │     │    └──────┬──────────┘
  └────────────────────┘     │           │ Wi-Fi 6
                             │    ┌──────┴──────────────────────┐
  ┌──────────▼─────────┐     │    │                             │
  │ Portátil Dev       │     │  ┌─▼──────────────┐  ┌──────────▼─────────┐
  │ App/BBDD           │     │  │ Portátil Admin │  │  Smartphones x3    │
  │ 192.168.10.21      │     │  │ 192.168.10.30  │  │  DHCP .100–.102    │
  │ Lenovo Legion 5    │     │  │ Wi-Fi          │  │  Wi-Fi / 5G        │
  └────────────────────┘     │  └────────────────┘  └────────────────────┘
                             │
                   ┌─────────▼──────────┐
                   │  Impresora Wi-Fi   │
                   │  192.168.10.40     │
                   └────────────────────┘

  Nota: la impresora se conecta al AP por Wi-Fi; se muestra
  bajo el router por claridad del diagrama.

═══════════════════════════ INTERNET ═══════════════════════════════

  ┌───────────┐  ┌─────────────┐  ┌──────┐  ┌──────────────────────┐
  │ Route 53  │  │ CloudFront  │  │ ALB  │  │ EC2 t3.micro         │
  │ DNS       │─▶│ CDN         │─▶│      │─▶│ Ubuntu 22.04         │
  └───────────┘  └─────────────┘  └──────┘  │ Node.js API REST     │
                                             └──────────┬───────────┘
                                          ┌─────────────┤
                                 ┌────────▼───────┐  ┌──▼────────────┐
                                 │  RDS MySQL     │  │  Amazon S3    │
                                 │  db.t3.micro   │  │  Imágenes     │
                                 └────────────────┘  └───────────────┘
```

---

## 3. Descripción de la topología

### Red local de oficina

La red local opera en el rango `192.168.10.0/24`. El router actúa como gateway (`192.168.10.1`) y servidor DHCP.

Los **portátiles de desarrollo** (192.168.10.20 y .21) se conectan por **cable Ethernet** directamente al router, garantizando la máxima estabilidad y velocidad para tareas de desarrollo, despliegue y acceso SSH al servidor EC2. Sus IPs son correlativas dentro del bloque de desarrollo (.20–.29).

El **portátil de administración** (192.168.10.30) se conecta por **Wi-Fi** a través del Access Point. Al tratarse de un equipo de uso ofimático (reservas, atención al cliente, facturación), la conectividad inalámbrica es suficiente y aporta flexibilidad de movilidad dentro de la oficina. Su IP está en el bloque de administración (.30–.39), separado del bloque de desarrollo para reflejar la distinción funcional.

Los **smartphones** reciben IP dinámica del pool DHCP y se conectan por Wi-Fi cuando están en la oficina, o por 5G cuando operan en campo.

La **impresora** tiene IP fija (.40) y se conecta al Access Point por Wi-Fi.

El **Access Point** se conecta al router por cable Ethernet en **modo AP puro** — no crea subred adicional, extiende la misma red `192.168.10.0/24`.

### Conexión con la nube (AWS)

Los portátiles de oficina se conectan al servidor EC2 en AWS a través de internet mediante:

- **SSH (puerto 22):** acceso remoto al servidor Ubuntu para administración y despliegue
- **Samba (puerto 445):** compartición de carpetas entre el servidor Ubuntu y los clientes Windows 11 Pro
- **HTTPS (puerto 443):** acceso al portal web y a la API REST

---

## 4. Justificación del diseño

| Decisión | Justificación |
|---|---|
| Topología en estrella | Estándar en redes de oficina pequeñas, fácil de gestionar y diagnosticar |
| Sin servidor físico local | Modelo cloud-first: menor coste inicial, sin mantenimiento de hardware, escalabilidad automática |
| Portátiles de desarrollo por Ethernet | Máxima estabilidad y velocidad para SSH, despliegues y desarrollo |
| Portátil de administración por Wi-Fi | Uso ofimático; la conectividad inalámbrica es suficiente y aporta movilidad |
| IPs .20/.21 para desarrollo, .30 para admin | Separación funcional por bloques de IP para facilitar la administración |
| Access Point separado del router | Mejor cobertura Wi-Fi y posibilidad de segmentar redes en el futuro |

---

*Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
