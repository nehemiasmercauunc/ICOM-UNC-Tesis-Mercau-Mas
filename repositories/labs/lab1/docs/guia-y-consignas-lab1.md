# Guía y consignas – Lab 1: Construcción de imágenes con Docker y automatización de push

**Destinatarios**: Alumnos de las materias vinculadas al Proyecto Integrador (ej. Ingeniería de Software, Gestión de la Calidad de Software).  
**Objetivo**: Construir **dos aplicaciones** (frontend y backend) que se comuniquen, empaquetarlas en imágenes Docker, orquestar su construcción con **Docker Compose**, y configurar un **pipeline con reglas de ramas** que automatice build y publicación en un registro de contenedores (Amazon ECR).

---

## 1. Guía para el alumno

### 1.1 Contexto

En este laboratorio trabajarás con **contenedores**, **Docker Compose** y **pipelines de CI/CD**. Aprenderás a:

- Mantener **dos repositorios**: uno para el **frontend** y otro para el **backend**, que se comuniquen entre sí.
- Escribir un **Dockerfile** por servicio y un **Docker Compose** que construya y levante ambos.
- Configurar un **registro de contenedores** (en este curso: Amazon ECR).
- Automatizar build y publicación con un **pipeline** (GitHub Actions) siguiendo **reglas de ramas**: trabajo en `develop` con PRs, publicación en ECR solo al mergear a `main`.

El backend puede ser una API REST mínima; el frontend una app web que consuma esa API. Lo importante es que el flujo (dos repos → imágenes → Docker Compose → pipeline con develop/main) quede claro y automatizado.

### 1.2 Requisitos previos

- Conocimientos básicos de línea de comandos y de Git.
- Cuenta en GitHub.
- Cuenta en AWS (para usar ECR). Si la materia provee credenciales compartidas, usarlas según indicación del docente.
- Docker instalado en tu máquina (opcional pero recomendado para probar localmente).

### 1.3 Recursos recomendados

