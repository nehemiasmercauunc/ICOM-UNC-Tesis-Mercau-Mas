# Informe final – Lab 1: Construcción de imágenes con Docker y automatización de push

**Proyecto Integrador – Desarrollo de Laboratorios y Prácticas Iterativas en un Cloud Provider (AWS-UNC)**  
Referencia: Solicitud de Proyecto Integrador, documento de presentación del trabajo final.

---

## 1. Objetivo del laboratorio

Construir imágenes Docker de una aplicación (backend y frontend), configurar un pipeline que automatice la construcción y la subida de esas imágenes a un registro de contenedores (Amazon ECR), y sentar las bases para los laboratorios siguientes (Kubernetes, Helm, EKS, etc.).

---

## 2. Tecnologías utilizadas

| Área | Tecnología | Uso en el Lab 1 |
|------|------------|------------------|
| Backend | .NET 9 (ASP.NET Core) | API REST del Device Manager. |
| Frontend | React 18, Vite 5, MUI 5, React Router | Aplicación web del Device Manager. |
| Contenedores | Docker | Definición y construcción de imágenes (Dockerfile). |
| Registro | Amazon ECR (Elastic Container Registry) | Almacenamiento y versionado de imágenes. |
| CI/CD | GitHub Actions | Pipeline de build y push automático a ECR. |
| Infraestructura | AWS (IAM, ECR) | Cuenta y credenciales para acceso al registro. |

---

## 3. Descripción de las tareas realizadas

### 3.1 Crear cuenta de AWS y compartir credenciales

Se creó una cuenta en AWS y se configuraron credenciales (access key / secret) para que los pipelines pudieran autenticarse contra ECR. Las credenciales se almacenaron como **secrets** en GitHub (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) para no exponerlas en el código. Esto permite que GitHub Actions ejecute `aws ecr get-login-password` y `docker push` contra el registro sin hardcodear datos sensibles.

### 3.2 Backend API (Device Manager)

Se desarrolló una API REST en .NET que expone operaciones sobre dispositivos y sensores (CRUD). La solución está organizada en capas: **Web** (controladores y configuración), **Business** (servicios) y **Data** (repositorios). Se creó un **Dockerfile** multi-stage: etapa de build con SDK .NET 9 (restore, publish) y etapa de runtime con imagen `aspnet:9.0`, copiando solo el resultado del publish. La aplicación escucha en el puerto 8080 y se ejecuta con `dotnet Web.dll`.

### 3.3 Frontend (Device Manager App)

Se desarrolló una aplicación web en React (Vite, MUI, React Router) que consume la API del backend. Se creó un **Dockerfile** que usa `node:20-alpine`, instala dependencias con `npm ci`, ejecuta `npm run build` y sirve los estáticos con `serve`. Se utilizó un script de entrypoint para inyectar variables de entorno en tiempo de ejecución (por ejemplo, URL de la API) sin reconstruir la imagen.

### 3.4 Pipeline de construcción y push de imagen a un repositorio

- **Backend**: Workflow de GitHub Actions que se dispara en **push** a las ramas `develop` y `main`. Pasos: checkout, Docker Buildx, configuración de credenciales AWS, login a ECR (registro público), build de la imagen con `docker-config/Dockerfile`, tag con `ref_name-sha` y push a ECR. En `main` se añade un job de release que crea un GitHub Release con tag numérico.

- **Frontend**: Workflow que se dispara ante la **creación de un release** en GitHub. Misma secuencia (checkout, Buildx, AWS, login ECR, build, tag con `github.sha`, push). Las imágenes se publican en el repositorio ECR configurado (`b4c0c6w7/tesis/tp1-backend` y `tp1-frontend`).

Con esto se cumple el objetivo del Lab 1: construcción de imágenes Docker y automatización de su subida a un registro (Amazon ECR).

---

## 4. Justificación y decisiones de diseño

- **Dockerfile multi-stage (backend)**: Reduce el tamaño de la imagen final al no incluir el SDK; solo se incluye el runtime y el artefacto publicado. Mejora tiempos de pull y superficie de ataque.

