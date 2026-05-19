# Lab 4 - EKS, observabilidad (Prometheus/Grafana) y Terragrunt

Infraestructura como codigo para entornos `dev` y `prd` en `us-east-1`: VPC, ECR, EKS y stack de monitoreo **kube-prometheus-stack** instalado con el provider **Helm** de Terraform.

## Documentacion pedagogica

| Documento | Descripcion |
|-----------|-------------|
| [docs/guia-y-consignas-lab4.md](docs/guia-y-consignas-lab4.md) | Guia de trabajo y consignas para alumnos |
| [docs/entregables-lab4.md](docs/entregables-lab4.md) | Entregables obligatorios y criterios de aceptacion |
| [docs/informe-final-lab4.md](docs/informe-final-lab4.md) | Informe final: implementacion paso a paso, decisiones y marco teorico |
| [docs/diagramas/](docs/diagramas/) | Diagramas Mermaid (arquitectura, red, secuencia, observabilidad) |

## Estructura

- `modules/vpc`: VPC con al menos **2 AZ**, subnets publicas y privadas.
- `modules/eks`: EKS con 1 managed node group.
- `modules/ecr`: ECR para repositorios del TP (Lab 1).
- `modules/monitoring`: `helm_release` de **kube-prometheus-stack** (Prometheus + Grafana).
- `live`: jerarquia Terragrunt por entorno y region (`vpc`, `ecr`, `eks`, `monitoring`).

El state remoto usa el prefijo de key **`lab4/`** para no colisionar con el Lab 3 en los mismos buckets S3.

## Prerequisitos

- Terraform `>= 1.6`.
- Terragrunt reciente (soporte `use_lockfile` en backend S3).
- Credenciales AWS activas (`aws sts get-caller-identity`).
- **kubectl** instalado.
- Helm CLI (opcional, para depuracion).

## Configuracion inicial

1. Editar `live/dev/account.hcl` y `live/prd/account.hcl`:
   - `state_bucket` (convencion: `terraform-state-<env>-<account-id>`).
   - `aws_account_id`.
2. Bootstrap del backend S3 (ver seccion siguiente).

## Ejecucion por entorno

Ejemplo para `dev`:

```bash
cd live/dev/us-east-1
export TG_BACKEND_BOOTSTRAP=true

# Fase 1: infra AWS (sin monitoring)
terragrunt run --all init --terragrunt-exclude-dir monitoring
terragrunt run --all plan --terragrunt-exclude-dir monitoring
terragrunt run --all apply --terragrunt-exclude-dir monitoring
```

Orden efectivo: **vpc** → **ecr** → **eks** (`eks` depende de `vpc`).

Configurar acceso al clúster:

```bash
aws eks update-kubeconfig --region us-east-1 --name tp4-dev-eks
kubectl get nodes
```

**Fase 2: observabilidad** (solo cuando EKS este operativo):

```bash
cd live/dev/us-east-1/monitoring
terragrunt init
terragrunt plan
terragrunt apply
```

Equivalente con `run --all` solo para monitoring (desde `us-east-1`):

```bash
cd live/dev/us-east-1
terragrunt run --all init --terragrunt-include-dir monitoring
terragrunt run --all apply --terragrunt-include-dir monitoring
```

> No ejecutar `terragrunt run --all apply` incluyendo `monitoring` en el **primer** despliegue si EKS aun no existe.

## Validacion de Grafana

```bash
kubectl get pods -n monitoring
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80
```

Abrir `http://localhost:3000` — usuario `admin`; contraseña segun `live/<env>/us-east-1/monitoring/terragrunt.hcl` (solo laboratorio).

## Import de repos ECR existentes

### Dev

```bash
cd live/dev/us-east-1/ecr
export TG_BACKEND_BOOTSTRAP=true
terragrunt init
terragrunt import 'module.repositories["b4c0c6w7/tesis/tp1-frontend"].aws_ecr_repository.this[0]' b4c0c6w7/tesis/tp1-frontend
terragrunt import 'module.repositories["b4c0c6w7/tesis/tp1-backend"].aws_ecr_repository.this[0]' b4c0c6w7/tesis/tp1-backend
terragrunt plan
```

### Prd

```bash
cd live/prd/us-east-1/ecr
export TG_BACKEND_BOOTSTRAP=true
terragrunt init
terragrunt import 'module.repositories["b4c0c6w7/tesis/tp1-frontend-prd"].aws_ecr_repository.this[0]' b4c0c6w7/tesis/tp1-frontend-prd
terragrunt import 'module.repositories["b4c0c6w7/tesis/tp1-backend-prd"].aws_ecr_repository.this[0]' b4c0c6w7/tesis/tp1-backend-prd
terragrunt plan
```

## Notas

- Backend remoto: S3 con `use_lockfile = true` (sin DynamoDB).
- Keys de state: `lab4/<env>/us-east-1/<unidad>/terraform.tfstate`.
- La unidad `monitoring` genera el provider Helm con `data.aws_eks_cluster` por nombre de clúster; no usa `dependency` Terragrunt hacia `eks`.
- Provider AWS: `allowed_account_ids` en `root.hcl` impide apply en cuenta incorrecta.
- **Seguridad:** las contraseñas de Grafana en `terragrunt.hcl` son solo para el laboratorio; no usar en produccion.

## kubectl y permisos EKS

Si `kubectl` responde con error de credenciales, verificar que la identidad IAM de `aws sts get-caller-identity` sea la misma que ejecuto `terragrunt apply` en EKS. El modulo EKS usa `enable_cluster_creator_admin_permissions = true` para el aplicador del clúster.

## Costos

VPC (NAT), EKS y nodos EC2 generan costo en AWS. Ejecutar `destroy` al finalizar la practica o usar cuentas de practica AWS-UNC.
