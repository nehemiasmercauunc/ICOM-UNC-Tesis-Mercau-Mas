## Resumen

Este Proyecto Integrador propone una secuencia de **seis laboratorios técnicos** progresivos que articulan la formación en Ingeniería de Software y Gestión de la Calidad de Software con prácticas actuales de **DevOps**, **ingeniería de infraestructura** y **operación en la nube**, en línea con la **alianza entre la Universidad Nacional de Córdoba y Amazon Web Services (AWS)**. El trabajo no se limita a describir herramientas: busca que estudiantes y docentes dispongan de una experiencia ordenada, incremental y verificable que recorra el ciclo de vida de una aplicación moderna (desde el código hasta la observabilidad y el despliegue controlado), con énfasis en **automatización**, **calidad**, **seguridad**, **observabilidad**, **trazabilidad** y **trabajo colaborativo**.

En el **Laboratorio 1** se construyen imágenes **Docker** de backend y frontend, se automatiza la **integración continua** con **GitHub Actions**, pruebas y **SonarCloud**, y se publican artefactos en **Amazon ECR** con política de ramas y repositorios diferenciados. El **Laboratorio 2** despliega la misma aplicación en **Minikube** con manifiestos y **Helm**, **Ingress**, **HPA** (metrics-server) y validación de escalado mediante **JMeter** in-cluster. El **Laboratorio 3** provisiona en **AWS** —mediante **Terraform** y **Terragrunt**— **VPC**, **ECR** y **EKS** en entornos `dev` y `prd`, con **estado remoto en S3**. El **Laboratorio 4** extiende esa base con **observabilidad** (**Prometheus**, **Grafana**) instalada como **Helm dentro de IaC** (`kube-prometheus-stack`). Los **Laboratorios 5 y 6** permanecen definidos en la Solicitud del PI (**feature flags**, canary, pipeline integral y métricas **DORA**) como trabajo futuro del material docente.

Los **cuatro primeros laboratorios** cuentan con implementación de referencia, **informes finales**, guías, consignas y entregables. El PI funciona como **puente verificable** entre teoría académica y prácticas de industria en la nube, con progresión **local → AWS gestionada** y énfasis en automatización, calidad y observabilidad.

**Palabras clave**: DevOps, Cloud Computing, Programming, Engineering education, Amazon Web Services, Kubernetes.

---

## Índice general

*(Pendiente: completar al cerrar la numeración definitiva de secciones en la versión final exportada a PDF.)*

---

## Índice de figuras

- Figura 4.1 — Flujo Lab 1: PR, CI, publicación en ECR (§4.1.5)
- Figura 4.2 — Secuencia jobs GitHub Actions (§4.1.5)
- Figura 4.3 — Arquitectura Lab 2 en Minikube (§4.2.6)
- Figura 4.4 — Progresión manifiestos → Helm → Ingress (§4.2.6)
- Figura 4.5 — Secuencia JMeter, Service backend y HPA (§4.2.6)
- Figuras Lab 3 — Ver `arquitectura-lab3.mmd`, `jerarquia-terragrunt.mmd`, `red-vpc-2az.mmd`, `secuencia-despliegue.mmd`, `estado-remoto-bootstrap.mmd` (§4.3.5)
- Figuras Lab 4 — Ver `arquitectura-lab4.mmd`, `stack-observabilidad-lab4.mmd`, `jerarquia-terragrunt-lab4.mmd`, `secuencia-despliegue-lab4.mmd`, `red-vpc-eks-lab4.mmd` (§4.4.5)

*(Completar numeración global al exportar a PDF e insertar capturas marcadas en informes de lab.)*

---

## Índice de tablas

- Tabla 4.1 — Repositorios ECR por rama (§4.1.5)
- Tabla 4.2 — Cuatro pruebas de escalado HPA, Lab 2 (§4.2.6)
- Tabla 4.3 — NodePort vs Ingress, Lab 2 (§4.2.6)
- Tabla 4.4 — Comparativa dev/prd, Lab 3 (§4.3.5)
- Tabla 4.5 — Comparativa dev/prd, Lab 4 (§4.4.5)
- Tabla 2.1 — Estado de avance del PI (§2.7)
- Tabla 1.14.16 — Servicios AWS ↔ laboratorios (§1.14.16)

---

## Índice de extractos de código

*(Pendiente.)*

---

## Índice de siglas y acrónimos


| Sigla  | Significado                                                         |
| ------ | ------------------------------------------------------------------- |
| AWS    | Amazon Web Services                                                 |
| CD     | Continuous Delivery / Continuous Deployment (según contexto)        |
| CI     | Continuous Integration                                              |
| CI/CD  | Integración y entrega/despliegue continuos                          |
| CRUD   | Create, Read, Update, Delete                                        |
| DORA   | DevOps Research and Assessment (métricas de rendimiento de equipos) |
| ECR    | Amazon Elastic Container Registry                                   |
| EKS    | Amazon Elastic Kubernetes Service                                   |
| IaC    | Infrastructure as Code                                              |
| IAM    | Identity and Access Management (AWS)                                |
| IoC    | Inversión de control (contexto .NET)                                |
| K8s    | Kubernetes                                                          |
| MTBF   | Mean Time Between Failures                                          |
| MTTR   | Mean Time To Restore / Repair                                       |
| MVC    | Model–View–Controller (patrón arquitectónico)                       |
| PI     | Proyecto Integrador                                                 |
| PR     | Pull Request                                                        |
| REST   | Representational State Transfer                                     |
| SAST   | Static Application Security Testing                                 |
| SPA    | Single Page Application                                             |
| SRE    | Site Reliability Engineering                                        |
| YAML   | YAML Ain’t Markup Language                                          |
| STS    | AWS Security Token Service                                          |
| CNI    | Container Network Interface                                         |
| PDB    | PodDisruptionBudget                                                 |
| HPA    | Horizontal Pod Autoscaler                                           |
| PVC    | PersistentVolumeClaim                                               |
| CSI    | Container Storage Interface                                         |
| KMS    | AWS Key Management Service                                          |
| OIDC   | OpenID Connect                                                      |
| VPC    | Virtual Private Cloud (AWS)                                         |
| AZ     | Availability Zone                                                   |
| ENI    | Elastic Network Interface                                           |
| ASG    | Auto Scaling Group                                                  |
| TSDB   | Time Series Database (Prometheus)                                   |
| PromQL | Prometheus Query Language                                           |
| SNS    | Amazon Simple Notification Service                                  |
| RPS    | Requests per second (peticiones por segundo)                        |
| VU     | Virtual user (usuario virtual, en JMeter)                           |
| JTL    | JMeter text log (resultados de prueba)                              |
| JMX    | Archivo de plan de prueba de JMeter                                 |


---

# 1. Marco teórico

## 1.1 Introducción al marco

Este capítulo presenta los conceptos que permiten situar el Proyecto Integrador en el estado actual de la industria del software y de la operación de sistemas en la nube. El marco no pretende ser un manual de productos: busca ofrecer definiciones estables, relaciones entre ideas (por ejemplo, entre integración continua, registros de imágenes y orquestación) y un vocabulario común para los capítulos posteriores, donde se describirán las decisiones concretas adoptadas en cada laboratorio.

La propuesta del trabajo —seis laboratorios que van desde la **containerización** y el **pipeline** hasta **observabilidad**, **feature flags** y **despliegues progresivos**— exige integrar perspectivas que tradicionalmente estaban fragmentadas: desarrollo, calidad, seguridad y operaciones. El marco recorre esas capas en un orden que sigue en lo posible la progresión pedagógica: primero flujo de código y automatización cercana al desarrollador (Git, GitHub Actions, Docker, **Amazon ECR** como primera interfaz práctica con AWS en el Laboratorio 1), luego la aplicación como API y cliente web (REST, .NET, React), después calidad y seguridad en el pipeline, seguido de **Kubernetes**, **Helm** e **infraestructura como código** (Terraform, Terragrunt). Las herramientas de observabilidad, secretos y release progresivo se desarrollan antes de cerrar el capítulo con la **sección 1.14**, dedicada de manera exclusiva al **ecosistema Amazon Web Services** que el PI utiliza en los **Laboratorios 1–4** (IAM, ECR, VPC, EKS, S3 para estado de Terraform, KMS donde aplica cifrado, etc.), admitiendo solapamiento deliberado con apartados anteriores para que el lector disponga de un capítulo de consulta único sobre AWS.

El lector encontrará **definiciones**, pero también **criterios**: cuándo usar un tag inmutable frente a `latest`, por qué separar repositorios ECR por línea de código, cómo interpretar un gate de calidad sin convertirlo en obstáculo pedagógico. Esta combinación refleja la naturaleza dual del PI: es simultáneamente un **artefacto de ingeniería** y una **propuesta didáctica** sometida a restricciones de tiempo, costo y nivel previo del estudiante.

Por último, el marco establece un léxico común con la bibliografía y la documentación oficial: cuando más adelante se cite **IAM**, **Helm** o **Canary**, las definiciones no saltarán sin red desde el índice de siglas. Esto reduce ambigüedad cuando varios autores (o varios laboratorios redactados en distintos meses) convergen en un único informe final.

## 1.2 DevOps, ingeniería continua y cultura

**DevOps** nombra un conjunto de prácticas culturales y técnicas orientadas a reducir el tiempo entre una idea de negocio y su despliegue seguro en producción, eliminando silos entre “desarrollo” y “operaciones”. No es un cargo ni un único producto: es una forma de trabajar donde el código se integra con frecuencia, donde los entornos son reproducibles y donde la retroalimentación de producción vuelve al equipo de desarrollo de manera sistemática.

Los pilares **CAMS** —**Culture**, **Automation**, **Measurement**, **Sharing**— siguen siendo un marco pedagógico útil: cultura colaborativa antes que herramienta nueva; automatización que elimina trabajo repetido pero que debe mantenerse legible; medición basada en métricas accionables (logs, métricas, trazas); compartir conocimiento mediante documentación viviente y postmortems sin culpas cuando algo falla en laboratorio o en demo docente.

La **Integración continua (CI)** consiste en integrar cambios de código en una línea principal compartida de manera frecuente, validando cada integración con compilación automatizada y pruebas. Su objetivo central es detectar fallos de forma temprana, cuando son más baratos de corregir. La **Entrega continua (Continuous Delivery)** extiende la CI garantizando que el software pueda liberarse a producción en cualquier momento: cada cambio que pasa las validaciones queda empaquetado como artefacto desplegable y pendiente de decisión de negocio o política de release. La **Implementación continua (Continuous Deployment)** va un paso más allá y despliega automáticamente a producción cada cambio que supera las barreras de calidad; no todos los equipos la adoptan, porque exige disciplina extrema en pruebas y observabilidad.

En este PI, el **Laboratorio 1** materializa CI al ejecutar build, pruebas y análisis estático en **GitHub Actions**, y materializa entrega continua en el sentido de **publicar imágenes** en **Amazon ECR** como artefactos versionados listos para consumo por entornos posteriores. El despliegue automático completo en un clúster productivo se profundiza en laboratorios siguientes.

Las **métricas DORA** (DevOps Research and Assessment) miden el rendimiento de equipos de entrega de software mediante cuatro indicadores clave: **frecuencia de despliegue**, **tiempo de entrega de cambios**, **tiempo medio de recuperación (MTTR)** ante incidentes y **tasa de fallos en cambios**. No son fines en sí mismos: sirven para reflexionar sobre cuánto tarda el sistema en aprender de la producción y cuánto cuesta fallar. El **Laboratorio 6**, según la propuesta del PI, vuelve sobre estas ideas al relacionar prácticas de pipeline y observabilidad con indicadores operativos.

Desglosando brevemente las cuatro métricas DORA: la **frecuencia de despliegue** mide con qué ritmo el equipo pone cambios en manos de usuarios (desde “menos de una vez al año” hasta “on-demand”). El **tiempo de entrega de cambios** captura el lapso entre commit y despliegue exitoso en producción; equipos de alto rendimiento lo reducen mediante automatización y tests confiables. El **tiempo medio de restauración** resume la velocidad con la que se detecta y corrige una falla en producción; está íntimamente ligado a observabilidad, rollbacks y prácticas de incident response. La **tasa de fallos en cambios** equilibra velocidad y seguridad: no basta desplegar rápido si cada release introduce incidentes. El PI utiliza estas métricas como **lente interpretativa**, no como cuotas obligatorias: en un contexto académico, el valor está en comprender qué prácticas las mejoran (pipelines repetibles, feature flags, monitoreo) cuando el proyecto avanza hacia el Laboratorio 6.