- **Uso de ECR en lugar de Docker Hub**: Alineado con la alianza AWS-UNC y con los labs posteriores (EKS, Terraform sobre AWS). ECR se integra con IAM y con los servicios de orquestación que se usarán más adelante.

- **Secrets en GitHub**: Las credenciales AWS no deben estar en el repositorio. Usar GitHub Secrets permite que solo el pipeline tenga acceso y cumple buenas prácticas de seguridad.

- **Tagging con rama y SHA (backend)**: Permite identificar en ECR qué commit y rama generó cada imagen, facilitando trazabilidad y rollback.

- **Frontend disparado por release**: Se eligió release como gatillo para el frontend para controlar cuándo se publica una nueva imagen “estable”, mientras el backend se construye en cada push a develop/main para iterar más rápido en la API.

---

## 5. Marco teórico – conceptos cloud y DevOps utilizados

### 5.1 Contenedores

Un **contenedor** es una unidad de ejecución ligera y aislada que empaqueta una aplicación junto con todo lo que necesita para ejecutarse: runtime, librerías, herramientas y configuración. A diferencia de una máquina virtual (VM), el contenedor no incluye un sistema operativo completo; comparte el kernel del sistema operativo del host mediante mecanismos de aislamiento del kernel (namespaces, cgroups en Linux). Esto implica menor consumo de recursos, arranques en segundos y mayor densidad de aplicaciones por servidor.

**Para qué se usan**: Ejecutar aplicaciones de forma reproducible en distintos entornos (desarrollo, integración, staging, producción) sin las clásicas diferencias de “en mi máquina funciona”. También sirven como unidad de despliegue estándar: la misma imagen puede correr en un notebook, en un servidor on-premise o en la nube.

**Ventajas**: Portabilidad, reproducibilidad, aislamiento entre aplicaciones, escalado rápido, alineación con prácticas DevOps (build once, run anywhere). Facilitan el despliegue automático y la orquestación (Kubernetes, ECS, etc.).

**Qué problema resuelven**: La inconsistencia entre entornos (“depende del SO o de las versiones instaladas”), la dificultad para replicar exactamente el mismo entorno, y la pesadez de las VMs cuando solo se necesita aislar un proceso y sus dependencias.

### 5.2 Docker

**Docker** es la plataforma estándar de facto para crear, ejecutar y distribuir contenedores. Proporciona un modelo de “imagen” (plantilla read-only con capas) y “contenedor” (instancia en ejecución de una imagen), un formato estándar (OCI) y una CLI y API para construir, ejecutar y compartir imágenes.

**Para qué se usa**: Definir la “receta” de una aplicación en un **Dockerfile** (imagen base, copia de código, instalación de dependencias, comando de build y de arranque), construir la imagen con `docker build` y ejecutarla con `docker run`. Permite construir imágenes multi-stage (una etapa para compilar, otra para ejecutar) reduciendo el tamaño final y la superficie de ataque.

**Ventajas**: Ecosistema maduro, documentación amplia, integración con registros (Docker Hub, ECR, GCR), uso en CI/CD y en orquestadores. El formato de imagen es portable entre proveedores cloud y herramientas.

**Qué problema resuelve**: Estandarizar cómo se empaqueta y se ejecuta una aplicación, evitando “instrucciones de instalación” largas y frágiles y permitiendo que desarrollo y operaciones trabajen sobre el mismo artefacto (la imagen).

### 5.3 Registro de contenedores y Amazon ECR

Un **registro de contenedores** es un almacén centralizado donde se guardan y distribuyen imágenes. Funciona de forma análoga a un repositorio de paquetes (npm, NuGet): se hace push de imágenes etiquetadas y los consumidores (otros equipos, pipelines, clústeres) hacen pull por nombre y tag.

**Amazon ECR (Elastic Container Registry)** es el servicio gestionado de AWS para almacenar imágenes Docker. Ofrece repositorios privados (y públicos), integración con IAM para permisos granulares, escaneo de vulnerabilidades en las imágenes y baja latencia cuando se usa junto con EKS, ECS o Lambda (que pueden extraer imágenes directamente desde ECR en la misma red/región).

