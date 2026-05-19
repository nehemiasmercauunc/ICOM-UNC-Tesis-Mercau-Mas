# Guía y consignas – Lab 3: Infraestructura como código en la nube con Terraform

**Destinatarios**: Alumnos de las materias vinculadas al Proyecto Integrador (ej. Ingeniería de Software, Gestión de la Calidad de Software).  
**Objetivo**: Declarar y desplegar infraestructura en AWS mediante Terraform (y Terragrunt en la ruta avanzada), con estado remoto, módulos reutilizables y entornos separados, como base para los laboratorios de Kubernetes y observabilidad.

---

## 1. Guía para el alumno

### 1.1 Contexto

En los laboratorios anteriores del PI:

- **Lab 1**: Construiste imágenes Docker y las publicaste en **Amazon ECR** mediante pipelines CI/CD.
- **Lab 2** (u homólogo): Desplegaste la aplicación en Kubernetes con manifiestos y Helm.

En el **Lab 3** la infraestructura deja de crearse solo a mano en la consola: se define en **código** (IaC), se versiona en Git y se aplica de forma repetible. Esto incluye la **red (VPC)**, el **registro (ECR)** y el **clúster (EKS)** que consumirán las imágenes y cargas de trabajo de los labs siguientes.

Según la Solicitud del PI:

> *"Laboratorio 3 – Infraestructura como código en la nube con Terraform. Se desplegará infraestructura en la nube (por ejemplo, AWS) primero de forma manual y luego usando Terraform, introduciendo conceptos como providers, recursos, variables y manejo del estado remoto."*

La implementación de referencia de este repositorio va un paso más allá del mínimo del PI: usa **Terragrunt**, tres módulos (VPC, ECR, EKS) y dos entornos (`dev`, `prd`). El docente puede pedir la ruta completa o una variante reducida (ver [entregables-lab3.md](entregables-lab3.md)).

### 1.2 Requisitos previos

- Haber completado o comprender el **Lab 1** (imágenes en ECR del frontend/backend del TP).
- Conocimientos básicos de **línea de comandos**, **Git** y conceptos de red (CIDR, subnets).
- **Terraform** `>= 1.6` instalado.
- **Terragrunt** reciente (1.x, con soporte `use_lockfile` en backend S3) si se sigue este repo.
- **AWS CLI** configurado; credenciales activas (variables de entorno o perfil según indique el docente / Leapp).
- Cuenta AWS con permisos para VPC, EC2, EKS, ECR, S3, IAM (creación de roles del módulo EKS).

### 1.3 Recursos recomendados

