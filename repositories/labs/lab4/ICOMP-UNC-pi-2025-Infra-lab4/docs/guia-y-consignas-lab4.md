# Guía y consignas – Lab 4: Clúster EKS y monitoreo con Grafana y Prometheus

**Destinatarios**: Alumnos de las materias vinculadas al Proyecto Integrador (ej. Ingeniería de Software, Gestión de la Calidad de Software).  
**Objetivo**: Desplegar un clúster **Amazon EKS** y la infraestructura asociada (VPC, ECR) mediante **Terraform/Terragrunt**, e instalar el stack de **observabilidad** (Prometheus y Grafana) integrando **charts de Helm en IaC**, como base para despliegues controlados y monitoreo activo en los laboratorios siguientes.

---

## 1. Guía para el alumno

### 1.1 Contexto

En los laboratorios anteriores del PI:

- **Lab 1**: Construiste imágenes Docker y las publicaste en **Amazon ECR** mediante pipelines CI/CD.
- **Lab 2**: Desplegaste la aplicación en Kubernetes con manifiestos y **Helm**.
- **Lab 3**: Declaraste en código la **VPC**, **ECR** y **EKS** con Terraform y Terragrunt.

En el **Lab 4** consolidás esa base y agregás **observabilidad en el clúster**: métricas con **Prometheus**, visualización con **Grafana** y componentes del chart **kube-prometheus-stack**, instalados mediante el **provider Helm de Terraform** (no solo con `helm install` manual).

Según la Solicitud del PI:

> *"Laboratorio 4 – Creación de un clúster EKS y monitoreo con Grafana y Prometheus. Se desplegará un clúster de EKS (Elastic Kubernetes Service) usando Terraform, integrando charts de Helm al IaC para desplegar recursos de Kubernetes."*

La implementación de referencia de este repositorio incluye cuatro módulos (`vpc`, `ecr`, `eks`, `monitoring`) y dos entornos (`dev`, `prd`). El docente puede pedir la ruta completa o una variante reducida (ver [entregables-lab4.md](entregables-lab4.md)).

### 1.2 Requisitos previos

- Haber completado o comprender el **Lab 3** (o equivalente: VPC + EKS en IaC).
- Haber completado o comprender el **Lab 1** (imágenes en ECR del frontend/backend del TP).
- Conocimientos básicos de **línea de comandos**, **Git** y conceptos de red (CIDR, subnets).
- **Terraform** `>= 1.6` instalado.
- **Terragrunt** reciente (1.x, con soporte `use_lockfile` en backend S3).
- **AWS CLI** configurado; credenciales activas (variables de entorno o perfil según indique el docente).
- **kubectl** instalado y familiaridad básica con namespaces y pods.
- **Helm CLI** (opcional, recomendado para depuración; el despliegue oficial es vía Terraform).
- Cuenta AWS con permisos para VPC, EC2, EKS, ECR, S3, IAM y acceso al API de Kubernetes del clúster.

### 1.3 Recursos recomendados