**Para qué se usa**: Almacenar las imágenes construidas por el pipeline, versionarlas por tag (por ejemplo, rama-SHA o versión semántica) y servir como fuente de verdad para los entornos que despliegan (en este lab solo se “entrega” la imagen al registro; en labs posteriores EKS/Helm la consumirán desde ECR).

**Ventajas**: Alta disponibilidad, cifrado, control de acceso con IAM, integración nativa con el ecosistema AWS y sin necesidad de mantener un registro propio.

**Qué problema resuelve**: Dónde guardar las imágenes de forma segura y accesible para máquinas y pipelines, sin depender de artefactos en discos locales o en repositorios de código, y con trazabilidad (quién subió qué y cuándo).

### 5.4 Integración continua (CI)

**Integración continua** es la práctica de integrar el código de forma frecuente (varias veces al día) en una rama compartida y ejecutar de forma automática un conjunto de pasos: compilación, pruebas unitarias e integración, análisis estático, construcción de artefactos (en este caso, la imagen Docker). El objetivo es detectar fallos lo antes posible y mantener el código en un estado siempre “construible” y probado.

**Para qué se usa**: En este lab, el paso de CI es la construcción de la imagen Docker y su publicación en ECR ante cada push (backend) o ante cada release (frontend). En labs siguientes se sumarán tests automatizados y herramientas como SonarQube o CodeQL.

**Ventajas**: Detección temprana de errores, reducción de la “deuda” de integración, confianza para refactorizar, y generación automática de artefactos listos para desplegar.

**Qué problema resuelve**: Evitar que el código roto llegue a producción, que “solo en la máquina de X funciona” y que la integración sea un evento doloroso al final del sprint; en su lugar, la integración es un proceso continuo y automatizado.

### 5.5 Entrega continua (CD)

**Entrega continua** extiende la automatización más allá del build: cada cambio que pasa CI puede ser llevado de forma automática (o con aprobación) a entornos de staging o producción. Incluye la publicación de artefactos en repositorios (registros, artefactories) y, en pipelines más avanzados, el despliegue en servidores o clústeres (Kubernetes, ECS, etc.).

**Para qué se usa**: En este lab, el paso de CD es el push de la imagen al registro (ECR); la “entrega” es dejar el artefacto disponible para quien vaya a desplegarlo. En Labs 2–6 se añadirá el despliegue efectivo a Kubernetes, con Helm y estrategias canary.

**Ventajas**: Reducción del tiempo entre “commit” y “disponible en producción”, menos pasos manuales y propensos a error, y posibilidad de hacer releases pequeños y frecuentes (reduciendo riesgo).

**Qué problema resuelve**: El cuello de botella de los despliegues manuales, la inconsistencia entre entornos y el miedo a desplegar; con CD, el despliegue se convierte en un proceso repetible y auditable.

### 5.6 Pipeline como código

**Pipeline como código** significa que la definición del pipeline (pasos, orden, condiciones, secrets) vive en archivos versionados en el propio repositorio (por ejemplo, workflows de GitHub Actions en `.github/workflows/`) en lugar de configurarse solo en la interfaz web de una herramienta.

**Para qué se usa**: Versionar junto al código cómo se construye, prueba y despliega la aplicación; revisar cambios del pipeline en pull requests; reproducir el mismo flujo en forks o en otros repos.

**Ventajas**: Revisión por pares del pipeline, historial de cambios, recuperación ante desastres, consistencia entre equipos y documentación implícita (el pipeline es la documentación del proceso de build y entrega).

**Qué problema resuelve**: Pipelines “mágicos” solo en la UI, difíciles de auditar o replicar; con pipeline como código, el proceso de entrega es transparente y modificable con el mismo flujo que el código de la aplicación.

### 5.7 GitHub Actions en este contexto

**GitHub Actions** es la plataforma de CI/CD integrada en GitHub. Permite definir workflows en YAML que se ejecutan en runners (máquinas virtuales o self-hosted) ante eventos como push, pull_request, release o schedule. Incluye un mercado de acciones reutilizables (checkout, Docker Buildx, login a AWS/ECR, etc.) que simplifican la escritura del pipeline.

