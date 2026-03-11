# Entregables – Lab 1: Construcción de imágenes con Docker y automatización de push

**Proyecto Integrador** – Desarrollo de Laboratorios y Prácticas Iterativas e Incrementales en un Cloud Provider (Alianza AWS-UNC).

Este documento define de forma explícita **qué debe entregar el alumno** para aprobar el Lab 1. Los entregables están alineados con la propuesta del PI (Solicitud de Proyecto Integrador) y con las consignas detalladas en la **Guía y consignas del Lab 1**.

---

## Marco del Lab 1 según la propuesta del PI

Según la Solicitud de Proyecto Integrador:

> *"Laboratorio 1 – Construcción de imágenes con Docker y automatización de push. Se construirá una imagen Docker de una aplicación simple y se configurará un pipeline que automatice su construcción y subida a un registro de contenedores, como Docker Hub o Amazon ECR."*

El alumno debe demostrar que es capaz de:

1. Tener **dos aplicaciones que se comuniquen**: un **frontend** y un **backend**, cada una en su propio repositorio.
2. Empaquetar cada aplicación en su imagen Docker y orquestar la construcción y ejecución local con **Docker Compose**.
3. Publicar las imágenes en un registro de contenedores (en el marco del PI: Amazon ECR).
4. Automatizar construcción y push mediante un **pipeline con reglas de ramas** (develop / main, PRs, publicación solo desde main).

---

## Estructura obligatoria: dos repos y Docker Compose


| Requisito                | Descripción                                                                                                                                                                                                                                                                                                                                                                                   |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Repositorio backend**  | Código del backend (API o servicio), su Dockerfile y workflow de CI/CD. El backend debe exponer al menos un endpoint que el frontend consuma.                                                                                                                                                                                                                                                 |
| **Repositorio frontend** | Código del frontend (app web), su Dockerfile y workflow de CI/CD. El frontend debe comunicarse con el backend (por URL/configuración).                                                                                                                                                                                                                                                        |
| **Docker Compose**       | Un `docker-compose` (o Compose V2: `docker compose`) que construya y levante **ambos** servicios (front + back) de forma integrada. La construcción completa del sistema debe poder hacerse con Docker Compose (por ejemplo, `docker compose up --build`). Puede vivir en uno de los dos repos o en un repo “orquestador”; si está en uno solo, debe documentarse cómo clonar/ejecutar ambos. |


---

## Reglas de ramas y pipeline (obligatorias)

Las ramas `**develop`** y `**main**` son obligatorias en **cada** repositorio (front y back). El pipeline debe comportarse así:


| Regla                                          | Descripción                                                                                                                                                                                                                             |
| ---------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **No push directo a `develop`**                | No se permite hacer `git push` directamente a `develop`. La rama debe estar protegida (GitHub: Branch protection rules).                                                                                                                |
| **No push directo a `main`**                   | No se permite hacer `git push` directamente a `main`. La rama debe estar protegida.                                                                                                                                                     |
| **Merge a `develop` solo por PR**              | El código llega a `develop` únicamente mediante un **Pull Request**. Al abrir/actualizar el PR o al hacer merge a `develop`, se dispara el pipeline de **CI** (build, tests si los hay). En este flujo **no** se publica imagen en ECR. |
| **Merge a `main` solo desde `develop` por PR** | El código llega a `main` únicamente mediante un **Pull Request** desde `develop`. Al mergear a `main`, el pipeline debe ejecutar **CI y además publicar** la imagen en ECR (build + tag + push).                                        |
| **Publicación solo desde `main`**              | Las imágenes que se suben al registro (ECR) deben generarse exclusivamente cuando el pipeline corre por cambios en `main` (o por merge a `main`).                                                                                       |


**Resumen**: trabajo en ramas de feature → PR a `develop` (CI sin publicar) → PR de `develop` a `main` (CI + publicación en ECR).

---

## Buenas prácticas exigidas o recomendadas


| Área              | Práctica                                                                                                                                                                       |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Ramas**         | Protección de `develop` y `main`: no push directo; merge solo por PR. Opcional: exigir que el pipeline de CI pase antes de permitir el merge (status checks).                  |
| **Secrets**       | Credenciales (AWS, ECR, etc.) **nunca** en el código; usar GitHub Secrets (o equivalente) en el pipeline.                                                                      |
| **Docker**        | Uso de `.dockerignore` para no copiar archivos innecesarios; multi-stage build cuando reduzca tamaño; imágenes finales preferentemente con usuario no root cuando sea posible. |
| **Pipeline**      | Build (y tests si existen) antes de intentar push; fallar rápido. Etiquetado claro (ej. `main-<short-sha>`, `develop-<short-sha>` para trazabilidad).                          |
| **Repos**         | `.gitignore` correcto (dependencias, archivos de entorno, secretos). Commits con mensajes descriptivos.                                                                        |
| **Documentación** | README en cada repo con cómo construir con Docker y con Docker Compose, y cómo funciona el pipeline (qué evento dispara qué: PR a develop vs merge a main).                    |


---

## Listado de entregables obligatorios