- [Docker – Get started](https://docs.docker.com/get-started/docker-overview/)
- [Amazon ECR – User Guide](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html)
- [GitHub Actions – Documentation](https://docs.github.com/en/actions)

### 1.4 Orden sugerido de trabajo

1. Tener **backend** y **frontend** funcionando localmente y comunicados (por URL/env).
2. Crear **dos repos** (uno por servicio); en cada uno, escribir el Dockerfile y verificar `docker build` y `docker run`.
3. Crear un **Docker Compose** que construya y levante ambos servicios (`docker compose up --build`).
4. Crear repositorios de imágenes en ECR (uno por servicio, o según indicación) y validar push manual.
5. Configurar **protección de ramas** en GitHub: `develop` y `main` obligatorias; sin push directo.
6. Crear el workflow de GitHub Actions: en PR/merge a `develop` solo CI (build, sin publicar); en merge a `main` desde `develop`, CI + publicación en ECR.
7. Documentar y entregar según las consignas y el documento de entregables.

---

## 2. Consignas (qué debe cumplir el alumno)

A continuación se listan las actividades que el alumno debe realizar para aprobar el Lab 1. Cada ítem puede evaluarse de forma independiente; el docente definirá los criterios de corrección (por ejemplo, revisión de código, ejecución del pipeline, revisión de informe).

### C1. Aplicación base (dos repos, front + back)

- **C1.1** Tener **dos aplicaciones** que se comuniquen: un **backend** (por ejemplo, API REST) y un **frontend** (app web). Cada una en su **propio repositorio**. Stack acordado con el docente (Node, .NET, Python, React, etc.).
- **C1.2** El frontend debe consumir al menos un endpoint del backend (URL configurable por variable de entorno). Ambas aplicaciones deben poder construirse y ejecutarse de forma repetible (comandos de build e inicio documentados).

### C2. Docker y Docker Compose

- **C2.1** Escribir un **Dockerfile** por servicio (backend y frontend) que construya la imagen correspondiente. Se valorará multi-stage build cuando reduzca el tamaño de la imagen final y el uso de `.dockerignore`.
- **C2.2** Incluir un **Docker Compose** (o `docker compose` V2) que construya y levante **ambos** servicios. La construcción completa debe poder hacerse con un único comando (ej. `docker compose up --build`). El Compose puede estar en uno de los dos repos o en un repo aparte; debe documentarse dónde está y cómo ejecutarlo.
- **C2.3** Documentar cómo construir y ejecutar cada imagen por separado (`docker build` / `docker run`) y cómo levantar el sistema con Docker Compose, incluyendo puertos y variables de entorno.
- **C2.4** Probar localmente que ambas imágenes y el Compose funcionan correctamente antes de integrar al pipeline.

### C3. Registro de contenedores

- **C3.1** Crear (o tener acceso a) un repositorio en un registro de contenedores. En el marco del PI se usará Amazon ECR; si el docente lo permite, puede usarse Docker Hub u otro registro.
- **C3.2** Realizar al menos un push manual de la imagen al registro y verificar que la imagen aparezca en el repositorio con el tag utilizado.

### C4. Pipeline CI/CD y reglas de ramas

- **C4.1** En **cada** repositorio (front y back) deben existir las ramas **`develop`** y **`main`**. No está permitido hacer push directo a ninguna de las dos; deben estar protegidas (GitHub: Branch protection rules).
- **C4.2** El código solo llega a `develop` mediante **Pull Request**. Al abrir/actualizar el PR o al hacer merge a `develop`, el pipeline debe ejecutarse y hacer **solo CI** (checkout, build de la imagen, y opcionalmente tests). **No** debe publicar la imagen en ECR en este flujo.
- **C4.3** El código solo llega a `main` mediante **Pull Request desde `develop`**. Al mergear a `main`, el pipeline debe ejecutar **CI y además** publicar la imagen en ECR (checkout, build, login al registro, etiquetar, push). La publicación en el registro debe ocurrir **únicamente** cuando el pipeline corre por la rama `main`.
- **C4.4** El pipeline debe: (a) checkout del código, (b) construir la imagen Docker, (c) si la rama es `main`, autenticarse en el registro, (d) etiquetar (ej. `main-<short-sha>`), (e) subir a ECR solo cuando corresponda (condición por rama).
- **C4.5** Las credenciales del registro no deben estar en el código; deben usarse GitHub Secrets (o equivalente).

### C5. Documentación y entrega

- **C5.1** Incluir en cada repo (o centralizado) un README que explique: objetivo del lab, cómo construir y ejecutar con Docker y con Docker Compose, y cómo funciona el pipeline (ramas `develop`/`main`, cuándo se dispara CI solo y cuándo CI + publicación en ECR).
- **C5.2** Entregar según lo indicado por el docente (enlaces a ambos repos, informe breve, o ambos). El informe debe describir qué se hizo, las reglas de ramas y pipeline, y las decisiones de diseño (base image, tagging, etc.).

---

## 2.1 Buenas prácticas (resumen)

| Área | Práctica |
|------|----------|
| **Ramas** | No push directo a `develop` ni a `main`; merge solo por PR. Opcional: exigir que el CI pase antes de mergear (status checks en GitHub). |
| **Secrets** | Nunca credenciales en el código; usar GitHub Secrets en el workflow. |
| **Docker** | `.dockerignore` para no copiar archivos innecesarios; multi-stage build cuando aporte; considerar usuario no root en la imagen final. |
| **Pipeline** | Build (y tests si hay) antes de push; etiquetado claro (ej. `main-<sha>`); publicar solo en `main`. |
| **Repos** | `.gitignore` correcto; mensajes de commit descriptivos. |

---

## 3. Entregables para los alumnos (definición formal)

Para la definición **completa** de entregables (dos repos, Docker Compose, reglas de ramas y pipeline, criterios de aceptación), se debe consultar el documento **`entregables-lab1.md`** en esta misma carpeta. Resumen:

| Entregable | Descripción | Formato sugerido |
|------------|-------------|-------------------|
| **Repositorios** | **Dos** repos: frontend y backend, cada uno con código, Dockerfile(s) y workflow. Accesibles para el corrector. | Dos repos Git (GitHub u otro). |
| **Docker Compose** | Composición que construya y levante front + back (`docker compose up --build`). | `docker-compose.yml` + documentación en README. |
| **README** | En cada repo (o centralizado): clonar, construir con Docker/Docker Compose, ejecutar, y explicación del pipeline (ramas, cuándo se publica en ECR). | README.md en cada repo o en `docs/`. |
| **Informe breve** | Tecnologías, reglas de ramas (develop/main, PRs), decisiones de diseño, evidencia de pipeline en develop (CI sin publicar) y en main (imagen en ECR). | PDF o Markdown según indicación del docente. |

**Criterios de aceptación mínimos** (detalle en `entregables-lab1.md`)

- Dos repos (front + back) que se comunican; Docker Compose construye y levanta ambos.
- Ramas `develop` y `main` protegidas; merge solo por PR; publicación en ECR solo al mergear a `main`.
- Pipeline ejecutado correctamente (evidencia en PR a develop y merge a main); imágenes en ECR con el tag configurado.
- README permite reproducir build y ejecución local (incl. Docker Compose) sin información adicional.

Con esto se cubren las tareas del Lab 1: guía de trabajo, consignas concretas y definición formal de entregables en `entregables-lab1.md`.