**Para qué se usa en este lab**: Disparar la construcción de las imágenes de backend y frontend, autenticarse en AWS/ECR usando secrets, construir la imagen con Docker y subirla a ECR con un tag derivado del commit o del release.

**Ventajas**: Integración nativa con el repositorio, sin necesidad de un servidor de CI externo para empezar, y uso de secrets de GitHub para credenciales sin exponerlas en el código.

**Qué problema resuelve**: Automatizar el build y el push sin instalar ni mantener un Jenkins u otro servidor de CI; el pipeline vive donde vive el código y se ejecuta en la nube de GitHub.

### 5.8 Build multi-stage (construcción en etapas)

En un **Dockerfile multi-stage** se definen varias etapas (varias instrucciones `FROM`); cada etapa puede usar una imagen base distinta y solo el resultado de la última (o de la etapa que se copie al final) forma la imagen definitiva. Típicamente una etapa “build” instala compiladores y dependencias de desarrollo, compila la aplicación, y una etapa “runtime” solo recibe el binario o artefacto ya generado y la imagen base mínima para ejecutarlo.

**Para qué se usa**: En el backend de este lab se usa una etapa con .NET SDK para restaurar paquetes y publicar, y otra con la imagen `aspnet` que solo contiene el runtime; así la imagen final no incluye el SDK ni el código fuente, solo lo necesario para ejecutar.

**Ventajas**: Imagen final más pequeña (menor tiempo de pull y menor superficie de ataque), separación clara entre “entorno de compilación” y “entorno de ejecución”, y posibilidad de usar bases distintas (por ejemplo, Alpine para runtime) sin complicar el build.

**Qué problema resuelve**: Evitar que imágenes de producción arrastren compiladores, código fuente y dependencias de desarrollo; con multi-stage se obtiene una imagen mínima y más segura sin mantener dos Dockerfiles separados.

### 5.9 Tags e inmutabilidad de imágenes

Las imágenes en un registro se identifican por **nombre** (repositorio) y **tag** (por ejemplo `main-abc1234`, `v1.2.0`). Una misma imagen puede tener varios tags, pero un tag apunta a un digest concreto (hash del contenido); en la práctica, no se “sobrescribe” el contenido de una imagen ya publicada con el mismo tag si se sigue la buena práctica de usar tags únicos por build (por ejemplo, SHA del commit).

**Inmutabilidad** significa que una vez publicada, una imagen con un tag dado no cambia; un nuevo build genera una nueva imagen (nuevo digest) y, si se quiere, un nuevo tag. Así se garantiza trazabilidad: qué versión del código generó qué imagen.

**Para qué se usa**: En este lab el backend taggea con `ref_name-sha` (rama y commit) y el frontend con el SHA del release; en ECR cada push corresponde a una imagen identificable y reproducible.

**Ventajas**: Reproducibilidad de despliegues, rollback seguro (volver a una imagen anterior por tag), auditoría y cumplimiento (saber exactamente qué está en producción).

**Qué problema resuelve**: La ambigüedad de “la última versión” o “la que está en main”; con tags inmutables se sabe exactamente qué artefacto se desplegó y se puede volver atrás de forma controlada.

### 5.10 Gestión de secretos en CI

Las **credenciales** (claves AWS, tokens de registro, contraseñas) no deben estar en el código ni en los Dockerfiles. Los sistemas de CI (GitHub Actions, GitLab CI, Jenkins, etc.) ofrecen **secretos**: variables que se inyectan en el entorno del job en tiempo de ejecución y no se imprimen en los logs. El pipeline los usa para, por ejemplo, autenticarse en AWS o en un registro privado.

**Para qué se usa**: En este lab, `AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY` se configuran como GitHub Secrets; el workflow los recibe como variables de entorno solo en el runner que ejecuta el job, sin exponerlos en el historial del repositorio ni en la interfaz.

**Ventajas**: Cumplimiento de buenas prácticas de seguridad, principio de mínimo privilegio (solo el pipeline tiene acceso), y rotación de credenciales sin tocar el código del pipeline (solo se actualiza el valor del secreto).

