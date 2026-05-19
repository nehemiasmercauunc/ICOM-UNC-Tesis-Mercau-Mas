# Lab 3 - Terraform + Terragrunt

Base de infraestructura como codigo para los entornos `dev` y `prd` en `us-east-1`.

Marco conceptual para el informe (roles de cada componente y diagrama): [docs/marco-conceptual-lab3.md](docs/marco-conceptual-lab3.md).

## Estructura

- `modules/vpc`: VPC con al menos **2 AZ** (requisito de EKS), subnets publicas y privadas por AZ (module community `terraform-aws-modules/vpc/aws`).
- `modules/eks`: EKS basico con 1 managed node group (module community `terraform-aws-modules/eks/aws`).
- `modules/ecr`: ECR para repositorios existentes o nuevos (module community `terraform-aws-modules/ecr/aws`).
- `live`: jerarquia Terragrunt por entorno y region.

## Prerequisitos

- Terraform `>= 1.6`.
- Terragrunt reciente (con soporte `use_lockfile` en backend S3).
- Credenciales AWS activas en el entorno (por ejemplo las que inyecta Leapp: variables de entorno estandar de AWS). No se usa `profile` en el codigo.
- Bucket S3 de estado: con Terragrunt 1.x hay que **bootstrappear** el backend (no alcanza con `terragrunt plan` solo). Ver seccion siguiente.

## Configuracion inicial

1. Editar:
   - `live/dev/account.hcl`
   - `live/prd/account.hcl`
2. Completar:
   - `state_bucket` (convencion sugerida: `terraform-state-<env>-<account-id>` para que sea globalmente unico).
   - `aws_account_id` (guardrail para impedir deploy cruzado de cuentas).

## Ejecucion por entorno

Ejemplo para `dev`:

```bash
cd live/dev/us-east-1
# Opcion A: variable de entorno (recomendado mientras trabajas en este repo)
export TG_BACKEND_BOOTSTRAP=true

terragrunt run --all init
terragrunt run --all plan
```

Alternativa explicita sin variable global:

```bash
cd live/dev/us-east-1/vpc
terragrunt backend bootstrap --backend-bootstrap
cd ..
terragrunt run --all init
terragrunt run --all plan
```

Equivalente por comando:

```bash
terragrunt run --all --backend-bootstrap init
terragrunt run --all --backend-bootstrap plan
```

Orden recomendado de apply:

1. `vpc`
2. `ecr`
3. `eks`

Tambien se puede usar `terragrunt run --all apply` porque `eks` depende de `vpc`.

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

- Backend remoto: S3 con `use_lockfile = true`.
- Bootstrap de bucket: usar `TG_BACKEND_BOOTSTRAP=true` o `terragrunt run --backend-bootstrap ...` / `terragrunt backend bootstrap --backend-bootstrap` (Terragrunt 1.x).
- No se usa DynamoDB para locking.
- En EKS se consumen `vpc_id` y `private_subnet_ids` desde la dependencia Terragrunt de `vpc`.
- Seguridad de cuenta: el provider usa `allowed_account_ids`, por lo que si estas en `live/dev/...` y tus credenciales apuntan a otra cuenta, Terraform falla antes de aplicar.

## Disclaimer: `kubectl` y credenciales en EKS

Si `aws eks get-token` funciona pero `kubectl get pods` responde con *"the server has asked for the client to provide credentials"*, **no es un fallo de pegar access keys en el kubeconfig**. EKS usa el plugin `aws eks get-token`; el problema suele ser que **la identidad IAM con la que corres `kubectl` no tiene permiso en el plano de control del clúster** (access entries / RBAC de EKS), no que falte el token en sí.

En el modulo `modules/eks` esta `enable_cluster_creator_admin_permissions = true`: eso crea la access entry de administrador para la **identidad IAM que ejecuta `terragrunt apply`** al crear o actualizar el clúster. Despues de aplicar, alinear el contexto con:

```bash
aws eks update-kubeconfig --region us-east-1 --name <nombre-del-cluster>
```

`kubectl` debe usar **el mismo ARN** que `aws sts get-caller-identity` que usaste para el apply (mismo usuario o rol). Si desplegas con un IAM y entras a `kubectl` con otro, hay que dar acceso a ese segundo principal en EKS (consola: *Access*, o Terraform con `access_entries`).

## Mejora posible: identidad fija de despliegue

Como evolucion recomendable (no implementada en este repo): crear un **usuario IAM o rol dedicado** (por convencion `terraform-deployer` o similar) con politicas acotadas solo a lo necesario para Terragrunt (S3 estado, EKS, EC2, IAM acorde al modulo, etc.) y **usar siempre esa identidad** para `terragrunt apply` y, si se desea el mismo actor para operar el cluster, para `kubectl` + `aws eks update-kubeconfig`. Ventajas: auditoria clara, rotacion de claves o asuncion de rol centralizada, y separacion entre cuentas humanas y automatismo de despliegue.