El contraste entre **Continuous Delivery** y **Continuous Deployment** es pedagógicamente útil: entrega continua mantiene el software “liberable” en todo momento, pero puede requerir aprobación humana para el último paso; implementación continua elimina esa puerta para cambios que pasan políticas automáticas. En este trabajo, el Laboratorio 1 se ubica en la zona de **integración y empaquetado continuo** más **entrega de artefactos** al registro; los laboratorios posteriores acercan el diseño a políticas de promoción entre entornos que se estudian al implementar Terraform, EKS y despliegues canary.

## 1.3 Educación y metodología del proyecto

El enfoque pedagógico del PI se alinea con principios de **aprendizaje basado en proyectos** y de **complejidad creciente**: cada laboratorio agrega una capa de realismo sin invalidar la anterior. Los estudiantes trabajan sobre un mismo hilo conductor —una aplicación tipo **Device Manager** con API y cliente web— que evoluciona de “artefacto construido y publicado” a “carga desplegada en un clúster”, y más adelante a “infraestructura y operación medibles”. Esta progresión busca **aprendizaje significativo**: las herramientas no aparecen como fines aislados sino como respuestas a problemas concretos (repetibilidad, escalabilidad, seguridad, visibilidad).

La documentación por laboratorio (guías, consignas, informes) cumple un rol doble: es **instrumento de evaluación** y **artefacto de metacognición**, porque obliga a explicitar decisiones, trade-offs y límites del modelo educativo (por ejemplo, costos de nube, permisos IAM mínimos o entornos compartidos). El marco teórico aquí presentado da soporte a esa escritura técnica: proporciona definiciones comunes que evitan ambigüedades cuando varios equipos documentan en paralelo.

Las **retrospectivas** al cierre de cada laboratorio —aunque no siempre formalizadas en actas— son el espacio donde estudiantes verbalizan impedimentos (“no pudimos ver la imagen en ECR”, “el Ingress no enrutaba”) que el marco teórico ayuda a clasificar: ¿falló herramienta, configuración o modelo mental? Separar esas causas evita atribuir errores exclusivamente a la complejidad de Kubernetes cuando en realidad faltó trazabilidad en los tags o límites mal definidos.

Desde el punto de vista **ético y de seguridad**, el PI introduce prácticas responsables (secretos, menor privilegio) como hábito, no como checklist: documentar credenciales mal ubicadas es tan importante como celebrar pipelines verdes. Esta tensión entre velocidad y cautela es inherente a DevOps moderno y merece espacio explícito en el marco.

## 1.4 Control de versiones y colaboración con Git

**Git** es un sistema de control de versiones distribuido: cada clon del repositorio contiene el historial completo, lo que permite ramificar, experimentar y fusionar cambios con trazabilidad. Conceptos esenciales incluyen **commits** (instantáneas del proyecto), **ramas** (líneas de trabajo paralelas), **merge** (fusión de historiales) y **remotes** (repositorios compartidos en plataformas como GitHub).

En proyectos colaborativos, el flujo típico combina ramas de corta vida con **pull requests (PR)**: un desarrollador propone cambios, el equipo revisa el diff, discute y solo entonces integra a ramas compartidas como `develop` o `main`. Esto habilita revisión de código, discusión de diseño y ejecución automática de pipelines asociados al evento `pull_request`.

Las **reglas de protección de ramas** en GitHub (configuración del repositorio, no del workflow) permiten prohibir pushes directos y exigir revisión o CI verde antes del merge. En los repositorios de este PI, la política de trabajo acordada se documenta explícitamente en los flujos de GitHub Actions: **no se asume push directo a `develop` ni a `main`; la integración ocurre mediante PR**. La disciplina del equipo y la configuración del repositorio deben alinearse para que esa política sea efectiva en la práctica.

Los equipos también deben acordar si prefieren **merge commits**, **squash** o **rebase** al integrar PRs: cada opción altera el historial visible (`git log`) y la facilidad de **bisect** ante regresiones. No hay única respuesta universal; sí hay consistencia como virtud. Para proyectos estudiantiles cortos, squash con mensaje estandarizado suele simplificar la lectura posterior del historial.

El archivo `.gitignore` forma parte del **contrato** entre repositorio y pipeline: lo que no está versionado no forma parte del artefacto reproducible.

## 1.5 GitHub Actions y pipeline como código

**GitHub Actions** es la plataforma de automatización integrada en GitHub. Un **workflow** es un archivo YAML versionado (habitualmente bajo `.github/workflows/`) que define **eventos** (`push`, `pull_request`, `release`, etc.), **jobs** (unidades de trabajo que pueden ejecutarse en paralelo) y **steps** (pasos secuenciales dentro de un job). Cada job corre en un **runner** (máquina virtual hospedada por GitHub o instalada en infra propia en modo self-hosted).

El diseño “**pipeline como código**” implica que la definición del proceso de build, test y entrega vive en el mismo repositorio que la aplicación: cambios al pipeline son revisables en PR y tienen historial. Los **secrets** almacenan credenciales (por ejemplo claves AWS o tokens de SonarCloud) fuera del código fuente; los workflows las inyectan como variables de entorno en tiempo de ejecución.

En los repositorios `device-manager-api` y `device-manager-app`, el pipeline se estructura en jobs de **CI** (pruebas y SonarCloud) y **build-and-push** (construcción Docker y publicación en ECR). El job de despliegue de imagen depende del éxito del CI (`needs: ci`), de modo que no se publica un binario que no haya pasado las validaciones configuradas.

Los **runners hospedados** (`ubuntu-latest`) abstraen mantenimiento de agentes; para cargas muy específicas podría evaluarse self-hosted, pero no es requisito del Laboratorio 1.

El uso de **permisos mínimos** (`permissions: contents: read` en los workflows del PI) reduce la superficie si una acción de terceros estuviera comprometida; los jobs que necesitan escribir releases elevan permisos sólo donde corresponde (por ejemplo `contents: write` en el job de release del backend). Es una muestra de **hardening** aplicado al pipeline mismo.

Los eventos `pull_request` y `push` permiten ejecutar el mismo conjunto de validaciones antes y después del merge: así el feedback llega temprano en la discusión del PR y se vuelve a verificar al integrar a la rama destino. La condición `if` en jobs posteriores evita publicar imágenes en escenarios que no correspondan (por ejemplo, builds desde PR sin push a `develop`/`main` para el job de ECR).

## 1.6 Contenedores y Docker

Un **contenedor** agrupa una aplicación y sus dependencias en un entorno aislado lógico sobre el kernel del sistema operativo host. A diferencia de una máquina virtual completa, los contenedores comparten el kernel, lo que los hace más livianos y rápidos de iniciar. Tecnologías de aislamiento en Linux incluyen **namespaces** y **cgroups** (control de recursos).

**Docker** popularizó el formato de imagen basado en capas y la interfaz de línea de comandos para **build**, **run** y distribución. Una **imagen** es una plantilla inmutable compuesta de capas; un **contenedor** es una instancia ejecutable de esa imagen. El archivo **Dockerfile** declara instrucciones (`FROM`, `COPY`, `RUN`, etc.); cada instrucción puede generar una capa reutilizable mediante **caché**, siempre que el orden optimice lo que cambia poco (dependencias) antes de lo que cambia mucho (código).

Los **Dockerfile multi-stage** definen varias etapas `FROM`: una etapa compila o empaqueta con herramientas pesadas (SDK de .NET, Node para build) y la etapa final copia solo el artefacto necesario sobre una imagen mínima de runtime (por ejemplo `aspnet` para .NET o una imagen con `serve` para estáticos). Así se reduce tamaño, superficie de ataque y tiempo de transferencia hacia el registro.

**BuildKit** y **docker buildx** son el motor de construcción moderno: mejor paralelismo de pasos, caché avanzada y soporte para construcción multi-plataforma. Los workflows del PI configuran **Docker Buildx** explícitamente antes del `docker build`.

Buenas prácticas de seguridad incluyen minimizar paquetes en la imagen final, no incrustar secretos en capas, y ejecutar procesos con usuario sin privilegios cuando la imagen base lo permite.

El estándar **OCI** (Open Container Initiative) define formatos de imagen y runtime interoperables; Docker los popularizó pero hoy **containerd**, **CRI-O** y Kubernetes consumen imágenes OCI compatibles. Esta neutralidad es lo que permite construir una vez en GitHub Actions y ejecutar igual en un laptop con Docker Desktop, en un nodo Linux del clúster o en un servicio administrado.

El modelo de red por defecto en Docker expone puertos del contenedor al host (`-p host:container`); en producción encadenado con orquestadores, la red se vuelve más rica (overlay, políticas). Para el Laboratorio 1 basta internalizar que la imagen **declara** puertos y salud esperada; el Laboratorio 2 traduce eso a **Probes** y **Services** en Kubernetes.

Además de Dockerfile, muchos proyectos usan **Compose** para levantar backend + base en desarrollo; no es requisito del pipeline del PI si cada servicio publica su propia imagen hacia ECR, pero los estudiantes pueden encontrar Compose en talleres auxiliares. La distinción importante es que **Compose orquesta contenedores en un host** para desarrollo, mientras **Kubernetes orquesta contenedores en un clúster** con semántica distinta de escalado y redes.

## 1.7 Registro de contenedores y Amazon ECR

### 1.7.1 Rol del registro en la cadena CI/CD

Un **registro de contenedores** es el sistema de “paquetes binarios” para imágenes OCI/Docker: almacena **manifiestos** y **capas** (blobs) direccionables por contenido. Los clientes autenticados realizan **push** (publicar) y **pull** (consumir). La tripleta habitual es `registry/repositorio:tag`, pero la identidad fuerte de una imagen es el **digest** `sha256:…`, que referencia un manifiesto inmutable aunque varios tags apunten al mismo digest o se muevan tags entre builds.

*-Diagrama sugerido: flujo CI → `docker push` → registro → `kubectl`/nodo hace `pull` → container runtime desempaqueta capas → Pod en ejecución.-*

En el Laboratorio 1, el registro es el **primer punto de contacto sistemático de los alumnos con AWS**: antes de desplegar clusters o redes, ya deben comprender identidad (IAM), permisos mínimos, región y el contrato “mi pipeline escribe artefactos que otro actor leerá después”. Esa intuición prepara EKS (Laboratorios 3–4), donde los nodos del clúster consumen las mismas imágenes desde ECR con políticas distintas.

### 1.7.2 Amazon ECR: propuesta de valor y componentes

**Amazon Elastic Container Registry (ECR)** es el servicio gestionado de AWS para alojar imágenes de contenedor. Expone API compatible con Docker CLI y con los estándares OCI; internamente persiste capas en **Amazon S3** de forma opaca para el usuario, con **cifrado en reposo** (por defecto mediante **AWS KMS**, ya sea clave administrada por AWS o propia).

ECR se presenta en dos sabores pedagógicamente relevantes:

- **ECR privado**: por cuenta/región; típicamente integrado a VPC mediante **VPC endpoints** (interface/gateway) cuando se exige tráfico sin salida a Internet pública. Es el estándar corporativo.
- **Amazon ECR Public Gallery / registros públicos**: permite publicar imágenes consumibles sin autenticación para lectura (similar en espíritu a Docker Hub público). El PI actual usa autenticación contra **registro público** según los workflows (`registry-type: public` en `amazon-ecr-login`), lo cual simplifica laboratorios pero debe documentarse: los permisos IAM siguen siendo necesarios para **push**, y la imagen es visible según la configuración del repositorio público.

*-Imagen sugerida: captura de la consola AWS ECR mostrando un repositorio con tags `latest` y `develop-<sha>`.-*

En ECR, un **repositorio** agrupa imágenes de un mismo proyecto (por ejemplo `tp1-backend` vs `tp1-backend-prd`). Convenciones de nombres separando integración y producción reducen errores humanos al promover artefactos.

### 1.7.3 Autenticación, IAM y políticas típicas

La CLI de Docker no “conoce” AWS por sí misma: el paso previo es obtener credenciales temporas del registro. El patrón oficial es `**aws ecr get-login-password`** (o equivalente para público) piped a `docker login`. En GitHub Actions esto se encapsula en la acción `**aws-actions/amazon-ecr-login**`, que exporta el **registry endpoint** para etiquetar correctamente (`docker tag` / `docker push`).

Los permisos IAM se expresan como políticas JSON sobre acciones como `ecr:GetAuthorizationToken`, `ecr:BatchCheckLayerAvailability`, `ecr:PutImage`, `ecr:InitiateLayerUpload`, `ecr:UploadLayerPart`, `ecr:CompleteLayerUpload`, `ecr:BatchGetImage`. Para CI de solo publicación, suele acotarse el recurso `arn:aws:ecr:region:account:repository/nombre` y no otorgar `ecr:*` global.

*-Diagrama sugerido: matriz “actor” (usuario IAM de CI, rol de nodo EKS) × “acción” (push vs pull) × repositorio ECR destino.-*

