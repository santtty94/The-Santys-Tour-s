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
                      └──────────────┬─────────────┘
                                     │
             ┌───────────────────────┼───────────────────────┐
             │ Ethernet              │ Ethernet               │ Ethernet
   ┌─────────▼──────────┐  ┌────────▼────────┐  ┌───────────▼────────┐
   │ Portátil Dev Web   │  │  ACCESS POINT   │  │ Portátil Admin     │
   │ 192.168.10.20      │  │  192.168.10.5   │  │ 192.168.10.30      │
   │ Lenovo Legion 5    │  │  Wi-Fi 6        │  │ Gama media i5      │
   └────────────────────┘  └────────┬────────┘  └────────────────────┘
                                    │ Wi-Fi 6
              ┌─────────────────────┼─────────────────────┐
              │                     │                     │
   ┌──────────▼─────────┐  ┌────────▼───────────┐  ┌─────▼──────────────┐
   │ Portátil Dev       │  │  Smartphones x3    │  │  Impresora Wi-Fi   │
   │ App/BBDD           │  │  192.168.10.100+   │  │  192.168.10.40     │
   │ 192.168.10.21      │  │  DHCP dinámico     │  │                    │
   └────────────────────┘  └────────────────────┘  └────────────────────┘

═══════════════════════════ INTERNET ═══════════════════════════════

          ┌───────────┐  ┌─────────────┐  ┌──────┐  ┌──────────────────┐
          │ Route 53  │  │ CloudFront  │  │ ALB  │  │ EC2 t3.micro     │
          │ DNS       │─▶│ CDN         │─▶│      │─▶│ Ubuntu 22.04     │
          └───────────┘  └─────────────┘  └──────┘  │ Node.js API REST │
                                                     └────────┬─────────┘
                                              ┌───────────────┤
                                     ┌────────▼───────┐  ┌────▼──────────┐
                                     │  RDS MySQL     │  │  Amazon S3    │
                                     │  db.t3.micro   │  │  Imágenes     │
                                     └────────────────┘  └───────────────┘
```

---

## 3. Descripción de la topología

### Red local de oficina

La red local opera en el rango `192.168.10.0/24`. El router actúa como gateway (`192.168.10.1`) y servidor DHCP para los dispositivos con asignación dinámica.

Los portátiles tienen IPs estáticas asignadas por reserva DHCP (basada en MAC) para facilitar la administración. El Access Point se conecta al router por cable Ethernet en **modo AP puro** — no crea subred adicional, extiende la misma red.

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
| Access Point separado del router | Mejor cobertura Wi-Fi y posibilidad de segmentar redes en el futuro |
| IPs estáticas para portátiles | Facilita la configuración de reglas de acceso y el diagnóstico de red |
| IPs dinámicas para smartphones e impresora | Dispositivos con acceso esporádico que no requieren IP fija |

---

*Proyecto Intermodular ASIR 2025/2026 — The Santy's Tours*