- [Terraform – Intro](https://developer.hashicorp.com/terraform/intro)
- [Terragrunt – Documentation](https://terragrunt.gruntwork.io/docs/)
- [terraform-aws-modules/vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [terraform-aws-modules/eks](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
- [terraform-aws-modules/ecr](https://registry.terraform.io/modules/terraform-aws-modules/ecr/aws/latest)
- [README del repositorio](../README.md) y [marco conceptual](marco-conceptual-lab3.md)

### 1.4 Orden sugerido de trabajo

1. **Clonar** el repositorio del lab (o crear uno propio con la misma estructura `modules/` + `live/`).
2. **Editar** `live/dev/account.hcl` y `live/prd/account.hcl`: `aws_account_id`, `state_bucket` (convención `terraform-state-<env>-<account-id>`).
3. **Configurar credenciales** AWS y verificar cuenta: `aws sts get-caller-identity`.
4. **Bootstrap del backend**: `export TG_BACKEND_BOOTSTRAP=true` o usar `bin/tg` (ver README).
5. Desde `live/dev/us-east-1`: `terragrunt run --all init` y `terragrunt run --all plan`.
6. **Apply VPC** primero; revisar outputs (`vpc_id`, `private_subnet_ids`).
7. **Apply ECR**; si los repos ya existen del Lab 1, ejecutar los `terragrunt import` del README y volver a `plan`.
8. **Apply EKS** (depende de VPC); revisar acceso con `aws eks update-kubeconfig` y `kubectl get nodes` si aplica.
9. Repetir o adaptar pasos para **`prd`** si el docente lo exige.
10. **Documentar** en el informe: capturas de plan/apply, decisiones y enlaces a recursos AWS.
11. **Entregar** según [entregables-lab3.md](entregables-lab3.md).

---

## 2. Consignas (qué debe cumplir el alumno)

Cada ítem puede evaluarse de forma independiente; el docente define criterios de corrección (revisión de código, ejecución de plan/apply, informe).

### C1. Estructura del repositorio

- **C1.1** Separar **módulos** (`modules/vpc`, `modules/ecr`, `modules/eks` o equivalente) de la **configuración por entorno** (`live/dev/...`, `live/prd/...`).
- **C1.2** Cada módulo expone **variables** de entrada y **outputs** necesarios para composición (por ejemplo VPC → EKS).

### C2. Módulo VPC

- **C2.1** Definir una VPC con CIDR propio y **al menos dos zonas de disponibilidad** (requisito de EKS).
- **C2.2** Crear **subredes públicas y privadas** por AZ; habilitar **NAT** para egress desde privadas.
- **C2.3** Etiquetar subnets para Kubernetes (`kubernetes.io/role/elb` y `kubernetes.io/role/internal-elb`) si se usará EKS.

### C3. Módulo ECR

- **C3.1** Declarar repositorios para las imágenes del TP (frontend y backend), con nombres acordados al Lab 1.
- **C3.2** Configurar al menos **scan on push** y una **política de lifecycle** (por ejemplo conservar las últimas N imágenes).
- **C3.3** Si los repos ya existen en AWS, documentar y ejecutar **`terraform import`** / `terragrunt import` para adoptarlos sin recrearlos.

### C4. Módulo EKS

- **C4.1** Desplegar un clúster EKS que consuma `vpc_id` y **subnets privadas** de la unidad VPC.
- **C4.2** Configurar al menos un **managed node group** con tamaños mín/máx/deseado documentados.
- **C4.3** Documentar cómo obtener acceso al API (`aws eks update-kubeconfig`) y el requisito de **access entries** / identidad IAM que ejecutó el apply.

### C5. Terragrunt y estado remoto

- **C5.1** Centralizar en `root.hcl` el **backend S3** remoto, cifrado y bloqueo (`use_lockfile` o DynamoDB si el docente lo prefiere).
- **C5.2** Generar o definir el **provider AWS** con región y guardrail de cuenta (`allowed_account_ids`).
- **C5.3** Expresar la dependencia **EKS → VPC** con bloque `dependency` de Terragrunt (o `terraform_remote_state` en Terraform puro).

### C6. Entornos dev y prd

- **C6.1** Mantener **buckets de estado separados** por entorno (o keys claramente separadas).
- **C6.2** Usar **CIDR y nombres distintos** entre dev y prd (por ejemplo `10.10.0.0/16` vs `10.20.0.0/16`) para evitar colisiones si comparten cuenta.
- **C6.3** Documentar diferencias de capacidad (tipos de instancia, cantidad de nodos, nombres de repos ECR).

### C7. Documentación y evidencia

- **C7.1** README con comandos de bootstrap, init, plan, apply y orden de unidades.
- **C7.2** Informe final según [informe-final-lab3.md](informe-final-lab3.md) (o PDF): qué se hizo, por qué, marco teórico resumido.
- **C7.3** Evidencia de planes sin cambios destructivos no intencionados; capturas de recursos creados o importados.

---

## 3. Entregables para los alumnos (definición breve)

| Entregable | Descripción | Formato sugerido |
|------------|-------------|-------------------|
| **Repositorio IaC** | `modules/` + `live/` + README | Git |
| **Informe final** | Implementación, decisiones, teoría | Markdown en `docs/` o PDF |
| **Evidencia** | Plans, consola AWS, opcional kubectl | Capturas en informe o anexo |

Definición formal, criterios de aceptación y referencia cruzada C1–C7: **[entregables-lab3.md](entregables-lab3.md)**.

**Criterios de aceptación mínimos (resumen)**

- Estado en S3 (o backend acordado); plan revisado antes de apply.
- VPC con 2 AZ; EKS en subnets privadas si aplica; ECR con repos del TP.
- Sin credenciales en el repositorio.

---

*Guía alineada con la Solicitud de Proyecto Integrador y con la implementación de referencia en `ICOMP-UNC-pi-2025-Infra-lab3`.*
