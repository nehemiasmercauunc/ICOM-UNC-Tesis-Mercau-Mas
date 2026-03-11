# Guía y consignas – Lab 1: Construcción de imágenes con Docker y automatización de push

**Destinatarios**: Alumnos de las materias vinculadas al Proyecto Integrador (ej. Ingeniería de Software, Gestión de la Calidad de Software).  
**Objetivo**: Construir una imagen Docker de una aplicación y configurar un pipeline que automatice su construcción y subida a un registro de contenedores (Docker Hub o Amazon ECR).

---

## 1. Guía para el alumno

### 1.1 Contexto

En este laboratorio trabajarás con **contenedores** y **pipelines de CI/CD**. Aprenderás a:

- Escribir un **Dockerfile** para empaquetar una aplicación.
- Construir la imagen localmente y probarla.
- Configurar un **registro de contenedores** (en este curso se usa Amazon ECR).
- Automatizar la construcción y la subida de la imagen mediante un **pipeline** (GitHub Actions).

No es necesario tener una aplicación compleja: puede ser una API mínima o una pequeña app web. Lo importante es que el flujo (código → imagen → registro) quede claro y automatizado.

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

1. Tener una aplicación que funcione localmente (backend y/o frontend).
2. Escribir el Dockerfile y verificar que `docker build` y `docker run` funcionen en tu entorno.
3. Crear un repositorio de imágenes en el registro (ECR o Docker Hub) y hacer push manual una vez para validar permisos.
4. Crear un workflow de GitHub Actions que, ante un push (o release), construya la imagen y la suba al registro.
5. Documentar brevemente lo realizado y entregar según las consignas más abajo.

---

## 2. Consignas (qué debe cumplir el alumno)

A continuación se listan las actividades que el alumno debe realizar para aprobar el Lab 1. Cada ítem puede evaluarse de forma independiente; el docente definirá los criterios de corrección (por ejemplo, revisión de código, ejecución del pipeline, revisión de informe).

### C1. Aplicación base

- **C1.1** Tener una aplicación ejecutable (por ejemplo, una API REST o una app web mínima). Puede ser en cualquier stack (Node, .NET, Python, etc.) acordado con el docente.
- **C1.2** La aplicación debe poder construirse y ejecutarse de forma repetible (por ejemplo, con un comando de build y un comando de inicio documentados).

### C2. Docker

- **C2.1** Escribir un Dockerfile que construya la imagen de la aplicación. Se valorará el uso de multi-stage build cuando reduzca el tamaño de la imagen final.
- **C2.2** Documentar cómo construir la imagen localmente (`docker build ...`) y cómo ejecutar el contenedor (`docker run ...`), incluyendo puertos y variables de entorno si aplica.
- **C2.3** Probar localmente que la imagen corre correctamente antes de integrarla al pipeline.

### C3. Registro de contenedores

- **C3.1** Crear (o tener acceso a) un repositorio en un registro de contenedores. En el marco del PI se usará Amazon ECR; si el docente lo permite, puede usarse Docker Hub u otro registro.
- **C3.2** Realizar al menos un push manual de la imagen al registro y verificar que la imagen aparezca en el repositorio con el tag utilizado.

### C4. Pipeline CI/CD

- **C4.1** Configurar un pipeline (por ejemplo, GitHub Actions) que se ejecute ante un evento definido (push a una rama, creación de un release, etc.).
- **C4.2** El pipeline debe: (a) hacer checkout del código, (b) construir la imagen Docker, (c) autenticarse contra el registro, (d) etiquetar la imagen (por ejemplo, con commit SHA o versión), (e) subir la imagen al registro.
- **C4.3** Las credenciales del registro no deben estar en el código; deben usarse secrets del entorno (por ejemplo, GitHub Secrets).

### C5. Documentación y entrega

- **C5.1** Incluir en el repositorio un README (o documento equivalente) que explique: objetivo del lab, cómo construir y ejecutar la aplicación con Docker, y cómo funciona el pipeline (evento que lo dispara, pasos principales).
- **C5.2** Entregar según lo indicado por el docente (enlace al repo, informe breve, o ambos). El informe debe describir qué se hizo y qué decisiones se tomaron (por ejemplo, por qué se eligió cierto base image o estrategia de tagging).

---

## 3. Entregables para los alumnos (definición formal)

Para que la evaluación sea clara y homogénea, se definen los entregables que el alumno debe presentar. El docente puede adaptar plazos y formato (por ejemplo, informe en PDF, entrega por campus, etc.).

| Entregable | Descripción | Formato sugerido |
|------------|-------------|-------------------|
| **Código fuente** | Repositorio con la aplicación, Dockerfile(s) y workflow del pipeline. | Repositorio Git (GitHub u otro) con acceso para el corrector. |
| **README (o doc. técnica)** | Instrucciones para clonar, construir la imagen, ejecutar el contenedor y entender el pipeline. | Archivo README.md en la raíz del repo (o en carpeta `docs/`). |
| **Informe breve** | Descripción de lo realizado: tecnologías, pasos del pipeline, decisiones de diseño (ej. multi-stage, tagging), y capturas o enlaces que muestren que el pipeline corrió y que la imagen está en el registro. | Documento (PDF o Markdown) subido al campus o enlazado desde el README. |

**Criterios de aceptación mínimos**

- El pipeline se ejecuta correctamente ante el evento configurado (evidencia: ejecución exitosa en la pestaña Actions de GitHub o equivalente).
- La imagen generada por el pipeline está disponible en el registro con el tag esperado (evidencia: captura o URL del repositorio en ECR/Docker Hub).
- El README permite a un corrector reproducir el build y el run local sin información adicional.

Con esto se cubren las tareas de la épica Lab 1 en términos de documentación para alumnos: guía de trabajo, consignas concretas y definición clara de entregables.
