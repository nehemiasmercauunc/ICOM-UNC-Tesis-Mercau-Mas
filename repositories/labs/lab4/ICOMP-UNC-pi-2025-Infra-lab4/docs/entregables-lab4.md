# Entregables – Lab 4: Clúster EKS y monitoreo con Grafana y Prometheus

**Proyecto Integrador** – Desarrollo de Laboratorios y Prácticas Iterativas e Incrementales en un Cloud Provider (Alianza AWS-UNC).

Este documento define de forma explícita **qué debe entregar el alumno** para aprobar el Lab 4. Los entregables están alineados con la propuesta del PI (Solicitud de Proyecto Integrador) y con las consignas detalladas en la **Guía y consignas del Lab 4**.

---

## Marco del Lab 4 según la propuesta del PI

Según la Solicitud de Proyecto Integrador (`repositories/Solicitud-tema-PI.docx.md`):

> *"Laboratorio 4 – Creación de un clúster EKS y monitoreo con Grafana y Prometheus. Se desplegará un clúster de EKS (Elastic Kubernetes Service) usando Terraform, integrando charts de Helm al IaC para desplegar recursos de Kubernetes."*

El alumno debe demostrar que es capaz de:

1. **Aprovisionar un clúster EKS** (y su red/registro asociados) mediante **Terraform** y **Terragrunt**, con estado remoto y entornos separados.
2. **Integrar Helm en IaC** usando el provider de Terraform para instalar el stack de observabilidad en el clúster.
3. Desplegar **Prometheus** y **Grafana** (chart `kube-prometheus-stack`) con configuración acorde a un entorno de laboratorio.
4. **Validar** el despliegue con `kubectl` y acceso a la UI de Grafana.
5. **Documentar** decisiones, orden de despliegue y evidencia de ejecución.

La implementación de referencia de este PI reutiliza la base del Lab 3 (VPC, ECR, EKS) y agrega el módulo `monitoring` en entornos `dev` y `prd`.

---

## Estructura obligatoria del repositorio

| Requisito | Descripción |
|-----------|-------------|
| **Carpeta `modules/`** | Módulos Terraform reutilizables: `vpc`, `ecr`, `eks`, **`monitoring`** (con `values/` para Helm). |
| **Carpeta `live/`** | Configuración por entorno y región: `live/dev/...` y `live/prd/...` con Terragrunt. |
| **`root.hcl` / backend** | Estado remoto en S3 con prefijo de key `lab4/` (o equivalente acordado), cifrado y bloqueo documentado. |
| **Unidad `monitoring/`** | Terragrunt que genera el provider Helm autenticado contra EKS. |
| **README operativo** | Prerrequisitos, bootstrap, orden de apply (incluye monitoring en segunda fase), validación Grafana. |
| **Sin secretos en Git** | No commitear access keys ni contraseñas de producción; las contraseñas de Grafana en laboratorio deben documentarse como excepción pedagógica o externalizarse si el repo es público. |

---

## Listado de entregables obligatorios

| # | Entregable | Descripción | Formato | Relación con consignas |
|---|------------|-------------|---------|------------------------|
| **1** | **Repositorio IaC** | Código Terraform/Terragrunt con `modules/` (4 módulos) y `live/` en `dev` y `prd`. | Repositorio Git | C1, C2–C5 |
| **2** | **README técnico** | Credenciales, bootstrap S3, orden vpc → ecr → eks → **monitoring**, import ECR si aplica, `update-kubeconfig`, port-forward Grafana. | `README.md` en la raíz del repo | C5, C7, C8 |
| **3** | **Informe final** | Tecnologías, pasos realizados, decisiones, marco teórico (EKS, observabilidad, Helm), diagramas. | `docs/informe-final-lab4.md` o PDF según indicación del docente | C8 |
| **4** | **Evidencia de ejecución** | Plans/applies sin errores; consola AWS (VPC, ECR, EKS); `kubectl get nodes`; pods en `monitoring`; captura de login Grafana. | Capturas en informe o anexo | C2–C7, C8 |
| **5** | **Diagramas** | Arquitectura, jerarquía Terragrunt, secuencia de despliegue, red VPC/EKS, stack de observabilidad. | `docs/diagramas/*.mmd` y/o figuras embebidas en el informe | C8 |

---

## Criterios de aceptación mínimos

Para considerar el Lab 4 **aprobado**, debe cumplirse lo siguiente:

| Criterio | Verificación |
|----------|--------------|
| **Estado remoto** | El state persiste en S3 con keys bajo `lab4/` (o convención acordada); cada unidad tiene su state separado. |
| **Plan antes de apply** | Evidencia de `plan` revisado antes de `apply` en unidades principales (vpc, ecr, eks, monitoring). |
| **EKS operativo** | Clúster accesible con `aws eks update-kubeconfig`; nodos en estado Ready. |
| **Stack de monitoreo** | Namespace `monitoring` (o el definido) con pods del chart en estado Running tras el apply. |
| **Grafana accesible** | Acceso vía `kubectl port-forward` (o Ingress si se implementó) con credenciales documentadas. |
| **Helm en IaC** | El chart se instala mediante `helm_release` en Terraform, no solo con `helm install` manual sin código. |
| **Orden de despliegue** | Documentado que `monitoring` se aplica **después** de que EKS exista. |
| **Sin credenciales AWS en repo** | No hay access keys en el historial del entregable. |

---

## Resumen por consigna (referencia cruzada)

- **C1 (Estructura repo)** → entregables **1**, **5**.
- **C2 (VPC)** → entregables **1**, **4**.
- **C3 (ECR)** → entregables **1**, **2**, **4**.
- **C4 (EKS)** → entregables **1**, **2**, **4**.
- **C5 (Terragrunt / backend)** → entregables **1**, **2**.
- **C6 (Módulo monitoring)** → entregables **1**, **4**, **5**.
- **C7 (Provider Helm / EKS)** → entregables **1**, **2**, **4**.
- **C8 (dev/prd y documentación)** → entregables **2**, **3**, **4**, **5**.

---

## Notas para el docente

- **Plazos y formato**: El docente puede fijar plazos y si el informe se entrega en PDF o solo Markdown en el repo.
- **Costos AWS**: VPC, NAT Gateway, EKS y nodos generan costo; recomendar `destroy` al finalizar la cursada o usar cuentas de práctica AWS-UNC.
- **Apply en dos fases**: `terragrunt run --all apply` puede intentar `monitoring` antes de que EKS esté listo; la implementación de referencia aplica primero vpc/ecr/eks y luego la unidad `monitoring` (ver README).
- **Variante mínima**: Alumno que ya tiene EKS del Lab 3 puede entregar solo el módulo `monitoring` + Terragrunt, documentando la dependencia con el clúster existente.
- **Variante completa (repo de referencia)**: Terragrunt, `dev` + `prd`, VPC + ECR + EKS + kube-prometheus-stack, prefijo `lab4/` en state keys.
- **Evaluación**: Cada consigna C1–C8 puede evaluarse de forma independiente; este documento unifica qué entregar para homogeneizar la corrección.

---

*Documento basado en la Solicitud de Proyecto Integrador (PI) y en la Guía y consignas del Lab 4. Para el detalle de cada consigna, consultar [guia-y-consignas-lab4.md](guia-y-consignas-lab4.md).*
