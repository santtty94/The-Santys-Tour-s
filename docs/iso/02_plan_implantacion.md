# 02 — Plan de Implantación


**Módulo ISO — The Santy's Tours**
**Proyecto Intermodular ASIR 2025/2026**


---


## 1. Arquitectura de implantación


The Santy's Tours utiliza una infraestructura mixta que separa claramente el rol del servidor y de los clientes:


| Componente | Plataforma | Sistema Operativo | Justificación |
|-----------|-----------|------------------|---------------|
| Servidor de producción | AWS Academy (EC2 t3.micro) | Ubuntu Server 22.04 LTS | Infraestructura cloud del proyecto (coherente con módulo MPO) |
| Equipos de administración | VirtualBox 7.x (Lenovo Legion 5) | Windows 11 Pro | Entorno de cliente simulado para demostrar configuración e integración |


> **Nota:** El servidor no se instala manualmente. AWS lanza una instancia EC2 con Ubuntu Server 22.04 LTS preconfigurado. El proceso de implantación consiste en el lanzamiento, configuración y puesta en marcha de dicha instancia.