- [AWS EKS – User Guide](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [Prometheus – Overview](https://prometheus.io/docs/introduction/overview/)
- [Grafana – Documentation](https://grafana.com/docs/grafana/latest/)
- [kube-prometheus-stack – Helm chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Terraform Helm provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
- [README del repositorio](../README.md) e [informe final](informe-final-lab4.md)

### 1.4 Orden sugerido de trabajo

1. **Clonar** el repositorio del lab (o crear uno propio con la misma estructura `modules/` + `live/`).
2. **Editar** `live/dev/account.hcl` y `live/prd/account.hcl`: `aws_account_id`, `state_bucket`.
3. **Configurar credenciales** AWS y verificar cuenta: `aws sts get-caller-identity`.
4. **Bootstrap del backend** S3: `export TG_BACKEND_BOOTSTRAP=true` (ver README).
5. Desde `live/dev/us-east-1`: `terragrunt run --all init` y `plan` **excluyendo** `monitoring` en el primer pase, o aplicar unidades en orden manual.
6. **Apply VPC**; revisar outputs (`vpc_id`, `private_subnet_ids`).
7. **Apply ECR**; si los repos ya existen del Lab 1, ejecutar los `terragrunt import` del README y volver a `plan`.
8. **Apply EKS** (depende de VPC); configurar acceso: `aws eks update-kubeconfig --region us-east-1 --name tp4-dev-eks` y `kubectl get nodes`.
9. **Apply monitoring** (solo cuando EKS esté operativo).
10. **Validar observabilidad**: `kubectl get pods -n monitoring`, port-forward a Grafana, login y revisión de dashboards por defecto.
11. Repetir o adaptar pasos para **`prd`** si el docente lo exige.
12. **Documentar** en el informe: capturas, decisiones y enlaces a recursos AWS/Kubernetes.
13. **Entregar** según [entregables-lab4.md](entregables-lab4.md).

---

## 2. Consignas (qué debe cumplir el alumno)

Cada ítem puede evaluarse de forma independiente; el docente define criterios de corrección (revisión de código, ejecución de plan/apply, informe).

### C1. Estructura del repositorio

- **C1.1** Separar **módulos** (`modules/vpc`, `modules/ecr`, `modules/eks`, `modules/monitoring`) de la **configuración por entorno** (`live/dev/...`, `live/prd/...`).
- **C1.2** Cada módulo expone **variables** de entrada y **outputs** necesarios para composición (VPC → EKS; monitoring con outputs de servicios).

### C2. Módulo VPC

- **C2.1** Definir una VPC con CIDR propio y **al menos dos zonas de disponibilidad** (requisito de EKS).
- **C2.2** Crear **subredes públicas y privadas** por AZ; habilitar **NAT** para egress desde privadas.
- **C2.3** Etiquetar subnets para Kubernetes (`kubernetes.io/role/elb` y `kubernetes.io/role/internal-elb`).

### C3. Módulo ECR

- **C3.1** Declarar repositorios para las imágenes del TP (frontend y backend), con nombres acordados al Lab 1.
- **C3.2** Configurar al menos **scan on push** y una **política de lifecycle**.
- **C3.3** Si los repos ya existen en AWS, documentar y ejecutar **`terragrunt import`** para adoptarlos sin recrearlos.

### C4. Módulo EKS

- **C4.1** Desplegar un clúster EKS que consuma `vpc_id` y **subnets privadas** de la unidad VPC.
- **C4.2** Configurar al menos un **managed node group** con tamaños mín/máx/deseado documentados.
- **C4.3** Documentar acceso al API (`aws eks update-kubeconfig`) y permisos IAM del operador que ejecutó el apply.

### C5. Terragrunt y estado remoto

- **C5.1** Centralizar en `root.hcl` el **backend S3** remoto, cifrado y bloqueo (`use_lockfile` o DynamoDB si el docente lo prefiere).
- **C5.2** Usar un **prefijo de key** que identifique el lab (por ejemplo `lab4/`) para no colisionar con otros laboratorios en el mismo bucket.
- **C5.3** Expresar la dependencia **EKS → VPC** con bloque `dependency` de Terragrunt.

### C6. Módulo monitoring (observabilidad)

- **C6.1** Instalar el chart **kube-prometheus-stack** (o equivalente acordado) mediante `helm_release` en Terraform.
- **C6.2** Definir un archivo **values** con ajustes de laboratorio (recursos, retención, persistencia deshabilitada si aplica).
- **C6.3** Crear el **namespace** de monitoreo y documentar nombres de servicios (Grafana, Prometheus).

### C7. Provider Helm y autenticación EKS

- **C7.1** Configurar el provider **Helm** para autenticarse contra el API de EKS (por ejemplo `data.aws_eks_cluster` + `data.aws_eks_cluster_auth` generados en Terragrunt).
- **C7.2** Documentar por qué **monitoring** se aplica después de EKS y cómo se evita (o no) la dependencia de estado Terragrunt entre unidades.
- **C7.3** Gestionar la contraseña de Grafana de forma consciente (variable sensible; no commitear secretos de producción).

### C8. Entornos dev y prd, documentación y evidencia

- **C8.1** Mantener **buckets de estado separados** por entorno y CIDR/nombres distintos entre dev y prd.
- **C8.2** README con comandos de bootstrap, init, plan, apply y validación de Grafana.
- **C8.3** Informe final según [informe-final-lab4.md](informe-final-lab4.md): qué se hizo, por qué, marco teórico resumido y diagramas.
- **C8.4** Evidencia: pods en `monitoring`, captura de Grafana, planes sin cambios destructivos no intencionados.

---

## 3. Entregables para los alumnos (definición breve)

| Entregable | Descripción | Formato sugerido |
|------------|-------------|-------------------|
| **Repositorio IaC** | `modules/` + `live/` + README | Git |
| **Informe final** | Implementación, decisiones, teoría, diagramas | Markdown en `docs/` o PDF |
| **Evidencia** | Plans, consola AWS, kubectl, Grafana | Capturas en informe o anexo |
| **Diagramas** | Arquitectura y flujos | `docs/diagramas/*.mmd` |

Definición formal, criterios de aceptación y referencia cruzada C1–C8: **[entregables-lab4.md](entregables-lab4.md)**.

**Criterios de aceptación mínimos (resumen)**

- Estado en S3 con keys `lab4/`; plan revisado antes de apply.
- EKS operativo; stack de monitoreo en Running; acceso a Grafana documentado.
- Helm integrado en Terraform (`helm_release`).
- Sin credenciales AWS en el repositorio.

---

*Para el detalle de entregables y criterios de corrección, ver [entregables-lab4.md](entregables-lab4.md).*