| #     | Entregable                           | Descripción                                                                                                                                                                                                              | Formato                                                  | Relación con consignas |
| ----- | ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------- | ---------------------- |
| **1** | **Repositorios de código**           | **Dos** repositorios: frontend y backend. Cada uno con su código, Dockerfile(s), workflow del pipeline y, si aplica, referencia al `docker-compose` (en uno de los repos o en un tercero). Accesibles para el corrector. | Dos repos Git (GitHub u otro)                            | C1, C2, C4             |
| **2** | **Docker Compose**                   | Composición que construya y levante front + back. Documentación clara de cómo ejecutar `docker compose up --build` (o equivalente) y cómo se comunican los servicios.                                                    | `docker-compose.yml` + README en el repo que corresponda | C2, C1                 |
| **3** | **README (o documentación técnica)** | En cada repo (o centralizado): clonar, construir con Docker/Docker Compose, ejecutar, variables de entorno y puertos. Explicación del pipeline: ramas, PRs y cuándo se publica en ECR.                                   | `README.md` en cada repo (o en `docs/`)                  | C2.2, C4, C5.1         |
| **4** | **Informe breve**                    | Tecnologías, pasos del pipeline, reglas de ramas (develop/main, PRs), decisiones de diseño (multi-stage, tagging). Evidencia: pipeline en PR a develop (CI sin publicar) y merge a main (imagen en ECR).                 | PDF o Markdown según indicación del docente              | C5.2                   |


---

## Criterios de aceptación mínimos

Para considerar el Lab 1 **aprobado**, debe cumplirse lo siguiente:


| Criterio                     | Verificación                                                                                                                                                                                                                                                                       |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Dos repos (front + back)** | Existen dos repositorios; el frontend consume al menos un endpoint del backend. Comunicación documentada (URL, variables de entorno).                                                                                                                                              |
| **Docker Compose**           | `docker compose up --build` (o equivalente) construye y levanta ambos servicios. Un corrector puede reproducir el escenario local siguiendo el README.                                                                                                                             |
| **Ramas y pipeline**         | En cada repo: no hay push directo a `develop` ni a `main`; merge a `develop` solo por PR (pipeline corre CI, **no** publica); merge a `main` solo desde `develop` por PR (pipeline corre CI **y** publica en ECR). Evidencia: capturas o enlaces a PRs y ejecuciones del pipeline. |
| **Imagen en el registro**    | Las imágenes (front y back) generadas al mergear a `main` están en ECR con el tag configurado. Evidencia: URL o captura del repositorio en ECR.                                                                                                                                    |
| **Credenciales seguras**     | Credenciales del registro no están en el código; se usan secrets del entorno (ej. GitHub Secrets).                                                                                                                                                                                 |


---

## Resumen por consigna (referencia cruzada)

- **C1 (Aplicación base)**: Front + back en dos repos, comunicados y repetibles → entregable **1**.
- **C2 (Docker + Compose)**: Dockerfile por servicio + Docker Compose que construye todo → entregables **1**, **2** y **3**.
- **C3 (Registro)**: Repos en ECR; imágenes publicadas solo desde pipeline al mergear a `main` → evidencia en entregable **4**.
- **C4 (Pipeline CI/CD)**: Reglas de ramas (develop/main, PRs), CI en PR a develop, CI + push a ECR en merge a main → entregables **1** y **4**.
- **C5 (Documentación y entrega)**: README(s) + informe con evidencia de flujo develop → main y publicación → entregables **3** y **4**.

---

## Notas para el docente

- **Plazos y formato**: El docente puede fijar plazos (fecha de entrega) y formato concreto del informe (PDF, extensión máxima, entrega por campus, etc.).
- **Registro**: En el marco del PI se prioriza Amazon ECR; si se autoriza Docker Hub u otro registro, debe quedar indicado en la guía/consignas.
- **Evaluación**: Cada ítem de consigna (C1–C5) puede evaluarse de forma independiente; este documento unifica qué “entregar” para que la evaluación sea homogénea entre alumnos.
- **Protección de ramas**: Se recomienda que el docente indique a los alumnos cómo configurar Branch protection en GitHub (Settings → Branches) para `develop` y `main`: bloquear push directo y, opcionalmente, exigir que el workflow de CI pase antes de permitir el merge.

---

## Recomendación de implementación del pipeline

- **Eventos del workflow**: Disparar el pipeline en `pull_request` y `push` hacia `develop` y `main`. Dentro del job, detectar la rama: si es `main` (o el evento es `push` a `main`), ejecutar además login a ECR, tag y push; si es `develop` o un PR, solo build (y tests si existen).
- **Condición de publicación**: Usar una condición en el paso de push a ECR (ej. `if: github.ref == 'refs/heads/main' && github.event_name == 'push'`) para publicar únicamente cuando el código está en `main`.
- **Tagging**: Usar por ejemplo `main-<short-sha>` o `latest` para imágenes desde `main`, y opcionalmente `develop-<short-sha>` solo para build sin publicar, de modo que quede trazabilidad en los logs.

Con esto se cumple la regla de “solo se publica en ECR al mergear a main” y se mantiene CI en todo el flujo (PR a develop y PR a main).

---

*Documento basado en la Solicitud de Proyecto Integrador (PI) y en la Guía y consignas del Lab 1. Para el detalle de cada consigna, consultar `guia-y-consignas-lab1.md`.*