En los **Laboratorios 1–4**, GitHub Actions autentica con **access keys** almacenadas en **GitHub Secrets** (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`), acotadas por políticas IAM mínimas de push a ECR.

### 1.7.4 Tags, digest, inmutabilidad y políticas de ciclo de vida

El **tag** es puntero mutable salvo políticas explícitas: conviene combinar **tags inmutables por commit** (`main-abc1234`) con políticas de **retención** (lifecycle policies) que purguen imágenes antiguas y controlen costo de almacenamiento. **Tag immutability** a nivel de repositorio impide sobrescribir un tag existente —útil para `release-x.y.z`.

El **digest** permite auditar exactamente qué manifiesto desplegó Kubernetes (`imageID` en el Pod status). Cuando un incidente ocurre, correlacionar digest ↔ commit ↔ build CI es la trazabilidad buscada por DevOps.

### 1.7.5 Escaneo de imágenes

En los **Laboratorios 3 y 4**, el módulo ECR habilita **`scan_on_push`** para análisis básico de vulnerabilidades al publicar capas. El Laboratorio 1 no exige escaneo de imagen como entregable; la calidad de código se cubre con **SonarCloud** en CI.

### 1.7.6 Estrategia del PI: ramas y repositorios ECR

La separación **develop vs main** se materializa con **repositorios ECR distintos** (p. ej. sufijo `-prd`), no solo tags distintos en un único repositorio. Ventajas: permisos IAM distintos (solo entorno prod puede pull del repo `-prd`), menor riesgo de promover por error una imagen experimental, claridad operativa para alumnos.

Cada push exitoso publica `ref_name-SHA` y `**latest`** en **ese** repositorio. Así `latest` significa “último build verde de esa línea”, no global.

*-Diagrama sugerido: dos columnas (repo DEV / repo PRD) mostrando de qué rama Git entra cada pipeline.-*

### 1.7.7 Relación ECR ↔ Kubernetes (anticipo teórico)

Los nodos de un clúster (Laboratorio 2 en adelante) deben poder hacer **pull** si el `imagePullSecrets` o el rol del nodo lo permiten. En **Minikube (Lab 2)** se usan credenciales de registro vía secretos de Kubernetes; en **EKS (Labs 3–4)** el pull desde ECR se resuelve con permisos del **node group** sobre el repositorio. Comprender ECR en Lab 1 evita confundir “mi imagen existe” con “el kubelet tiene derecho a descargarla”.

> **Nota:** Una exposición sistemática de cada servicio AWS —incluida una segunda capa de detalle sobre ECR dentro del mapa de servicios— se desarrolla en la **sección 1.14** de este mismo capítulo.

## 1.8 Puente hacia el ecosistema AWS

La nube de AWS se introduce en el Laboratorio 1 principalmente a través de **ECR** e **IAM** (credenciales usadas por GitHub Actions). Las dimensiones de **regiones**, **cuentas**, **VPC**, **EKS**, **S3** para estado de Terraform y servicios asociados a los Labs 1–4 se tratan en la **sección 1.14 — Marco teórico consolidado de Amazon Web Services**, para no fragmentar la teoría entre este apartado y los laboratorios posteriores. El presente apartado solo recuerda tres ideas transversales:

1. **Modelo de responsabilidad compartida**: AWS opera la infraestructura física y los servicios gestionados; el cliente configura correctamente IAM, redes y datos —los errores de permisos en ECR son responsabilidad del diseño de políticas, no “fallos del servicio”.
2. **Todo es API**: incluso la consola web invoca las mismas APIs; Terraform y los pipelines solo automatizan esas llamadas.
3. **Menor privilegio**: cada laboratorio amplía permisos sólo cuando la actividad lo exige (push ECR antes que `AdministratorAccess`).

## 1.9 API REST y arquitectura de la aplicación empleada en los labs

Una API **REST** modela recursos identificados por URLs y métodos HTTP (`GET`, `POST`, `PUT`, `DELETE`). Las respuestas usan códigos de estado estándar y formatos como JSON. Una especificación **OpenAPI** puede documentar contratos entre frontend y backend; facilita mocks y pruebas de contrato.

El backend del proyecto está desarrollado en **.NET** (**ASP.NET Core**) siguiendo una separación por capas habitual en aplicaciones empresariales: **Web** (controladores, configuración HTTP), **Business** (reglas y casos de uso) y **Data** (acceso a datos y repositorios). Este esquema reduce el acoplamiento y facilita pruebas unitarias sobre servicios.

El frontend es una **SPA** con **React 18**, empaquetada con **Vite** y componentes **Material UI (MUI)**. El build genera activos estáticos servidos por un contenedor liviano; las variables de entorno necesarias en tiempo de ejecución pueden inyectarse mediante scripts de entrada sin reconstruir la imagen para cada entorno.

En el backend, la inyección de dependencias del host **ASP.NET Core** permite sustituir implementaciones de repositorio en pruebas unitarias; en el frontend, **React Testing Library** favorece pruebas cercanas al uso real del usuario. Estos detalles refuerzan la idea de que “calidad” no es un paso final sino una propiedad que se diseña en la arquitectura.

## 1.10 Calidad y seguridad en el pipeline

La **pirámide de pruebas** sugiere muchas pruebas rápidas y aisladas en la base (unitarias), menos pruebas de integración en medio, y pocas pruebas end-to-end lentas en la cima. Automatizar pruebas en CI provee una red de seguridad repetible.

En el backend del PI, el workflow ejecuta `dotnet test` con recolección de cobertura en formato **OpenCover** compatible con el análisis. En el frontend, se ejecuta el script de tests con cobertura (`npm run test:coverage`) generando **lcov** para integración con SonarCloud.

**SonarCloud** (SaaS asociado al ecosistema SonarQube) realiza **análisis estático** de calidad y seguridad sobre el código. El backend usa **SonarScanner for .NET** entre pasos `begin`/`end` envolviendo build y tests; el frontend usa la acción oficial **SonarSource/sonarcloud-github-action**. Los tokens y claves de proyecto deben residir en **secrets** y **variables** de GitHub, no en el repositorio.

La gestión de **secretos** en CI (GitHub Secrets para AWS y Sonar) es parte de **DevSecOps**: secretos fuera del código, rotación posible sin cambiar fuentes, y permisos mínimos en IAM.

SonarCloud/SonarQube introducen conceptos como **quality gates**: umbrales de cobertura, duplicación, issues bloqueantes o vulnerabilidades que deben cumplirse para considerar “aprobado” un análisis. Configurar gates exige equilibrio: umbrales demasiado laxos no cambian hábitos; demasiado estrictos en proyectos nuevos frustran. En un PI, los gates pueden evolucionar laboratorio a laboratorio.

La correlación entre **cobertura de tests** y calidad real no es automática: una suite débil puede cubrir líneas sin afirmar comportamiento. Por eso el marco del PI insiste en combinar métricas con revisiones humanas y, cuando sea posible, pruebas de integración sobre la API.

En seguridad aplicada a APIs web, el OWASP **API Security Top 10** advierte fallos como objetos expuestos sin autorización, autorización a nivel de función insuficiente o límites de tasa inexistentes. El Laboratorio 1 no sustituye una revisión de modelo de amenazas formal, pero sí puede incluir pruebas automatizadas que detecten regresiones obvias de rutas sensibles y prácticas seguras de configuración (cabeceras, CORS razonable cuando aplique).

La cadena de suministro moderna exige mirar **dependencias**: herramientas como `dotnet list package --vulnerable`, auditorías `npm audit` o escaneos en CI sobre lockfiles reducen sorpresas al construir imágenes. El concepto de **SBOM** (Software Bill of Materials) —lista explícita de componentes de una imagen o aplicación— gana relevancia regulatoria y contractual; para el PI basta introducir la idea: saber “qué librerías entraron” en cada release.

Finalmente, **Secret Scanning** en GitHub puede impedir que claves API reaparezcan commits históricos; complementa la política humana de no copiar secretos en README salvo placeholders.

## 1.11 Kubernetes — marco ampliado

**Kubernetes (K8s)** es un sistema de orquestación **declarativo**: el usuario describe el *estado deseado* (cuántas réplicas, qué imagen, qué puertos, qué volúmenes) y los controladores del plano de control trabajan continuamente para reconciliar el estado real del clúster con ese objetivo. Está inspirado en los sistemas distribuidos de Google (Borg) y donado a la **CNCF**; su API estabilizada permite que proveedores cloud (EKS, GKE, AKS) y distribuciones on-premise ofrezcan la misma superficie de objetos.

*-Diagrama sugerido: bloques “Control Plane” (API server, etcd, scheduler, controller-manager) vs “Data Plane / Workers” (kubelet, kube-proxy, container runtime).-*

### 1.11.1 Definición de clúster y diferencias con “la nube” o “local”

Un **clúster Kubernetes** es un conjunto de máquinas (**nodos**) que ejecutan cargas de trabajo en contenedores y comparten una API centralizada. No es sinónimo de “AWS”: puede existir **localmente** (desarrollo), **en VMs propias** o **como servicio gestionado** (p. ej. Amazon EKS).


| Entorno         | Ejemplos típicos                                               | Uso pedagógico en el PI                                                                 |
| --------------- | -------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| Local ligero    | **minikube**                                                   | Laboratorio 2 en laptops; rápido de resetear; Ingress nginx; sin balanceador cloud.     |
| Nube gestionada | **Amazon EKS**                                                 | Laboratorios 3–4; VPC real; costo y curva de aprendizaje mayores.                       |
| Híbrido         | Cluster on-prem + nodos cloud                                  | Fuera del alcance inicial del PI.                                                       |


**Diferencia clave:** “Correr contenedores en la nube” puede significar **ECS**, **EC2 + Docker**, **Lambda**, etc.; **Kubernetes impone un modelo común** de Pods, Services y despliegues. La nube provee **infraestructura elástica**; Kubernetes provee **semántica de orquestación** sobre esa infraestructura.

*-Diagrama sugerido: tres columnas — Máquina única con Docker; Clúster K8s local de 1 nodo (Minikube); EKS multi-AZ con node groups en subnets privadas.-*

### 1.11.2 Plano de control y nodos trabajadores

El **plano de control** conserva el estado del sistema en **etcd** (almacén clave-valor distribuido), expone la **API** mediante `kube-apiserver`, asigna Pods a nodos mediante el **scheduler**, y ejecuta **controladores** que crean réplicas, endpoints, cuentas de servicio, etc.

Los **nodos worker** ejecutan **kubelet** (agente que arranca Pods hablando con el runtime), **kube-proxy** (reglas de red / iptables o IPVS hacia Services) y un **container runtime** compatible con CRI (**containerd** es el estándar actual).

Si el plano de control cae en un cluster auto-gestionado, el cluster deja de reconciliar estado; en **EKS**, AWS opera el plano de control y el usuario gestiona **node groups** (EC2) —como en los Labs 3–4.

### 1.11.3 Pods, cargas de trabajo y estrategias de despliegue

**Pod**: unidad mínima desplegable; puede contener varios contenedores **compartiendo network namespace** (localhost entre ellos) y volúmenes **emptyDir**. Los contenedores del mismo Pod se diseñan para convivencia estrecha (sidecar de proxy, agente de métricas).

Objetos de carga de trabajo:

- **ReplicaSet**: garantiza *n* réplicas de un Pod; rara vez se usa directamente.
- **Deployment**: envuelve ReplicaSets y añade **estrategias de actualización** (`RollingUpdate` por defecto, `Recreate`). Es el objeto más común para aplicaciones **stateless**.
- **StatefulSet**: identidades estables, orden de creación, almacenamiento por réplica —bases de datos con réplicas.
- **DaemonSet**: un Pod por nodo —agentes de observabilidad, CNI plugins.
- **Job / CronJob**: trabajo batch finito o programado.

**Estrategias de despliegue (conceptual):**

- **Rolling update** (nativa en Deployment): sustituye Pods gradualmente; configurable `maxSurge` / `maxUnavailable`.
- **Recreate**: baja todas las réplicas antes de subir nuevas —downtime corto.
- **Blue/Green**: dos entornos completos; el switch es cambiar el Service selector o Ingress; requiere disciplina de recursos.
- **Canary**: una fracción del tráfico va a la nueva versión; en Kubernetes puede implementarse con **múltiples Deployments + Service weights**, Ingress avanzado, o service mesh —el Laboratorio 5 profundiza junto con feature flags.

*-Diagrama sugerido: secuencia temporal Rolling vs Canary vs Blue/Green.-*

### 1.11.4 Services: ClusterIP, NodePort, LoadBalancer y ExternalName

Un **Service** agrupa Pods mediante **labels/selectors** y provee una IP virtual **ClusterIP** estable.


| Tipo             | Comportamiento típico                                            | Cuándo usarlo                                                              |
| ---------------- | ---------------------------------------------------------------- | -------------------------------------------------------------------------- |
| **ClusterIP**    | VIP solo dentro del clúster                                      | Microservicios internos.                                                   |
| **NodePort**     | Abre `30000-32767` en todos los nodos que forward-ean al Service | Laboratorios sin LB cloud; demos rápidas; expone por IP del nodo + puerto. |
| **ExternalName** | CNAME DNS                                                        | Integración con servicios externos.                                        |


**Headless Service** (`clusterIP: None`): sin VIP; DNS devuelve IPs de Pods —útil para StatefulSets y descubrimiento peer-to-peer.

### 1.11.5 Ingress y diferencia con Service

Un **Ingress** describe reglas **HTTP/HTTPS** (host, path, TLS). No hace nada solo: requiere un **Ingress Controller**. En el **Laboratorio 2** se usa el addon **Ingress nginx** de Minikube con host `app.local` y rutas hacia Services **ClusterIP**. Mientras un **Service** suele ser capa **L4** (TCP/UDP), Ingress opera **L7** (ruteo HTTP).

*-Arquitectura del Lab 2: cliente → Ingress nginx → Service ClusterIP → Pods.-*

### 1.11.6 Imagen de contenedor en Kubernetes y relación con ECR

El campo `spec.containers[].image` referencia la misma cadena que Docker (`registry/repo:tag`). Para **ECR**, el nodo debe poder hacer pull: en Lab 2 mediante `imagePullSecrets`; en EKS (Labs 3–4) mediante permisos del node group sobre el repositorio.

**imagePullPolicy**:

- `Always`: siempre consulta el registro (útil cuando `latest` se mueve).
- `IfNotPresent`: usa caché local si existe tag.
- `Never`: sólo local — raro salvo air-gapped.

### 1.11.7 Recursos, calidad de servicio (QoS) y escalado

**requests** y **limits** de CPU/memoria influyen en el scheduling y en el comportamiento ante presión de recursos: sobrepasar límites de CPU puede throttle; sobrepasar mem puede significar **OOMKill**.

Clases **QoS**: `Guaranteed` (requests=limits), `Burstable`, `BestEffort`. Importante al interpretar métricas bajo estrés en Laboratorio 2.

**Horizontal Pod Autoscaler (HPA)** escala réplicas según CPU/memoria (u otras métricas si el clúster las expone). En el **Laboratorio 2** el HPA usa **solo CPU** con **metrics-server** instalado en Minikube.

### 1.11.8 Observabilidad interna del Pod: probes

- **livenessProbe**: si falla, kubelet reinicia el contenedor (la app “atascada”).
- **readinessProbe**: si falla, el Pod se saca del Service endpoints (no recibe tráfico).
- **startupProbe**: para apps lentas al iniciar; evita falsos positivos en liveness temprano.

Mal diseñadas, las probes son causa #1 de reinicios en bucle bajo carga.

### 1.11.9 ConfigMaps, Secrets y RBAC

**ConfigMap** para configuración no sensible (feature toggles estáticos, URLs); **Secret** para datos sensibles (base64 en etcd — **habilitar encryption at rest** en clusters serios). **RBAC** (`Roles`, `ClusterRoles`, `Bindings`) controla qué identidades pueden leer Secrets en qué namespaces —pedagógicamente crítico en equipos multi-tenant simulados.

### 1.11.10 Scheduling avanzado y alta disponibilidad

**Taints/tolerations** reservan nodos para cargas especiales (GPU). **Affinity/anti-affinity** distribuye réplicas entre AZs. **PodDisruptionBudget** protege disponibilidad durante **drains** de nodos (kubelet evictions).

### 1.11.11 Comandos y flujo operativo habitual (`kubectl`)


| Acción             | Comando ilustrativo                                           |
| ------------------ | ------------------------------------------------------------- |
| Contexto / cluster | `kubectl config use-context`, `kubectl cluster-info`          |
| Namespace          | `kubectl get pods -n <ns>`                                    |
| Estado deseado     | `kubectl apply -f manifiesto.yaml`                            |
| Inspeccionar       | `kubectl describe pod`, `kubectl logs`, `kubectl get events`  |
| Debugging efímero  | `kubectl exec -it pod -- sh`, `kubectl port-forward svc/…`    |
| Rollout            | `kubectl rollout status deployment/…`, `kubectl rollout undo` |


*-Diagrama sugerido: ciclo operador — edit manifest → apply → observar Deployment conditions → revisar logs si CrashLoopBackOff.-*

### 1.11.12 Namespaces, etiquetas y multi-entorno

Los **namespaces** segmentan recursos lógicamente (`dev`, `staging`, `prd`). Las **labels** (`app=device-manager`, `tier=frontend`) conectan Deployments con Services. Patrones **GitOps** (Flux, Argo CD) verían esta misma API —fuera del alcance inicial pero contextualizan el Laboratorio 6.

### 1.11.13 Seguridad en runtime

**Pod Security Standards** / **PSA** (reemplazo moderno de PSP) definen perfiles **privileged**, **baseline**, **restricted**. **securityContext** permite `runAsNonRoot`, `readOnlyRootFilesystem`, `capabilities.drop: ["ALL"]`, alineado con endurecimiento de imagen Docker del Laboratorio 1.

---

## 1.12 Helm — marco ampliado

**Helm** es el gestor de paquetes de facto para Kubernetes: empaqueta manifiestos como **charts**, versiona releases y permite parameterizar despliegues sin copiar YAML entre entornos.

### 1.12.1 Anatomía de un chart

Un chart es un directorio con:

- `**Chart.yaml`**: metadatos (nombre, versión del chart, versión de aplicación).
- `**values.yaml**`: valores por defecto expuestos al usuario final.
- `**templates/**`: plantillas YAML con sintaxis **Go templates** (`{{ .Values.replicaCount }}`).
- `**templates/_helpers.tpl`**: fragmentos reutilizables.

Durante `helm install/upgrade`, Helm renderiza plantillas → valida contra el esquema de Kubernetes → aplica con la API server.

*-Diagrama sugerido: entrada `values-dev.yaml` + chart → manifiestos renderizados → API Kubernetes.-*

### 1.12.2 Releases, historial y rollback

Helm 3 almacena estado de release en **Secrets** del namespace (salvo configuración legacy). Comandos clave:

- `helm upgrade --install <release> <chart> -f values.yaml` — idempotente en pipelines.
- `helm history <release>` — revisiones numeradas.
- `helm rollback <release> <revision>` — vuelve atrás rápido cuando una imagen nueva falla readiness.

### 1.12.3 Dependencias entre charts

Un chart puede declarar **dependencies** (`charts/` subcharts); útil cuando `kube-prometheus-stack` incluye Prometheus, Grafana y operadores satélite.

### 1.12.4 Helm en el PI (Laboratorios 2, 4 y 6)

En el **Laboratorio 2**, Helm se usa vía **CLI** (`helm upgrade --install`) sobre charts propios (`tp1-backend`, `tp1-frontend`) con overrides en `Helm/dev/` y `Helm/prd/`. Los manifiestos parametrizan **imagen ECR**, **réplicas**, **tipo de Service**, **Ingress** y **HPA**.

En el **Laboratorio 4**, el mismo concepto de chart se materializa dentro de **Terraform** mediante el recurso `helm_release` y el **provider Helm**, autenticado contra el API de EKS (data sources `aws_eks_cluster` y `aws_eks_cluster_auth`). Así el stack **kube-prometheus-stack** queda versionado junto al resto de la infraestructura y admite `plan` antes de cambiar releases. En laboratorios posteriores (propuesta Lab 6), charts de aplicación y de monitoreo pueden seguir el mismo patrón.

Valores separados por entorno (`values-dev.yaml`, `values-prd.yaml`) evitan bifurcar plantillas.

### 1.12.5 Errores frecuentes y malentendidos (guía rápida)

Para orientar la tutoría en laboratorio, conviene listar confusiones recurrentes:

**Confundir imagen con contenedor en ejecución.** La imagen es inmutable y versionada; el contenedor es estado vivo que puede reiniciarse perdiendo datos no persistentes. Cuando un estudiante dice “reemplacé la imagen pero sigue fallando”, suele faltar invalidar caché local o referenciar el tag equivocado en Kubernetes (`imagePullPolicy: Always` ayuda en demos, con costo de red).

**Creer que `latest` es estable.** `latest` es solo una etiqueta con semántica convencional; en ECR puede apuntar al último push sin garantizar pruebas exhaustivas. Por eso los pipelines del PI también publican tags con SHA: permiten correlacionar incidentes con commits.

**Suponer que SonarCloud aprueba la seguridad integral.** SonarCloud cubre calidad y ciertos focos de seguridad estática, pero no sustituye pentesting, modelado de amenazas ni validación de configuración cloud.

**Interpretar verde en CI como listo para todo entorno.** Pasar CI en `develop` valida el estado de esa línea; promover a producción exige criterios extra (datos reales, SLAs, ventanas de mantenimiento), incluso en un PI donde “producción” puede ser un namespace etiquetado como `prd`.

**Minimizar la lectura de logs.** Muchos incidentes de Laboratorio 2 se resuelven leyendo `kubectl describe pod` y logs del contenedor; saltar directo a “reinstalar el chart” borra evidencia.

**Mezclar secretos de ejemplo en commits.** Aunque GitHub alerte después, la costumbre correcta es rotar credenciales expuestas y usar `.env.example` sin valores sensibles.

Esta lista no es exhaustiva pero reduce fricción cuando varios equipos avanzan en paralelo con distinta experiencia previa en Linux o cloud.

## 1.13 Infraestructura como código, observabilidad y release progresivo (Laboratorios 3 a 6)

Las herramientas de esta sección aparecen en la propuesta formal del PI ([Solicitud-tema-PI.docx.md](../../../Solicitud-tema-PI.docx.md)). Aquí se desarrollan con **profundidad teórica** suficiente para sustentar los informes de laboratorio y la experimentación en AWS.

### 1.13.1 HashiCorp Terraform — modelo mental y ciclo de vida

**Terraform** implementa **infraestructura como código (IaC)** declarativa: el archivo `.tf` describe el estado *deseado* de recursos (proveedor AWS, tipo `aws_instance`, argumentos). Terraform calcula un **plan de ejecución** comparando:

1. **Estado conocido** (`terraform.tfstate`), que es la representación JSON de IDs y atributos de recursos ya creados.
2. **Configuración actual** en disco (módulos + variables).

El comando `**terraform plan*`* muestra acciones `+` (create), `-` (destroy), `~` (update in-place), `-/+` (replace). `**terraform apply**` materializa esos cambios llamando a las APIs del proveedor cloud mediante **plugins** (`terraform-provider-aws`).

*-Diagrama sugerido: ciclo init → plan → apply → estado actualizado; ramal destroy.-*

Conceptos esenciales:

- **Providers**: plugins que implementan recursos (`provider "aws" { region = … }`).
- **Resources**: unidad mínima gestionada (`resource "aws_ecr_repository" "app" { … }`).
- **Data sources**: lectura de recursos existentes no gestionados por ese estado (`data.aws_vpc.default`).
- **Variables** (`variable`, `terraform.tfvars`) y **outputs** para contratos entre módulos.
- **Dependencias implícitas** (referencias entre recursos) vs `**depends_on`** explícito.

**Importante:** Terraform no es un gestor de configuración tipo Ansible sobre máquinas ya vivas por defecto; crea/actualiza **recursos cloud** declarados. Para bootstrap de software dentro de VMs existe integración con **user_data**, **SSM**, etc., pero el núcleo es API-driven infrastructure.

### 1.13.2 Estado (`state`), concurrencia y backends remotos

El archivo de estado no es solo caché: permite mapear direcciones lógicas (`aws_instance.web`) a IDs físicos (`i-0abc…`). En equipos, estado local en disco **no escala**: dos applies concurrentes pueden corromper el estado.

El backend remoto en AWS, tal como se implementa en este PI, se apoya en:

- **Amazon S3**: almacenamiento del archivo `terraform.tfstate` (versionado opcional, cifrado SSE-S3 o SSE-KMS, políticas IAM por cuenta/rol).
- **Bloqueo de concurrencia**: mecanismo que impide dos `apply` simultáneos sobre el mismo state.

En los **Laboratorios 3 y 4**, Terragrunt configura un backend **S3** con `encrypt = true` y **`use_lockfile = true`**: el lock es un **archivo nativo en el bucket** (lockfile de Terragrunt/Terraform moderno), **sin tabla DynamoDB** ni servicio adicional de bloqueo. Esa decisión reduce componentes que provisionar y mantener en cuentas de práctica docente.

Configuración representativa (conceptual):

```hcl
remote_state {
  backend = "s3"
  config = {
    bucket       = "terraform-state-dev-<account-id>"
    key          = "dev/us-east-1/vpc/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

En el **Laboratorio 4**, las keys de state llevan prefijo `lab4/` para no colisionar con el Lab 3 si comparten bucket.

*-Imagen sugerida: consola S3 mostrando objetos `terraform.tfstate` versionados y, si aplica, el lockfile asociado al apply en curso.-*

*Nota:* en documentación más antigua de Terraform aparece el bloqueo con **DynamoDB** (`dynamodb_table` en el backend S3). No forma parte de la implementación de este PI; se menciona solo porque el lector puede encontrarlo en tutoriales externos.

### 1.13.3 Módulos reutilizables

Un **módulo** es un paquete de recursos parametrizados (`modules/vpc`, `modules/eks`). Permite DRY (Don't Repeat Yourself) y versionado por **Git tags** o **Terraform Registry**. Inputs tipados (`validation` blocks) previenen valores ilegales (CIDR incorrectos).

### 1.13.4 Terragrunt — capa de orquestación sobre Terraform

**Terragrunt** (HashiCorp ecosystem, proyecto separado) envuelve Terraform para:

- **DRY de backends**: un `terragrunt.hcl` raíz define backend S3 una vez; hijos heredan.
- **Dependencias entre stacks**: `dependency "vpc" { config_path = "../vpc" }` expone outputs como inputs sin copiar manualmente.
- **Múltiples entornos** (`dev/staging/prd`) como carpetas con `terraform.tfvars` distintos pero mismo código de módulo.

Flujo típico: `terragrunt run-all plan` en orden DAG de dependencias.

*-Diagrama sugerido: árbol de carpetas `live/dev/us-east-1/eks` apuntando a módulos remotos `modules//eks`.-*

No sustituye Terraform: genera `.terraform` y delega en binarios oficiales. En este PI, **Terragrunt está adoptado en los Laboratorios 3 y 4**: un `live/root.hcl` centraliza backend S3 y provider AWS; cada unidad bajo `live/<env>/us-east-1/` (vpc, ecr, eks, monitoring) mantiene state separado; bloques `dependency` propagan outputs (por ejemplo, subnets de VPC hacia EKS); `terragrunt run --all plan|apply` respeta el grafo de dependencias; el script `bin/tg` facilita bootstrap del bucket con `TG_BACKEND_BOOTSTRAP=true`.

### 1.13.5 HashiCorp Vault — teoría de gestión de secretos

**Vault** centraliza secretos y **identidad**. Motores destacados:

- **KV v2**: almacén versionado clave-valor con políticas fine-grained.
- **Database**: credenciales dinámicas con TTL corto para bases.
- **PKI**: emisión de certificados X.509 cortos.

Flujo típico: aplicación autentica contra Vault (**Kubernetes auth**, **JWT/OIDC**, **AppRole**) → recibe token con políticas → lee paths permitidos.

Ventaja pedagógica frente a solo GitHub Secrets: **rotación**, **auditoría** (`audit devices`), **leases** que revocan automáticamente.

*-Diagrama sugerido: Pod → Vault Agent sidecar → secret renderizado en archivo tmpfs.-*

Integración con PI: complementa **AWS Secrets Manager** cuando hay cargas multi-cloud o políticas complejas; en Labs avanzados puede montarse Vault en EKS vía Helm.

### 1.13.6 Prometheus — modelo de métricas y componentes

**Prometheus** es un sistema de series temporales **pull**: scrapea endpoints HTTP (`/metrics`) en intervalos (`scrape_interval`). Usa **labels** dimensionales (`cluster`, `namespace`, `pod`) en lugar de jerarquías rígidas.

Componentes:

- **Prometheus Server**: TSDB embebida + evaluación de reglas de alerta.
- **ServiceDiscovery**: Kubernetes, EC2, DNS.
- **Alertmanager**: deduplica y agrupa alertas (incluido en el chart del Lab 4; configuración de canales externos fuera del alcance de los Labs 1–4).

En Kubernetes, **kube-prometheus-stack** despliega **node-exporter**, **kube-state-metrics** y adaptadores para exponer métricas del plano de datos.

Consultas **PromQL** ejemplo: `rate(http_requests_total[5m])`, `histogram_quantile(0.99, …)`.

*-Diagrama sugerido: targets → Prometheus → Grafana dashboards / Alertmanager.-*

### 1.13.7 Grafana — visualización, dashboards y alertas

**Grafana** consume **Prometheus** como datasource principal en el Lab 4 para construir **dashboards** declarativos en JSON o provisioning YAML. Soporta:

- Variables de dashboard (`$namespace`)
- Carpetas por equipo
- **Alerting** Grafana 8+ unificado (opcional vs Alertmanager nativo)

En el Laboratorio 4–6, dashboards pre-hechos (`Kubernetes / Compute Resources / Namespace`) aceleran la lectura del estrés de Laboratorio 2.

### 1.13.8 Split.io (u otra plataforma de feature flags) — teoría

Un **feature flag** decide en runtime si una funcionalidad está activa para un **usuario**, **sesión** o **segmento** (porcentaje canary, lista blanca beta testers).

**Split.io** (referencia en la Solicitud) provee SDKs que consultan reglas remotas y cachean con TTL; soporta **kill switches** instantáneos sin redeploy.

Separación conceptual:

- **Release**: nueva versión desplegada pero flag apagado → riesgo contenido.
- **Experimentación**: métricas de negocio ligadas a cohortes.

Combina con **Ingress canary** (tráfico HTTP 90/10) para capas distintas: flag controla lógica de negocio; balanceador controla versión binaria.

### 1.13.9 Pruebas de carga — conceptos y Apache JMeter (Laboratorio 2)

#### Conceptos generales de ingeniería de carga

Las pruebas de carga **simulan muchos clientes concurrentes** que golpean la aplicación (en el PI: API REST del Device Manager vía Service o Ingress en Kubernetes) y **miden** latencias, errores y throughput. Los resultados validan SLAs internos del laboratorio, detectan cuellos de botella y complementan el **Horizontal Pod Autoscaler (HPA)**.

| Concepto                     | Explicación breve                                                                                                                                                                                      |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Usuario virtual (VU)**     | Actor lógico que repite un guion (p. ej. listar dispositivos). En JMeter se modela con **Thread Groups** (hilos).                                                                                      |
| **Iteración**                | Una pasada completa del guion definido en el plan de prueba.                                                                                                                                           |
| **Throughput / RPS**         | Peticiones completadas por segundo; indica capacidad bajo carga.                                                                                                                                       |
| **Latencia**                 | Tiempo entre solicitud y respuesta; suele reportarse **p50**, **p95**, **p99**.                                                                                                                        |
| **Tasa de error**            | Porcentaje de respuestas HTTP no exitosas o timeouts.                                                                                                                                                  |
| **Saturación**               | CPU/memoria de Pods al límite; el HPA no sustituye RAM física del nodo (observado en Lab 2 con ~18 réplicas).                                                                                          |

**Tipos de prueba:** smoke (mínima), carga nominal, **estrés** (más allá del nominal), **spike** (pico brusco), **soak** (carga prolongada). **Ramping:** subida gradual de hilos o peticiones para dejar estabilizar el HPA.

#### Apache JMeter en el Laboratorio 2

**Apache JMeter** es una aplicación **Java** de código abierto para pruebas de carga web y REST. Ofrece **GUI** para armar planes (**.jmx**): **Thread Groups**, **HTTP Samplers**, **Listeners**, **Timers** y **Assertions**. En carga seria se usa modo **non-GUI** (`jmeter -n -t plan.jmx -l resultados.jtl`).

En el **Laboratorio 2**, la validación del HPA se realizó con **JMeter 5.5** como **Job** de Kubernetes (`justb4/jmeter:5.5`): plan en **ConfigMap**, tráfico contra `tp1-backend-service`, salida en `results.jtl`. Cuatro escenarios variaron `maxReplicas` y carga para observar techo del HPA, saturación de RAM del nodo y **desescalado** tras cesar las peticiones.

*-Diagrama sugerido: Job JMeter → Service backend → HPA escala Deployment; correlación opcional con métricas del Lab 4.-*
*-Imagen sugerida: captura de la GUI de JMeter con Thread Group + HTTP Request + Summary Report.-*

### 1.13.10 Figuras conceptuales (descripción textual)

Para cuando el informe se exporte a PDF con diagramas formales, aquí se anticipa la narrativa de tres vistas útiles:

**Vista A — Flujo Laboratorio 1 (desde cambio hasta registro):** un desarrollador abre una **PR** hacia `develop` o `main`; GitHub Actions ejecuta **checkout**, restauración de dependencias, **build**, **tests con cobertura**, **SonarCloud**. Si el job `ci` falla, el equipo corrige antes del merge. Tras merge/push a una rama protegida, el job **build-and-push** construye la imagen Docker con Buildx, autentica contra AWS, etiqueta con `rama-SHA` y `latest`, y publica en el **repositorio ECR** correspondiente (`develop` vs `main`). Opcionalmente, en `main`, un job **release** crea una versión visible en GitHub Releases para trazabilidad humana.

**Vista B — Capas de responsabilidad:** en la base, **infraestructura AWS** (red, IAM, registro); sobre ella **artefactos de imagen** inmutables; encima **Kubernetes** como plano de ejecución; finalmente **observabilidad** y **políticas de despliegue** que cierran el ciclo con feedback hacia desarrollo.

**Vista C — Separación dev/prd en registro:** dos repositorios ECR paralelos reciben líneas de vida distintas de la misma base de código; `latest` en cada uno apunta al último build válido **de esa línea**.

Estas vistas deben convertirse más adelante en figuras numeradas para el **Índice de figuras** cuando el documento se congele.

### 1.13.11 Límites del marco y trabajo futuro

Este marco **no** sustituye la documentación oficial ni los manuales de laboratorio: sintetiza conceptos para lectura continua. Ciertos temas —optimización de costos FinOps, multi-region active-active, service meshes como Istio o Linkerd— quedan fuera del núcleo pedagógico de los Labs 1–4 pero pueden mencionarse en ampliaciones futuras de la tesis o en trabajos derivados.

---

## 1.14 Marco teórico consolidado de Amazon Web Services (AWS)

Esta sección concentra la teoría de los **servicios AWS** que el PI utiliza o prevé utilizar. Se acepta **solapamiento** con §1.7 y §1.11 cuando el concepto ya se anticipó: aquí el foco es **mapa de servicios**, **integraciones** y **detalle operativo** útil como referencia única.

*-Diagrama sugerido: mapa mental “AWS Organizations → cuenta → región → VPC → AZ → subnets → servicios anclados”.-*

### 1.14.1 Modelo global: regiones y zonas de disponibilidad

**AWS** particiona el mundo en **Regiones** (`us-east-1`, `sa-east-1`, …), cada una con múltiples **Availability Zones (AZ)** — centros de datos separados físicamente conectados por red de baja latencia. Los Labs 3–4 despliegan VPC y EKS en **dos AZ** (`us-east-1a`, `us-east-1b`).

### 1.14.2 Modelo de responsabilidad compartida y cumplimiento

AWS opera la infraestructura física y los hipervisores de servicios gestionados; el cliente configura correctamente **IAM**, **cifrado**, **parches invitados en EC2**, **security groups**, datos sensibles. Errores de configuración no son “fallos del proveedor”.

### 1.14.3 Identidad y acceso: IAM en profundidad

**IAM** define:

- **Usuarios**: identidad humana o técnica con **Access Key** (ID + Secret); en el Lab 1 las usa GitHub Actions desde secrets — rotar y scope mínimo.
- **Roles**: entidades asumidas vía **STS AssumeRole** con credenciales temporales.
- **Políticas JSON**: listas `Allow`/`Deny` sobre acciones (`ecr:BatchGetImage`) y recursos (ARN).

**ARN** (`arn:partition:service:region:account-id:resource-type/resource-id`) identifica unívocamente recursos.

**Buenas prácticas PI**: políticas por laboratorio; etiquetas **cost allocation tags**; sin `AdministratorAccess` en usuarios estudiantiles.

### 1.14.4 Amazon ECR — segunda profundización (registro como columna vertebral)

(véase también §1.7) ECR es el servicio que materializa el vínculo entre **artifact** y **cuenta AWS**. En Labs 3–4: **lifecycle policies** (retención ~30 imágenes), **`scan_on_push`**, pull desde nodos EKS vía permisos del **node group**.

### 1.14.5 Redes: VPC, subnets, route tables, Internet Gateway, NAT

**VPC**: red virtual aislada (CIDR privado). **Subnets** públicas (ruta `0.0.0.0/0` → **Internet Gateway**) vs privadas (salida vía **NAT Gateway** para updates sin IP pública). **Security Groups** (stateful firewall a nivel de ENI) vs **NACL** (stateless, subnet).

Para **EKS**, el **AWS VPC CNI** asigna IPs de la VPC directamente a Pods (modo tráfico ENI) — implica planificar tamaños de subnet.

*-Diagrama sugerido: VPC con subnets públicas (NAT/IGW) y privadas (node groups EKS).-*

### 1.14.6 Amazon EKS — Kubernetes administrado en AWS

**EKS** ejecuta el **plano de control** como servicio; en los Labs 3–4 el cliente administra **managed node groups** (EC2) provisionados con el **módulo Terraform AWS EKS** (`terraform-aws-modules/eks`). La aplicación Device Manager **no se despliega en EKS** en esos laboratorios: el foco es red, clúster y (Lab 4) stack de monitoreo.

*-Diagrama sugerido: control plane AWS-managed ↔ API ↔ worker nodes ↔ ECR pull; Lab 4 añade namespace monitoring con Helm.-*

### 1.14.7 Computación: EC2 y AMIs

**EC2** provee máquinas virtuales; **Auto Scaling Groups** mantienen capacidad deseada. Los nodos EKS son EC2 con disco, tipo instancia elegido según carga (CPU vs network optimized).

### 1.14.8 Almacenamiento: EBS, S3

**EBS** volúmenes por AZ para estado durable de bases en EC2; snapshots a S3.

**Amazon S3** es **objeto** altamente durable; caso PI típico: **Terraform remote state**, artefactos de build, logs estáticos. Versionado + **SSE-KMS** recomendado para buckets de estado.

### 1.14.9 AWS Secrets Manager y Systems Manager Parameter Store

**Secrets Manager**: secretos **rotativos** automáticos para RDS, API keys con políticas de rotación lambda.

**Parameter Store** (Standard vs Advanced): configuración no sensible o secretos simples con histórico.

La Solicitud del PI cita **Secrets Manager** como referencia para gestión segura frente a YAML plano.

### 1.14.10 AWS KMS — cifrado

**KMS** gestiona **Customer Master Keys (CMK)**; uso: cifrado **S3**, **EBS**, **Secrets Manager**, **logs**. Integración IAM granular (`kms:Decrypt`).

### 1.14.11 Observabilidad en AWS vs en el clúster (Labs 1–4)

**Amazon CloudWatch** es el servicio nativo de métricas y logs de AWS. En los **Laboratorios 1–4** la observabilidad docente de cargas Kubernetes se implementó con **Prometheus y Grafana** (chart `kube-prometheus-stack` en Lab 4); los **logs del plano de control EKS** están deshabilitados en IaC por costo. CloudWatch permanece como referencia para operación AWS en ampliaciones futuras.

### 1.14.12 Relación servicios AWS ↔ laboratorios PI (tabla guía)


| Servicio AWS                            | Laboratorio típico |
| --------------------------------------- | ------------------ |
| IAM, ECR (push CI)                      | 1                  |
| ECR (pull en Minikube)                  | 2                  |
| metrics-server / HPA                    | 2                  |
| VPC, subnets, NAT, IGW                  | 3–4                |
| Terraform state S3 + lockfile (`use_lockfile`) | 3–4         |
| EKS, EC2 (node groups)                  | 3–4                |
| ECR (repos + scan_on_push en IaC)       | 3–4                |
| Prometheus/Grafana (Helm en Terraform)  | 4                  |
| Secrets Manager + KMS (ampliado)        | 5–6 (propuesta)    |


*-Nota para diseño gráfico: esta tabla puede pasarse al Índice de tablas como Tabla X.-*

---

# 2. Requerimientos y alcance del PI

## 2.1 Objetivo general

Diseñar y desarrollar una propuesta pedagógica basada en laboratorios técnicos iterativos que aborden de forma progresiva conocimientos y herramientas de **DevOps**, **cloud AWS** y **ingeniería de infraestructura**, fortaleciendo la vinculación entre teoría académica y práctica profesional, y potenciando la **alianza AWS-UNC**.

## 2.2 Objetivos parciales (por laboratorio)


| Lab | Objetivo parcial                                                                                           |
| --- | ---------------------------------------------------------------------------------------------------------- |
| 1   | Containerizar aplicación, automatizar CI/CD hasta registro ECR con pruebas y análisis estático.            |
| 2   | Desplegar en Minikube con manifiestos y Helm; NodePort/Ingress; HPA + metrics-server; estrés con JMeter.   |
| 3   | Provisionar VPC, ECR y EKS en AWS con Terraform/Terragrunt, estado remoto S3 y entornos dev/prd.           |
| 4   | Extender IaC con observabilidad en EKS (kube-prometheus-stack vía Helm en Terraform).                      |
| 5   | Incorporar feature flags y despliegues canary con segmentación de tráfico y rollback (propuesta).          |
| 6   | Integrar pipeline completo (build, IaC, deploy Helm, secretos, monitoreo, métricas tipo DORA) (propuesta). |


## 2.3 Usuarios y destinatarios

- **Estudiantes** de materias vinculadas (Ingeniería de Software, Gestión de la Calidad de Software): ejecutan guías, cumplen consignas y documentan resultados.
- **Docentes**: adoptan o adaptan materiales, evalúan entregas y validan el alcance pedagógico.
- **Organización del proyecto**: los autores del PI mantienen consistencia entre repos, infraestructura de ejemplo y documentación.

## 2.4 Requerimientos funcionales (resumen)

- **RF1** (cumplido — Lab 1): Aplicación de referencia Device Manager (API .NET + SPA React) empaquetada en contenedores.
- **RF2** (cumplido — Lab 1): Build, test, análisis estático y publicación de imágenes en ECR con política de ramas.
- **RF3** (cumplido — Labs 1–4): Material didáctico por laboratorio (guía, consignas, informe final, entregables).
- **RF4** (cumplido — Lab 2; base cloud — Lab 3): Despliegue en Kubernetes (Minikube + manifiestos/Helm); clúster EKS provisionado en IaC.
- **RF5** (cumplido — Labs 3–4): Infraestructura como código en AWS con módulos, variables, estado remoto y entornos separados.
- **RF6** (cumplido parcial — Lab 4): Observabilidad con Prometheus y Grafana en el clúster; métricas de aplicación para HPA en Lab 2 (metrics-server).
- **RF7** (propuesta — Labs 5–6): Feature flags, canary, secretos avanzados y pipeline integral con métricas DORA según Solicitud del PI.

## 2.5 Requerimientos no funcionales

- **Seguridad**: secretos fuera del código; IAM mínimo; análisis estático en CI.
- **Reproducibilidad**: pipelines declarativos; infraestructura versionada.
- **Mantenibilidad**: documentación clara y decisiones justificadas.
- **Costo**: uso responsable de cuentas AWS en contexto académico.

## 2.6 Riesgos principales

- **Permisos AWS y costos inadvertidos** (Labs 3–4): NAT, EKS y almacenamiento de state → mitigación con etiquetado, buckets por entorno, nodos pequeños y revisión docente.
- **Divergencia documentación ↔ repos**: workflows o rutas de código que cambian sin actualizar guías → mitigación con revisión periódica y referencias cruzadas en este informe.
- **Sobrecarga estudiantil**: acumulación de herramientas nuevas → mitigación con entregas incrementales y criterios de aceptación explícitos por lab.
- **Lab 2 — capacidad del clúster local**: el HPA puede solicitar más réplicas de las que admite la RAM de Minikube → documentar límites físicos frente a autoscaling (prueba 3 del informe Lab 2).
- **Lab 2 — fuente del plan JMeter**: riesgo de confundir `config/test-plan.jmx` con el ConfigMap aplicado al Job → dejar explícita la fuente de verdad en guía y corrección.
- **Lab 4 — orden de despliegue**: unidad `monitoring` sin `dependency` Terragrunt a `eks` → aplicar en dos fases o documentar fallo si el clúster no existe.
- **Lab 4 — secretos en texto plano**: contraseñas Grafana en `terragrunt.hcl` solo válidas en laboratorio; advertir rotación y Secrets Manager para producción.

## 2.7 Estado de avance del PI

| Lab | Estado | Documentación en repositorio |
| --- | ------ | ------------------------------ |
| 1 | Implementado y documentado | `repositories/labs/lab1/docs/` |
| 2 | Implementado y documentado | `repositories/labs/lab2/ICOMP-UNC-pi-2025-Infra-lab2/docs/` |
| 3 | Implementado y documentado | `repositories/labs/lab3/ICOMP-UNC-pi-2025-Infra-lab3/docs/` |
| 4 | Implementado y documentado | `repositories/labs/lab4/ICOMP-UNC-pi-2025-Infra-lab4/docs/` |
| 5 | Propuesta (Solicitud PI) | Por desarrollar |
| 6 | Propuesta (Solicitud PI) | Por desarrollar |

Los cuatro primeros laboratorios disponen de **informe final**, **guía y consignas** y **entregables**; los Labs 3 y 4 incluyen además diagramas **Mermaid** exportables a figuras del PDF de tesis.

---

# 3. Selección de herramientas y stack

Este capítulo resume las tecnologías adoptadas en el PI, organizadas por capas del ciclo de vida. La selección prioriza la **alianza AWS-UNC**, la **progresión pedagógica** (local → nube gestionada) y herramientas con documentación oficial madura. Las tablas distinguen lo **implementado y documentado** en los Laboratorios 1–4 de lo **planificado** en los Laboratorios 5–6 según la Solicitud del proyecto.

## 3.1 Aplicación de referencia (Device Manager)

| Componente | Elección | Versión / detalle | Justificación |
| ---------- | -------- | ----------------- | ------------- |
| Backend | ASP.NET Core | .NET 9 | API REST en capas Web / Business / Data; pruebas unitarias en CI |
| Frontend | React + Vite + MUI | React 18, Vite 5, MUI 5 | SPA con build estático servido en contenedor liviano |
| Comunicación | REST + JSON | OpenAPI (opcional) | Contrato entre cliente y API; misma app en todos los labs |

## 3.2 Integración, calidad y entrega (Laboratorio 1)

| Componente | Elección | Uso en el PI |
| ---------- | -------- | ------------ |
| Control de versiones | Git, GitHub | Ramas `develop` / `main`; integración por PR |
| CI/CD | GitHub Actions | Jobs `ci` (tests + SonarCloud) y `build-and-push` (Docker → ECR) |
| Contenedores | Docker, Buildx / BuildKit | Dockerfiles multi-stage; caché de capas en pipeline |
| Registro | Amazon ECR | Repositorios diferenciados por línea (integración vs producción) |
| Calidad | SonarCloud, cobertura de tests | OpenCover (.NET), lcov (frontend) |
| Desarrollo local | Docker Compose | Levantamiento integrado front + back (entregable alumnos) |

## 3.3 Orquestación de cargas y escalado (Laboratorio 2)

| Componente | Elección | Detalle de implementación |
| ---------- | -------- | ------------------------- |
| Orquestación | Kubernetes | Deployments, Services, HPA, ConfigMap, Job |
| Clúster de práctica | Minikube | Un nodo; addons ingress y metrics-server |
| Empaquetado | Helm 3 | Charts `tp1-backend` y `tp1-frontend`; overrides `Helm/dev/`, `Helm/prd/` |
| Exposición | NodePort, Ingress (nginx) | Host `app.local`; rutas `/` (UI) y `/api` (backend) |
| Autoscaling | HPA (autoscaling/v2) + metrics-server | CPU target 70 %; request 200m; min/max réplicas configurables |
| Pruebas de carga | Apache JMeter 5.5 | Imagen `justb4/jmeter`; Job + ConfigMap en namespace `jmeter` |
| Operación | kubectl, helm | `apply`, `upgrade --install`, observación de HPA bajo carga |

## 3.4 Infraestructura como código (Laboratorios 3 y 4)

| Componente | Elección | Detalle de implementación |
| ---------- | -------- | ------------------------- |
| IaC | Terraform ≥ 1.6 | Módulos propios en `modules/`; configuración por entorno en `live/` |
| Orquestación IaC | Terragrunt 1.x | Backend común, provider generado, `dependency` entre unidades |
| Proveedor cloud | AWS | Región `us-east-1`; entornos `dev` y `prd` |
| Módulos community | terraform-aws-modules | VPC ~5.0, EKS 20.31.0, ECR ~2.0 |
| Estado remoto | Amazon S3 + lockfile | Cifrado; prefijo `lab4/` en Lab 4 para no colisionar con Lab 3 |
| Kubernetes gestionado | Amazon EKS 1.35 | Node groups en subnets privadas; endpoint público para operación docente |
| Helm en IaC | Provider Helm + `helm_release` | Lab 4: `kube-prometheus-stack` en namespace `monitoring` |
| Operación | AWS CLI, Terragrunt, kubectl | Bootstrap S3, `run --all`, validación post-apply |

## 3.5 Observabilidad (Laboratorio 4)

| Componente | Rol |
| ---------- | --- |
| kube-prometheus-stack (Helm) | Despliegue unificado de Prometheus, Grafana, Alertmanager |
| Prometheus | TSDB y scraping de métricas (node-exporter, kube-state-metrics) |
| Grafana | Dashboards; acceso por port-forward en contexto de laboratorio |
| Alertmanager | Enrutamiento básico de alertas (configuración mínima en lab) |

Retención y recursos acotados en `values/monitoring.yaml` (por ejemplo, retención Prometheus 1 día, sin PVC en Grafana) por restricciones de nodos `t3.small` en desarrollo.

## 3.6 Stack planificado (Laboratorios 5 y 6 — Solicitud PI)

Las siguientes herramientas figuran en la propuesta formal del trabajo; **no forman parte de la implementación documentada** en los informes de los Labs 1–4, pero orientan el diseño del material restante:

| Componente | Uso previsto |
| ---------- | ------------ |
| Split.io (u equivalente) | Feature flags y experimentación |
| Despliegues canary | Rollout progresivo y rollback |
| HashiCorp Vault / AWS Secrets Manager | Gestión de secretos en pipeline y clúster |
| Grafana k6 | Pruebas de carga en CI/CD (complemento a JMeter del Lab 2) |
| CodeQL | Análisis de seguridad adicional en GitHub |
| Métricas DORA, MTTR/MTBF | Correlación operación ↔ entrega (Lab 6) |

## 3.7 Criterios de selección

Se privilegió el ecosistema **AWS** por la alianza institucional y la continuidad desde **ECR** hasta **EKS**. **Kubernetes** y **Helm** son estándar de industria para empaquetar y promover cargas entre entornos. **Terraform** y **Terragrunt** permiten infraestructura revisable en PR y estado remoto compartido. En contexto académico se acotaron costos (`single_nat_gateway`, pocos nodos, logs de control plane EKS deshabilitados en labs, retención corta de métricas). La progresión **Minikube (Lab 2) → EKS en AWS (Labs 3–4)** separa el aprendizaje de objetos Kubernetes del aprovisionamiento de red y cuentas cloud.

---

# 4. Actividades desarrolladas — Laboratorios

## 4.1 Laboratorio 1 — Construcción de imágenes Docker y automatización de push

### 4.1.1 Objetivo

Construir imágenes Docker del backend y del frontend de **Device Manager**, ejecutar **integración continua** con pruebas automatizadas y análisis estático (**SonarCloud**), y publicar artefactos en **Amazon ECR** con política de ramas y repositorios diferenciados para integración y producción. Este laboratorio materializa el primer tramo de la Solicitud del PI: *"construcción de imágenes con Docker y automatización de push"* hacia un registro en la nube.

### 4.1.2 Relación con el resto del PI

El Lab 1 produce el **artefacto inmutable** (imagen etiquetada) que consumen el Lab 2 (pull desde Minikube), el Lab 3 (gestión de repos ECR en IaC) y los despliegues posteriores en EKS. Sin trazabilidad commit → tag → digest, los laboratorios de orquestación pierden auditabilidad.

### 4.1.3 Tareas realizadas

1. **Cuenta AWS e IAM**: credenciales en **GitHub Secrets**; sin claves en el repositorio.
2. **Backend (.NET 9)**: capas Web / Business / Data; Dockerfile multi-stage; puerto **8080** en runtime.
3. **Frontend (React 18 + Vite)**: build estático; entrypoint para inyectar URL de API en runtime.
4. **Pipeline GitHub Actions**: job `ci` (tests + SonarCloud); job `build-and-push` con **Docker Buildx** hacia ECR en push a `develop` o `main`; tags `ref_name-SHA` y `latest`; job **release** en backend al integrar en `main`.
5. **Docker Compose**: orquestación local front + back (entregable pedagógico).
6. **Política de ramas**: integración por PR; publicación en ECR alineada a la línea develop/main según configuración del pipeline.

### 4.1.4 Decisiones de diseño

| Decisión | Justificación |
| -------- | ------------- |
| Dockerfile multi-stage (backend) | Imagen final sin SDK; menor tamaño y superficie de ataque |
| ECR en lugar de registro genérico | Alineación AWS-UNC y continuidad hacia EKS |
| Repositorios ECR distintos por línea | Reduce riesgo de promover por error una imagen experimental |
| SonarCloud en CI | Feedback temprano de calidad y seguridad estática |
| Secrets en GitHub | Cumple DevSecOps básico; rotación sin cambiar código |

### 4.1.5 Validación y evidencias

| Verificación | Evidencia sugerida |
| ------------ | ------------------ |
| Pipeline CI verde en PR | Captura de GitHub Actions (job `ci`) |
| Imagen en ECR tras merge a rama publicadora | Consola ECR con tags `rama-SHA` y `latest` |
| Compose local funcional | `docker compose up --build`; UI consume API |
| Análisis SonarCloud | Dashboard del proyecto sin bloqueos críticos configurados |

*-Figura 4.1 (sugerida): flujo PR → CI (tests + Sonar) → build-and-push → ECR (repos develop/prd).-*
*-Figura 4.2 (sugerida): secuencia de jobs GitHub Actions con `needs: ci`.-*
*-Tabla 4.1 (sugerida): comparativa de repositorios ECR por rama.-*

### 4.1.6 Referencia

Detalle ampliado: [Informe final — Lab 1](../../../repositories/labs/lab1/docs/informe-final-lab1.md). Entregables: [entregables-lab1.md](../../../repositories/labs/lab1/docs/entregables-lab1.md).

---

## 4.2 Laboratorio 2 — Kubernetes y Helm

### 4.2.1 Objetivo

Desplegar **Device Manager** (imágenes del Lab 1 en **ECR**) en un clúster **Kubernetes** local (**Minikube**): primero con **manifiestos YAML**, luego con **Helm**; exponer la aplicación (**NodePort** e **Ingress**); configurar **HPA** apoyado en **metrics-server**; validar escalado con **pruebas de estrés JMeter** ejecutadas como **Job** en el clúster. Cumple la Solicitud del PI sobre introducción a Kubernetes y Helm.

### 4.2.2 Relación con laboratorios adyacentes

- **Lab 1:** origen de imágenes (`tp1-backend`, `tp1-frontend`, variantes `-prd`).
- **Lab 3–4:** mismos charts y conceptos (Deployment, Service, HPA) sobre **EKS** provisionado en AWS; el Lab 2 aísla el aprendizaje de objetos K8s sin costo de nube durante la práctica inicial.

### 4.2.3 Tareas realizadas

1. **Minikube**: clúster de un nodo; verificación con `kubectl cluster-info` y `get nodes`.
2. **metrics-server**: habilitado (addon); prerequisito para HPA y `kubectl top`.
3. **Manifiestos backend** (`Kubernetes/backend.yaml`): Deployment (imagen ECR, puerto 8080, requests/limits), Service **NodePort 30081**, **HPA** (CPU 70 %, min 1 / max 20).
4. **Manifiestos frontend** (`Kubernetes/frontend.yaml`): Deployment, NodePort **30080**, variable `VITE_API_BASE_URL` hacia el backend.
5. **Charts Helm** (`Helm/backend/`, `Helm/frontend/`): `helm upgrade --install` con overrides `Helm/dev/` y `Helm/prd/`.
6. **Ingress**: addon nginx; host **`app.local`**; rutas `/` → frontend y `/api` → backend; API en mismo origen para la SPA.
7. **JMeter**: namespace `jmeter`; ConfigMap con plan de prueba; **Job** `justb4/jmeter:5.5` contra `tp1-backend-service`; resultados en `/outputs/results.jtl`.
8. **Cuatro escenarios HPA**: variación de `maxReplicas` y carga; observación de techo del HPA, saturación de RAM del nodo (~18 réplicas) y **desescalado** ~5 min tras cesar la carga.

### 4.2.4 Artefactos principales

| Ruta en repo Lab 2 | Contenido |
| ------------------ | --------- |
| `Kubernetes/backend.yaml`, `frontend.yaml` | Manifiestos planos |
| `Helm/backend/`, `Helm/frontend/` | Charts parametrizables |
| `Helm/dev/`, `Helm/prd/` | Overrides por entorno |
| `Kubernetes/jmeter-job.yaml`, `configmap.yaml` | Carga in-cluster |
| `config/test-plan.jmx` | Borrador editable en GUI (no fuente de verdad del Job) |

Repositorio: `repositories/labs/lab2/ICOMP-UNC-pi-2025-Infra-lab2/`.

### 4.2.5 Decisiones de diseño

| Decisión | Justificación |
| -------- | ------------- |
| Manifiestos antes que Helm | Pedagogía del PI: objetos explícitos antes de plantillas |
| NodePort en YAML plano; Ingress en Helm dev | Prueba rápida vs modelo cercano a producción |
| Solo CPU en HPA | Visible en Minikube sin Prometheus adapter |
| Request CPU 200m | Porcentaje HPA alcanzable en tiempo de laboratorio |
| JMeter como Job (no Pod suelto) | Semántica de trabajo terminable; `backoffLimit: 0` |
| Namespace `jmeter` aislado | Separa tráfico de prueba de workloads de la app |

### 4.2.6 Validación y evidencias

| Verificación | Comando / acción | Evidencia |
| ------------ | ---------------- | --------- |
| Pods Running | `kubectl get pods` | Captura |
| HPA reacciona a carga | `kubectl get hpa -w` durante Job JMeter | Captura o tabla de réplicas vs tiempo |
| Ingress operativo | Navegador en `http://app.local` | Captura |
| Helm releases | `helm list` | Salida de terminal |
| Job JMeter completado | `kubectl get jobs -n jmeter` | Estado Complete |

**Tabla 4.2 — Cuatro pruebas de escalado del HPA (resumen)**

| # | maxReplicas | Observación pedagógica |
| - | ----------- | ---------------------- |
| 1 | 5 | HPA llega al techo configurado (límite artificial) |
| 2 | 15 | Escalado progresivo hasta el máximo bajo carga sostenida |
| 3 | 20 | ~18 réplicas: nodo sin RAM (HPA no sustituye capacidad física) |
| 4 | 20 (carga reducida) | Escala 1→11 y **desescala** tras ~5 min al cesar peticiones |

*-Figura 4.3 (sugerida): arquitectura Minikube — Ingress → Services → Pods; ECR como origen de imágenes.-*
*-Figura 4.4 (sugerida): progresión manifiestos YAML → charts Helm → Ingress unificado.-*
*-Figura 4.5 (sugerida): secuencia JMeter Job → Service backend → HPA escala Deployment.-*
*-Tabla 4.3 (sugerida): NodePort (manifiestos) vs ClusterIP + Ingress (Helm dev).-*

Marco teórico de apoyo: §1.11 (Kubernetes), §1.12 (Helm), §1.13.9 (carga y JMeter en Lab 2).

### 4.2.7 Referencia

[Informe final — Lab 2](../../../repositories/labs/lab2/ICOMP-UNC-pi-2025-Infra-lab2/docs/informe-final-lab2.md).

---

## 4.3 Laboratorio 3 — Infraestructura como código en AWS con Terraform

### 4.3.1 Objetivo

Modelar en **AWS** una base de infraestructura **reproducible y versionada** para entornos `dev` y `prd` en `us-east-1`: **VPC** (dos AZ), **ECR** y **EKS**, usando **Terraform** y **Terragrunt**, con **estado remoto en S3** y bloqueo de concurrencia. Extiende la Solicitud del PI (IaC con providers, variables, recursos y estado remoto) más allá del aprovisionamiento manual inicial.

### 4.3.2 Relación con laboratorios adyacentes

- **Lab 1:** repos e imágenes ECR (import si ya existían).
- **Lab 2:** mismos workloads pueden desplegarse sobre el EKS creado aquí.
- **Lab 4:** hereda módulos vpc/ecr/eks y añade unidad **monitoring** con prefijo de state `lab4/`.

### 4.3.3 Tareas realizadas

1. **Estructura `modules/` vs `live/`**: módulos reutilizables; unidades Terragrunt por entorno y región.
2. **`live/root.hcl`**: backend S3, `encrypt = true`, `use_lockfile = true`; provider AWS generado con `allowed_account_ids` y tags (`Lab = lab3`).
3. **Módulo VPC**: terraform-aws-modules/vpc; CIDR `10.10.0.0/16` (dev) y `10.20.0.0/16` (prd); NAT único; tags ELB para Kubernetes.
4. **Módulo ECR**: repos del TP; scan on push; lifecycle (~30 imágenes); **import** de repos existentes del Lab 1.
5. **Módulo EKS**: Kubernetes **1.35**; node groups en subnets privadas; endpoint público; `enable_cluster_creator_admin_permissions`; logs/KMS de lab deshabilitados para costo.
6. **Entornos dev/prd**: `tp3-dev-eks` (1× `t3.small`) vs `tp3-prd-eks` (2–4× `t3.medium`); buckets de state separados.
7. **Bootstrap**: `TG_BACKEND_BOOTSTRAP` / script `bin/tg` para crear bucket S3.
8. **Orden de apply**: vpc → ecr → eks (`terragrunt run --all`); validación con `kubectl get nodes`.

### 4.3.4 Decisiones de diseño

| Decisión | Justificación | Trade-off |
| -------- | ------------- | --------- |
| Terragrunt sobre Terraform solo | DRY de backend/provider; `dependency` vpc→eks | Curva de aprendizaje adicional |
| Módulos community | Rapidez y buenas prácticas AWS | Menos control fino que recursos raw |
| NAT único | Menor costo en práctica | Menor HA de egress |
| Endpoint EKS público | Facilita kubectl desde laptops | Mayor superficie; restringir en prod real |
| Lockfile S3 (`use_lockfile`) | Bloqueo sin servicio extra; menos componentes en cuenta educativa | Patrón más reciente; tutoriales antiguos pueden citar otras opciones |
| Import ECR | No destruir imágenes del Lab 1 | Paso manual documentado |

### 4.3.5 Validación y evidencias

| Verificación | Evidencia sugerida |
| ------------ | ------------------ |
| State en S3 | Listado de bucket y keys por unidad |
| Plan sin drift inesperado | `terragrunt plan` en vpc, ecr, eks |
| Nodos Ready | `kubectl get nodes` |
| Repos ECR gestionados | Consola ECR o `aws ecr describe-repositories` |

**Tabla 4.4 — Comparativa dev / prd (Lab 3)**

| Dimensión | dev | prd |
| --------- | --- | --- |
| VPC / CIDR | `tp3-dev-vpc` / `10.10.0.0/16` | `tp3-prd-vpc` / `10.20.0.0/16` |
| EKS | `tp3-dev-eks`, 1× `t3.small` | `tp3-prd-eks`, 2–4× `t3.medium` |
| ECR | `tp1-frontend`, `tp1-backend` | sufijo `-prd` |
| State bucket | `terraform-state-dev-<account>` | `terraform-state-prd-<account>` |

*-Figuras sugeridas (exportar desde `docs/diagramas/` del repo lab3): `arquitectura-lab3.mmd`, `jerarquia-terragrunt.mmd`, `red-vpc-2az.mmd`, `secuencia-despliegue.mmd`, `estado-remoto-bootstrap.mmd`.*

### 4.3.6 Referencia

[Informe final — Lab 3](../../../repositories/labs/lab3/ICOMP-UNC-pi-2025-Infra-lab3/docs/informe-final-lab3.md); [marco-conceptual-lab3.md](../../../repositories/labs/lab3/ICOMP-UNC-pi-2025-Infra-lab3/docs/marco-conceptual-lab3.md).

---

## 4.4 Laboratorio 4 — EKS y observabilidad (Prometheus y Grafana)

### 4.4.1 Objetivo

Extender la infraestructura del **Lab 3** con **observabilidad en el clúster**: instalar mediante **IaC** el chart **kube-prometheus-stack** (Prometheus, Grafana, Alertmanager, exporters), integrando **Helm en Terraform** según la Solicitud del PI sobre EKS y monitoreo con Grafana y Prometheus.

### 4.4.2 Relación Lab 3 → Lab 4

| Aspecto | Lab 3 | Lab 4 |
| ------- | ----- | ----- |
| Módulos AWS | vpc, ecr, eks | Los mismos + **monitoring** |
| Naming / tags | `tp3-*`, `Lab=lab3` | `tp4-*`, `Lab=lab4` |
| State S3 | `dev/us-east-1/...` | `lab4/dev/us-east-1/...` |
| Workloads K8s en IaC | No | **helm_release** (Prometheus stack) |

El Lab 4 **no reemplaza** al Lab 3: lo **hereda** y añade la capa de monitoreo.

### 4.4.3 Tareas realizadas

1. **`live/root.hcl`**: prefijo `lab4/` en keys de state; mismos patrones de provider y tags.
2. **Módulos vpc, ecr, eks**: equivalentes al Lab 3 con naming `tp4-*` y capacidad de nodos según entorno.
3. **Módulo `monitoring`**: recurso `helm_release` del chart **kube-prometheus-stack** (versión ~69.x); namespace `monitoring`; `values/monitoring.yaml` (retención Prometheus 1d, Grafana sin PVC, recursos bajos).
4. **Provider Helm generado** en Terragrunt: autenticación al API EKS por nombre de clúster (`tp4-dev-eks` / `tp4-prd-eks`) sin bloque `dependency` al state de eks.
5. **Apply en dos fases**: primero vpc → ecr → eks (excluyendo monitoring); luego unidad `monitoring` cuando el clúster existe.
6. **Validación**: `kubectl get pods -n monitoring`; **port-forward** a Grafana; revisión de dashboards por defecto del chart.

### 4.4.4 Decisiones de diseño

| Decisión | Motivación | Trade-off |
| -------- | ---------- | --------- |
| Prefijo `lab4/` en state | Convivir con Lab 3 en mismos buckets | Convención a documentar |
| Helm vía Terraform | Cumple PI: charts en IaC; `plan` unificado | Applies más lentos |
| Provider Helm sin `dependency` eks | Estados desacoplados | Orden manual: eks antes que monitoring |
| Sin PVC / retención 1d | Nodos `t3.small`, costo disco | No apto para histórico largo |
| Contraseñas Grafana en `terragrunt.hcl` | Simplicidad docente | Inaceptable en producción |

### 4.4.5 Validación y evidencias

| Verificación | Acción |
| ------------ | ------ |
| Nodos Ready | `kubectl get nodes` |
| Pods monitoring Running | `kubectl get pods -n monitoring` |
| Grafana accesible | `kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80` |
| Apply monitoring limpio | Salida `terragrunt plan/apply` en unidad monitoring |

**Tabla 4.5 — Comparativa dev / prd (Lab 4, extracto)**

| Dimensión | dev | prd |
| --------- | --- | --- |
| Cluster | `tp4-dev-eks` | `tp4-prd-eks` |
| Nodos | 1× `t3.small` | 2–4× `t3.medium` |
| Grafana (lab) | password documentada `admin` | `changeme-prd` |

*-Figuras sugeridas (repo lab4 `docs/diagramas/`): `arquitectura-lab4.mmd`, `stack-observabilidad-lab4.mmd`, `jerarquia-terragrunt-lab4.mmd`, `secuencia-despliegue-lab4.mmd`, `red-vpc-eks-lab4.mmd`.*

Marco teórico: §1.13.6–1.13.7 (Prometheus, Grafana), §1.12.4 (Helm en IaC), §1.14.6 (EKS).

### 4.4.6 Referencia

[Informe final — Lab 4](../../../repositories/labs/lab4/ICOMP-UNC-pi-2025-Infra-lab4/docs/informe-final-lab4.md).

---

## 4.5 Laboratorio 5 — Feature flags y despliegues canary (propuesta)

Según la **Solicitud del PI**, el Laboratorio 5 integraría una plataforma de **feature flags** (referencia: **Split.io** u equivalente) y **rollouts progresivos tipo canary**, con lógica de promoción y **rollback** ante degradación de métricas. En la implementación documentada hasta la fecha de este informe, el material de los **Labs 1–4** deja preparado el terreno (imágenes versionadas, Helm, observabilidad en EKS), pero **no se incluye aún** la integración de flags ni el enrutamiento ponderado de tráfico en producción docente. El diseño pedagógico previsto combinaría flags (lógica de negocio) con canary a nivel Ingress o service mesh (versión binaria), en línea con §1.13.8 de este documento.

---

## 4.6 Laboratorio 6 — Integración completa del flujo CI/CD (propuesta)

El **Laboratorio 6** cerraría el arco del PI con un **pipeline integral**: build y push a **ECR**, aprovisionamiento **Terraform/Terragrunt**, despliegue **Helm** en Kubernetes, gestión de **secretos**, **monitoreo** (charts Prometheus/Grafana) y correlación con **métricas DORA** y tiempos de recuperación (MTTR y afines), según la Solicitud. Los Labs 1–4 aportan piezas verificables (CI, charts, IaC, observabilidad); el Lab 6 las unificaría en un flujo único automatizado —objetivo declarado para trabajo futuro y extensión del material docente— sin que este informe afirme su implementación completa.

---

# 5. Conclusiones

El Proyecto Integrador alcanzó una **primera entrega consolidada** de cuatro laboratorios técnicos que recorren el ciclo de vida de una aplicación moderna en el ecosistema **AWS-UNC**: desde la **containerización** y el **CI/CD** hasta el **despliegue orquestado**, la **infraestructura como código** y la **observabilidad** en **Amazon EKS**. La progresión **Minikube (Lab 2) → EKS en AWS (Labs 3–4)** permitió separar el dominio de objetos Kubernetes del aprovisionamiento de red y cuentas cloud, sin perder continuidad sobre la misma aplicación de referencia y las mismas imágenes en **ECR**.

**Logros principales:** (1) artefactos reproducibles y trazables (imágenes etiquetadas, pipelines declarativos); (2) material didáctico verificable (guías, consignas, informes finales y entregables por lab); (3) infraestructura versionada con **Terragrunt** y estado remoto; (4) monitoreo operativo básico con **Prometheus** y **Grafana** gestionado como código; (5) experiencia de **autoscaling** bajo carga real (HPA + JMeter en Lab 2).

**Dificultades y límites conscientes:** costos y permisos en cuentas educativas; saturación de recursos en clústeres locales frente al HPA; contraseñas y configuraciones simplificadas en labs que no son aptas para producción; orden manual de apply entre unidades Terragrunt (monitoring tras EKS). Estas decisiones se documentaron como **trade-offs pedagógicos**, no como recomendaciones operativas finales.

**Trabajo futuro:** completar los **Laboratorios 5 y 6** (feature flags, canary, secretos avanzados, pipeline integral y métricas DORA); exportar diagramas Mermaid a figuras del informe impreso y recoger métricas de uso en cátedra si el director del PI lo requiere.

En conjunto, el trabajo aporta un **corpus reusable** que vincula contenidos de Ingeniería de Software y Gestión de la Calidad de Software con prácticas actuales de **DevOps** e **ingeniería de infraestructura**, en línea con el objetivo de fortalecer la formación profesional en la **Universidad Nacional de Córdoba** dentro de la alianza con **Amazon Web Services**.

---

# 6. Bibliografía y referencias

1. Amazon Web Services. *Amazon ECR User Guide*. Documentación oficial.
2. Amazon Web Services. *What is Amazon EKS?* Documentación oficial.
3. Amazon Web Services. *AWS Secrets Manager User Guide*. Documentación oficial.
4. Docker Inc. *Docker overview*. Documentación oficial.
5. GitHub. *Understanding GitHub Actions*. Documentación oficial.
6. Grafana Labs. *Grafana documentation*. Documentación oficial.
7. HashiCorp. *Terraform Introduction*. Documentación oficial.
8. Helm Project. *Helm Documentation*. Documentación oficial.
9. Kubernetes Project. *Kubernetes Concepts*. Documentación oficial.
10. Prometheus Authors. *Prometheus Documentation*. Documentación oficial.
11. Atlassian. *DORA Metrics* (recurso divulgativo sobre métricas DevOps).
12. Sommerville, I. *Software Engineering* (referencia clásica de ingeniería de software).
13. Galin, D. *Software Quality Assurance* (referencia de calidad de software).
14. Solicitud de Proyecto Integrador — documento de presentación del trabajo final (UNC, 2025). Versión en Markdown del repositorio: [Solicitud-tema-PI.docx.md](../../../Solicitud-tema-PI.docx.md).
15. HashiCorp. *Terragrunt Documentation*. [https://terragrunt.gruntwork.io/](https://terragrunt.gruntwork.io/)
16. Amazon Web Services. *VPC User Guide*, *IAM User Guide*, *Amazon EKS User Guide*, *Secrets Manager* — documentación oficial consolidada por servicio.
17. Apache JMeter Project. *Apache JMeter*. Documentación oficial.
18. Informes finales de laboratorios 1–4 — repositorio del PI (`repositories/labs/`).

*(Ampliar con referencias exactas de libros por edición y año según norma que defina la facultad.)*