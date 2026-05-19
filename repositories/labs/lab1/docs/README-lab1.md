# Lab 1: Construcción de imágenes con Docker y automatización de push

## Introducción a los temas del laboratorio

Este laboratorio introduce los conceptos necesarios para **containerizar** una aplicación y **automatizar** su construcción y publicación en un registro de contenedores en la nube. Es el primer paso del ciclo de vida moderno de una aplicación: poder empaquetarla de forma reproducible y publicarla de forma automática cada vez que hay cambios en el código.

---

## Contenedores y Docker

- **Contenedores**: Un contenedor es una unidad de ejecución ligera y aislada que empaqueta una aplicación junto con sus dependencias (runtime, librerías, configuración). A diferencia de una máquina virtual, comparte el kernel del sistema operativo del host y arranca en segundos.

- **Docker**: Es la plataforma estándar de facto para crear, ejecutar y distribuir contenedores. Permite definir la “receta” de una imagen en un **Dockerfile**: base (ej. .NET, Node), copia del código, instalación de dependencias, comando de build y comando de arranque. A partir de eso se genera una **imagen** inmutable que puede ejecutarse en cualquier entorno que tenga Docker.

- **Imagen**: Es el resultado de construir un Dockerfile. Tiene capas read-only y un identificador (tag). Es portable y versionable (por tag o digest).

---

## Registro de contenedores (Container Registry)

- Un **registro** es un repositorio donde se almacenan y comparten imágenes. Ejemplos: Docker Hub (público), **Amazon ECR** (AWS), Google Container Registry, Azure ACR.

- **Amazon ECR (Elastic Container Registry)**: Servicio gestionado de AWS para almacenar imágenes Docker. Se integra con IAM para permisos y con EKS/ECS para desplegar. En este lab se usa ECR como destino del push automático.

- **Flujo**: construir imagen localmente (o en un pipeline) → etiquetar con la URL del registro → hacer login en el registro → `docker push`.

---

## Pipelines CI/CD y automatización del push

- **CI (Integración Continua)**: Cada vez que se integra código (por ejemplo, push a una rama), se ejecutan de forma automática pasos como compilación, tests y construcción de artefactos. Así se detectan fallos pronto y se mantiene el código en estado desplegable.

- **CD (Entrega/Despliegue Continuo)**: Automatizar la entrega de esos artefactos a entornos (staging, producción). En este lab, el “despliegue” es llevar la imagen al registro (ECR); en labs posteriores se sumará el despliegue a Kubernetes.

- **Pipeline**: Secuencia de pasos automatizados. En este proyecto se usa **GitHub Actions**: ante un push (backend) o ante un release (frontend), el workflow hace checkout, configura Docker Buildx, se autentica en AWS/ECR, construye la imagen y la sube a ECR con un tag (rama + SHA o SHA del release).

---

## Relación con el Proyecto Integrador

Según la Solicitud de Proyecto Integrador (PI), el Lab 1 consiste en:

> *"Se construirá una imagen Docker de una aplicación simple y se configurará un pipeline que automatice su construcción y subida a un registro de contenedores, como Docker Hub o Amazon ECR."*

Aquí la “aplicación simple” está compuesta por un **backend** (API .NET) y un **frontend** (app React con Vite). Cada uno tiene su propio Dockerfile y su pipeline que publica la imagen en Amazon ECR. Esto sienta las bases para los siguientes laboratorios (Kubernetes, Helm, EKS, etc.).

---

## Próximos pasos (Labs 2–6)

- **Lab 2**: Desplegar la aplicación en un clúster Kubernetes (manifiestos y Helm).
- **Lab 3**: Infraestructura como código con Terraform.
- **Lab 4**: Clúster EKS con Terraform y monitoreo (Grafana/Prometheus).
- **Lab 5**: Feature flags (Split) y rollouts canary.
- **Lab 6**: Pipeline CI/CD completo que integra build, IaC, despliegue y monitoreo.

Para los entregables concretos de este lab, consultar la **Guía y consignas del Lab 1** y el **Informe final del Lab 1** en esta misma carpeta.