**Qué problema resuelve**: Evitar que credenciales queden en el código, en historial de Git o en logs públicos; la gestión de secretos en CI centraliza el acceso y reduce el riesgo de filtración.

### 5.11 Capas y caché en imágenes Docker

Una **imagen Docker** está formada por **capas** read-only; cada instrucción del Dockerfile (COPY, RUN, etc.) puede generar una nueva capa. Las capas se reutilizan entre builds: si una instrucción no cambia, Docker usa la capa en caché y no la vuelve a ejecutar, lo que acelera builds posteriores.

El **orden de las instrucciones** importa: lo que cambia menos (por ejemplo, la copia de `package.json` y la instalación de dependencias) conviene ponerlo antes; lo que cambia más (copia del código fuente) después. Así, al modificar solo código, se reutilizan las capas de dependencias y el build es mucho más rápido.

**Para qué se usa**: En el frontend, primero se copian `package*.json` y se ejecuta `npm ci`, y después se copia el resto del código; en el backend, primero se copian los `.csproj` y se hace restore, y luego el código. Eso maximiza el uso de la caché en builds incrementales.

**Ventajas**: Builds más rápidos en desarrollo y en CI, menor uso de ancho de banda al hacer push (solo se suben capas nuevas si el registro soporta deduplicación), y Docker reutiliza capas entre imágenes que comparten base.

**Qué problema resuelve**: Builds lentos y repetitivos cuando solo cambia una parte del código; con capas y caché bien ordenadas, el tiempo de build se reduce y el pipeline escala mejor.

### 5.12 Docker Buildx y BuildKit

**Buildx** es la CLI moderna de Docker para construir imágenes; por defecto usa **BuildKit**, el motor de build que reemplaza al builder clásico. BuildKit permite construcciones en paralelo, caché más eficiente, soporte para multi-plataforma (por ejemplo, imágenes para ARM y x86) y características como secretos montados durante el build sin dejarlos en capas.

**Para qué se usa en este lab**: El workflow utiliza `docker/setup-buildx-action@v3` para configurar Buildx en el runner de GitHub Actions; así el `docker build` usa BuildKit y se aprovecha su rendimiento y compatibilidad con el resto del ecosistema.

**Ventajas**: Builds más rápidos, mejor uso de caché, y preparación para builds multi-plataforma si en el futuro se desplegara en arquitecturas distintas (por ejemplo, ARM en Graviton).

**Qué problema resuelve**: El builder clásico de Docker es más lento y con menos opciones; Buildx/BuildKit es el estándar actual y mejora la experiencia de build tanto local como en CI.

### 5.13 Artefacto binario vs. código fuente

El **código fuente** (repositorio Git) es lo que los desarrolladores editan; el **artefacto binario** (en este lab, la imagen Docker) es el resultado de compilar/empaquetar ese código para un entorno de ejecución. El registro de contenedores almacena artefactos binarios, no el código: es la “salida” del pipeline y la “entrada” para el despliegue.

**Para qué se usa**: En este lab el repositorio contiene el código; el pipeline produce imágenes y las sube a ECR. Quien despliegue (en labs posteriores, Kubernetes) consumirá la imagen desde ECR, sin necesidad de tener acceso al repo ni de volver a compilar.

**Ventajas**: Separación clara entre “dónde se desarrolla” y “qué se despliega”; el mismo código puede generar distintos artefactos (por rama, por entorno); los entornos de ejecución no necesitan compiladores ni acceso al código fuente.

**Qué problema resuelve**: Evitar compilar en el servidor de producción o depender del código fuente en tiempo de despliegue; el artefacto ya está listo, versionado y probado por el pipeline.

---

## 6. Conclusión

El Lab 1 cumple con lo establecido en la Solicitud del PI: se construyeron imágenes Docker de una aplicación (backend y frontend), se configuró un pipeline que automatiza la construcción y la subida a un registro de contenedores (Amazon ECR), y se sentaron las bases para los siguientes laboratorios (orquestación, IaC, monitoreo, feature flags y CI/CD completo).
