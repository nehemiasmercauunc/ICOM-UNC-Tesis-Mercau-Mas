# Entregables – Lab 3: Infraestructura como código en la nube con Terraform

**Proyecto Integrador** – Desarrollo de Laboratorios y Prácticas Iterativas e Incrementales en un Cloud Provider (Alianza AWS-UNC).

Este documento define de forma explícita **qué debe entregar el alumno** para aprobar el Lab 3. Los entregables están alineados con la propuesta del PI (Solicitud de Proyecto Integrador) y con las consignas detalladas en la **Guía y consignas del Lab 3**.

---

## Marco del Lab 3 según la propuesta del PI

Según la Solicitud de Proyecto Integrador:

> *"Laboratorio 3 – Infraestructura como código en la nube con Terraform. Se desplegará infraestructura en la nube (por ejemplo, AWS) primero de forma manual y luego usando Terraform, introduciendo conceptos como providers, recursos, variables y manejo del estado remoto."*

El alumno debe demostrar que es capaz de:

1. **Declarar infraestructura en código** (Terraform) y versionarla en Git.
2. Usar **providers**, **recursos**, **variables** y **outputs** de forma coherente.
3. Configurar **estado remoto** (por ejemplo S3) y ejecutar **plan** antes de **apply**.
4. Separar **módulos reutilizables** (`modules/`) de la **configuración por entorno** (`live/` o equivalente).
5. Aprovisionar al menos una **red (VPC)** y un servicio gestionado alineado al TP (**ECR** y/o **EKS**), según el nivel acordado con el docente.
6. Documentar decisiones, orden de despliegue y evidencia de ejecución.

En la implementación de referencia de este PI se utiliza además **Terragrunt** para orquestar varias unidades (VPC, ECR, EKS) en entornos `dev` y `prd`. El docente puede exigir la ruta completa (Terragrunt + tres módulos) o una variante reducida (solo Terraform con un entorno).

---

## Estructura obligatoria del repositorio

| Requisito | Descripción |
|-----------|-------------|
| **Carpeta `modules/`** | Módulos Terraform reutilizables (por ejemplo VPC, ECR, EKS) con `main.tf`, `variables.tf`, `outputs.tf`. |
| **Carpeta `live/` (o raíz por entorno)** | Configuración por entorno y región; en este lab: `live/dev/...` y `live/prd/...` con Terragrunt. |
| **`root.hcl` / backend** | Estado remoto en S3 (u otro backend acordado), cifrado y mecanismo de bloqueo documentado. |
| **README operativo** | Prerrequisitos, bootstrap del backend, orden de apply, import de recursos existentes si aplica. |
| **Sin secretos en Git** | No commitear access keys, kubeconfig con credenciales embebidas ni `account.hcl` con datos reales de producción si el repo es público (usar placeholders y documentar). |

---

## Listado de entregables obligatorios

| # | Entregable | Descripción | Formato | Relación con consignas |
|---|------------|-------------|---------|------------------------|
| **1** | **Repositorio IaC** | Código Terraform/Terragrunt con `modules/` y `live/` (o estructura equivalente acordada). Accesible para el corrector. | Repositorio Git | C1, C5 |
| **2** | **README técnico** | Cómo configurar credenciales, bootstrap del backend, `init`/`plan`/`apply`, orden vpc → ecr → eks, import ECR si aplica, notas de `kubectl`. | `README.md` en la raíz del repo | C5, C7 |
| **3** | **Informe final** | Tecnologías, pasos realizados, decisiones de diseño, marco teórico (IaC, estado, VPC, EKS, ECR), diagramas o referencias a ellos. | `docs/informe-final-lab3.md` o PDF según indicación del docente | C7 |
| **4** | **Evidencia de ejecución** | Salida de `terragrunt plan` / `apply` (o `terraform plan` / `apply`) sin errores; capturas o enlaces a recursos en consola AWS (VPC, ECR, EKS); opcional: `kubectl get nodes` si se desplegó EKS. | Capturas, logs o enlaces en el informe o anexo | C2–C4, C7 |

---

## Criterios de aceptación mínimos

Para considerar el Lab 3 **aprobado**, debe cumplirse lo siguiente:

| Criterio | Verificación |
|----------|--------------|
| **Estado remoto** | El state persiste en S3 (o backend acordado); cada unidad tiene su key; no se usa solo `terraform.tfstate` local en equipo del alumno como única fuente de verdad. |
| **Plan antes de apply** | Existe evidencia de al menos un `plan` revisado antes del `apply` en cada unidad principal (VPC, ECR, EKS). |
| **VPC con 2 AZ** | La VPC tiene subredes en al menos dos zonas de disponibilidad (requisito EKS); NAT o egress documentado para subnets privadas. |
| **EKS en subnets privadas** | Si se entrega EKS, los nodos usan subnets privadas; la dependencia con VPC está modelada (Terragrunt `dependency` o `terraform_remote_state`). |
| **ECR gestionado** | Si se entrega ECR, los repositorios del TP están en código; si ya existían (Lab 1), hay `import` documentado y `plan` sin drift destructivo inesperado. |
| **Guardrail de cuenta** | El provider impide apply en cuenta incorrecta (`allowed_account_ids` o equivalente) o el README advierte explícitamente el riesgo. |
| **Sin credenciales en repo** | No hay keys AWS ni secretos en el historial de Git del entregable. |

---

## Resumen por consigna (referencia cruzada)

- **C1 (Estructura repo)** → entregable **1**.
- **C2 (VPC)** → entregables **1**, **4**.
- **C3 (ECR)** → entregables **1**, **2**, **4**.
- **C4 (EKS)** → entregables **1**, **2**, **4**.
- **C5 (Terragrunt / backend)** → entregables **1**, **2**.
- **C6 (dev y prd)** → entregables **1**, **4** (dos entornos con state buckets distintos).
- **C7 (Documentación y evidencia)** → entregables **2**, **3**, **4**.

---

## Notas para el docente

- **Plazos y formato**: El docente puede fijar plazos y si el informe se entrega en PDF o solo Markdown en el repo.
- **Costos AWS**: VPC, NAT Gateway y EKS generan costo; recomendar `destroy` al finalizar la cursada o usar cuentas de práctica AWS-UNC.
- **Variante mínima (solo PI base)**: Un solo entorno, VPC + un recurso (por ejemplo ECR) con Terraform sin Terragrunt puede ser suficiente para alumnos que recién introducen IaC; la implementación de tesis del repo es la **ruta avanzada**.
- **Variante completa (repo de referencia)**: Terragrunt, `dev` + `prd`, VPC + ECR + EKS, import de repos del Lab 1, bootstrap S3 con `use_lockfile`.
- **Evaluación**: Cada consigna C1–C7 puede evaluarse de forma independiente; este documento unifica qué entregar para homogeneizar la corrección.

---

*Documento basado en la Solicitud de Proyecto Integrador (PI) y en la Guía y consignas del Lab 3. Para el detalle de cada consigna, consultar [guia-y-consignas-lab3.md](guia-y-consignas-lab3.md).*
