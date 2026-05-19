## Resumen

Este Proyecto Integrador propone una secuencia de **seis laboratorios técnicos** progresivos que articulan la formación en Ingeniería de Software y Gestión de la Calidad de Software con prácticas actuales de **DevOps**, **ingeniería de infraestructura** y **operación en la nube**, en línea con la **alianza entre la Universidad Nacional de Córdoba y Amazon Web Services (AWS)**. El trabajo no se limita a describir herramientas: busca que estudiantes y docentes dispongan de una experiencia ordenada, incremental y verificable que recorra el ciclo de vida de una aplicación moderna (desde el código hasta la observabilidad y el despliegue controlado), con énfasis en **automatización**, **calidad**, **seguridad**, **observabilidad**, **trazabilidad** y **trabajo colaborativo**.

En el **Laboratorio 1** se construyen imágenes **Docker** de un backend y un frontend, se automatiza la integración continua con **GitHub Actions**, se ejecutan **pruebas automatizadas** y análisis estático con **SonarCloud**, y se publican artefactos en **Amazon ECR** con una política explícita de ramas (`develop` / `main`) y repositorios de registro diferenciados para integración y producción. El **Laboratorio 2** introduce **Kubernetes** y **Helm** para desplegar esos mismos artefactos como cargas de trabajo orquestadas, exponiendo la aplicación mediante **Services**, **NodePort** e **Ingress**, y sentando bases para el ajuste de recursos y pruebas de estrés. El **Laboratorio 3** aborda **infraestructura como código** con **Terraform** sobre AWS, contrastando aprovisionamiento manual con flujos reproducibles y estado gestionado. El **Laboratorio 4** amplía el escenario hacia **Amazon EKS** y la observabilidad con **Prometheus** y **Grafana**, integrando charts de Helm en el ciclo de IaC. El **Laboratorio 5** incorpora **feature flags** y despliegues **canary** (en la propuesta, integración con **Split.io** u herramienta equivalente), habilitando liberación gradual y rollback basado en señales de calidad. Finalmente, el **Laboratorio 6** consolida un **pipeline integral** que une construcción de imágenes, aprovisionamiento, despliegue en Kubernetes, gestión de secretos y monitoreo, enlazando prácticas de operación con **métricas DORA** y tiempos de respuesta (MTTR y afines).

Como resultado esperado, la propuesta ofrece **guías y consignas** para el aula, **informes por laboratorio** y documentación de soporte, de modo que el PI funcione como **puente verificable** entre teoría y entornos productivos realistas, sin sacrificar la seguridad ni la idoneidad pedagógica.

**Palabras clave**: DevOps, Cloud Computing, Programming, Engineering education, Amazon Web Services, Kubernetes.

---

## Índice general

*(Pendiente: completar al cerrar la numeración definitiva de secciones en la versión final exportada a PDF.)*

---

## Índice de figuras

*(Pendiente.)*

---

## Índice de tablas

*(Pendiente.)*

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
| ALB    | Application Load Balancer (AWS ELB)                                 |
| NLB    | Network Load Balancer (AWS ELB)                                     |
| STS    | AWS Security Token Service                                          |
| IRSA   | IAM Roles for Service Accounts (EKS)                                |
| CNI    | Container Network Interface                                         |
| PDB    | PodDisruptionBudget                                                 |
| HPA    | Horizontal Pod Autoscaler                                           |
| PVC    | PersistentVolumeClaim                                               |
| CSI    | Container Storage Interface                                         |
| KMS    | AWS Key Management Service                                          |
| OIDC   | OpenID Connect                                                      |
| VPC    | Virtual Private Cloud (AWS)                                         |
| AZ     | Availability Zone                                                   |
| ELB    | Elastic Load Balancing (familia AWS)                                |
| ALB    | Application Load Balancer                                           |
| NLB    | Network Load Balancer                                               |
| ENI    | Elastic Network Interface                                           |
| ASG    | Auto Scaling Group                                                  |
| TSDB   | Time Series Database (Prometheus)                                   |
| PromQL | Prometheus Query Language                                           |
| ACM    | AWS Certificate Manager                                             |
| SNS    | Amazon Simple Notification Service                                  |
| RPS    | Requests per second (peticiones por segundo)                        |
| VU     | Virtual user (usuario virtual, en k6 / JMeter)                      |
| JTL    | JMeter text log (resultados de prueba)                              |
| JMX    | Archivo de plan de prueba de JMeter                                 |


---

# 1. Marco teórico

## 1.1 Introducción al marco

Este capítulo presenta los conceptos que permiten situar el Proyecto Integrador en el estado actual de la industria del software y de la operación de sistemas en la nube. El marco no pretende ser un manual de productos: busca ofrecer definiciones estables, relaciones entre ideas (por ejemplo, entre integración continua, registros de imágenes y orquestación) y un vocabulario común para los capítulos posteriores, donde se describirán las decisiones concretas adoptadas en cada laboratorio.

La propuesta del trabajo —seis laboratorios que van desde la **containerización** y el **pipeline** hasta **observabilidad**, **feature flags** y **despliegues progresivos**— exige integrar perspectivas que tradicionalmente estaban fragmentadas: desarrollo, calidad, seguridad y operaciones. El marco recorre esas capas en un orden que sigue en lo posible la progresión pedagógica: primero flujo de código y automatización cercana al desarrollador (Git, GitHub Actions, Docker, **Amazon ECR** como primera interfaz práctica con AWS en el Laboratorio 1), luego la aplicación como API y cliente web (REST, .NET, React), después calidad y seguridad en el pipeline, seguido de **Kubernetes**, **Helm** e **infraestructura como código** (Terraform, Terragrunt). Las herramientas de observabilidad, secretos y release progresivo se desarrollan antes de cerrar el capítulo con la **sección 1.14**, dedicada de manera exclusiva y exhaustiva al **ecosistema Amazon Web Services** que el PI utiliza o utilizará (IAM, ECR en profundidad, EKS, Secrets Manager, S3, DynamoDB para estado, CloudWatch, balanceadores, STS/IRSA, etc.), admitiendo solapamiento deliberado con apartados anteriores para que el lector disponga de un capítulo de consulta único sobre AWS.

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

El archivo `.gitignore` y políticas de **Git LFS** (cuando hubiese binarios pesados) merecen mención aunque este PI trabaje principalmente con texto y Dockerfiles: son parte del **contrato** entre repositorio y pipeline —lo que no está versionado no forma parte del artefacto reproducible.

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

Sobre **seguridad de cadena de suministro**, herramientas como **Trivy**, **Grype** o el escaneo integrado en registros detectan CVE en dependencias OS del contenedor. El marco del PI reconoce estos chequeos como complementarios al análisis estático de Sonar: cubren capas distintas del riesgo (dependencia vulnerable en la imagen base vs defecto lógico en el código C# o TypeScript).

## 1.7 Registro de contenedores y Amazon ECR

### 1.7.1 Rol del registro en la cadena CI/CD

Un **registro de contenedores** es el sistema de “paquetes binarios” para imágenes OCI/Docker: almacena **manifiestos** y **capas** (blobs) direccionables por contenido. Los clientes autenticados realizan **push** (publicar) y **pull** (consumir). La tripleta habitual es `registry/repositorio:tag`, pero la identidad fuerte de una imagen es el **digest** `sha256:…`, que referencia un manifiesto inmutable aunque varios tags apunten al mismo digest o se muevan tags entre builds.

*-Diagrama sugerido: flujo CI → `docker push` → registro → `kubectl`/nodo hace `pull` → container runtime desempaqueta capas → Pod en ejecución.-*

En el Laboratorio 1, el registro es el **primer punto de contacto sistemático de los alumnos con AWS**: antes de desplegar clusters o redes, ya deben comprender identidad (IAM), permisos mínimos, región y el contrato “mi pipeline escribe artefactos que otro actor leerá después”. Esa intuición prepara EKS (Laboratorio 4), donde los nodos o Fargate consumen las mismas imágenes desde ECR con políticas distintas.

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

En producción madura, el usuario IAM de larga duración se reemplaza por **OIDC**: GitHub Actions asume un **rol IAM** vía token OIDC sin almacenar `AWS_SECRET_ACCESS_KEY` en GitHub. El PI puede migrar a ese modelo cuando la cátedra lo habilite.

### 1.7.4 Tags, digest, inmutabilidad y políticas de ciclo de vida

El **tag** es puntero mutable salvo políticas explícitas: conviene combinar **tags inmutables por commit** (`main-abc1234`) con políticas de **retención** (lifecycle policies) que purguen imágenes antiguas y controlen costo de almacenamiento. **Tag immutability** a nivel de repositorio impide sobrescribir un tag existente —útil para `release-x.y.z`.

El **digest** permite auditar exactamente qué manifiesto desplegó Kubernetes (`imageID` en el Pod status). Cuando un incidente ocurre, correlacionar digest ↔ commit ↔ build CI es la trazabilidad buscada por DevOps.

### 1.7.5 Escaneo de imágenes y cumplimiento

**Amazon Inspector** (integración con ECR) u opciones de escaneo al push pueden reportar CVE en dependencias del sistema operativo de la imagen base. El Laboratorio 1 puede limitarse a **generar el informe**; laboratorios avanzados pueden definir **políticas de admisión** en Kubernetes (OPA/Gatekeeper, Kyverno) que rechazan pulls por severidad.

### 1.7.6 Replicación, latencia y costos

**ECR replication** permite copiar imágenes entre regiones para desastres o latencia de pull en entornos multi-región. Tiene costo de almacenamiento y transferencia; en el PI suele bastar una región (`us-east-1` en los workflows de ejemplo).

### 1.7.7 Estrategia del PI: ramas y repositorios ECR

La separación **develop vs main** se materializa con **repositorios ECR distintos** (p. ej. sufijo `-prd`), no solo tags distintos en un único repositorio. Ventajas: permisos IAM distintos (solo entorno prod puede pull del repo `-prd`), menor riesgo de promover por error una imagen experimental, claridad operativa para alumnos.

Cada push exitoso publica `ref_name-SHA` y `**latest`** en **ese** repositorio. Así `latest` significa “último build verde de esa línea”, no global.

*-Diagrama sugerido: dos columnas (repo DEV / repo PRD) mostrando de qué rama Git entra cada pipeline.-*

### 1.7.8 Relación ECR ↔ Kubernetes (anticipo teórico)

Los nodos de un clúster (Laboratorio 2 en adelante) deben poder hacer **pull** si el `imagePullSecrets` o el rol del nodo lo permiten. En **EKS**, la vía canónica es **IRSA** o permisos del worker node sobre ECR. Comprender ECR en Lab 1 evita confundir “mi imagen existe” con “el kubelet tiene derecho a descargarla”.

> **Nota:** Una exposición sistemática de cada servicio AWS —incluida una segunda capa de detalle sobre ECR dentro del mapa de servicios— se desarrolla en la **sección 1.14** de este mismo capítulo.

## 1.8 Puente hacia el ecosistema AWS

La nube de AWS se introduce en el Laboratorio 1 principalmente a través de **ECR** e **IAM** (credenciales usadas por GitHub Actions). Las dimensiones de **regiones**, **cuentas**, **facturación**, **VPC**, **EKS**, **Secrets Manager**, **S3** para estado de Terraform, **CloudWatch**, balanceadores y federación de identidades se tratan en profundidad en la **sección 1.14 — Marco teórico consolidado de Amazon Web Services**, para no fragmentar la teoría entre este apartado y los laboratorios posteriores. El presente apartado solo recuerda tres ideas transversales:

1. **Modelo de responsabilidad compartida**: AWS opera la infraestructura física y los servicios gestionados; el cliente configura correctamente IAM, redes y datos —los errores de permisos en ECR son responsabilidad del diseño de políticas, no “fallos del servicio”.
2. **Todo es API**: incluso la consola web invoca las mismas APIs; Terraform y los pipelines solo automatizan esas llamadas.
3. **Menor privilegio**: cada laboratorio amplía permisos sólo cuando la actividad lo exige (push ECR antes que `AdministratorAccess`).

## 1.9 API REST y arquitectura de la aplicación empleada en los labs

Una API **REST** modela recursos identificados por URLs y métodos HTTP (`GET`, `POST`, `PUT`, `DELETE`). Las respuestas usan códigos de estado estándar y formatos como JSON. Una especificación **OpenAPI** puede documentar contratos entre frontend y backend; facilita mocks y pruebas de contrato.

El backend del proyecto está desarrollado en **.NET** (**ASP.NET Core**) siguiendo una separación por capas habitual en aplicaciones empresariales: **Web** (controladores, configuración HTTP), **Business** (reglas y casos de uso) y **Data** (acceso a datos y repositorios). Este esquema reduce el acoplamiento y facilita pruebas unitarias sobre servicios.

El frontend es una **SPA** con **React 18**, empaquetada con **Vite** y componentes **Material UI (MUI)**. El build genera activos estáticos servidos por un contenedor liviano; las variables de entorno necesarias en tiempo de ejecución pueden inyectarse mediante scripts de entrada sin reconstruir la imagen para cada entorno.

Las **pruebas de contrato** entre frontend y backend pueden formalizarse si el OpenAPI generado o mantenido por la API se valida contra los clientes; en el PI, la prioridad inicial está en pruebas automatizadas de cada lado y en la integración visual/manual coordinada, dejando espacio a **Pact** o herramientas similares como extensión opcional.

En el backend, la inyección de dependencias del host **ASP.NET Core** permite sustituir implementaciones de repositorio en pruebas unitarias; en el frontend, **React Testing Library** favorece pruebas cercanas al uso real del usuario. Estos detalles refuerzan la idea de que “calidad” no es un paso final sino una propiedad que se diseña en la arquitectura.

## 1.10 Calidad y seguridad en el pipeline

La **pirámide de pruebas** sugiere muchas pruebas rápidas y aisladas en la base (unitarias), menos pruebas de integración en medio, y pocas pruebas end-to-end lentas en la cima. Automatizar pruebas en CI provee una red de seguridad repetible.

En el backend del PI, el workflow ejecuta `dotnet test` con recolección de cobertura en formato **OpenCover** compatible con el análisis. En el frontend, se ejecuta el script de tests con cobertura (`npm run test:coverage`) generando **lcov** para integración con SonarCloud.

**SonarCloud** (SaaS asociado al ecosistema SonarQube) realiza **análisis estático** de calidad y seguridad sobre el código. El backend usa **SonarScanner for .NET** entre pasos `begin`/`end` envolviendo build y tests; el frontend usa la acción oficial **SonarSource/sonarcloud-github-action**. Los tokens y claves de proyecto deben residir en **secrets** y **variables** de GitHub, no en el repositorio.

**CodeQL** es otra línea de análisis de seguridad disponible en GitHub para varios lenguajes; puede incorporarse como evolución futura si el director del PI lo exige. La distinción entre **SAST** genérico y reglas específicas de flujo de datos es relevante cuando se priorizan vulnerabilidades explotables.

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
| Local ligero    | **kind**, **minikube**, **k3s/k3d**, Docker Desktop Kubernetes | Laboratorio 2 en laptops; rápido de resetear; limitado en realismo de red/LB.           |
| Nube gestionada | **Amazon EKS**, GKE, AKS                                       | Laboratorios 4–6; integración IAM, ELB, VPC real; costo y curva de aprendizaje mayores. |
| Híbrido         | Cluster on-prem + nodos cloud                                  | Fuera del alcance inicial del PI.                                                       |


**Diferencia clave:** “Correr contenedores en la nube” puede significar **ECS**, **EC2 + Docker**, **Lambda**, etc.; **Kubernetes impone un modelo común** de Pods, Services y despliegues. La nube provee **infraestructura elástica**; Kubernetes provee **semántica de orquestación** sobre esa infraestructura.

*-Diagrama sugerido: tres columnas — Máquina única con Docker; Clúster K8s local de 1 nodo; EKS multi-AZ con NLB/ALB.-*

### 1.11.2 Plano de control y nodos trabajadores

El **plano de control** conserva el estado del sistema en **etcd** (almacén clave-valor distribuido), expone la **API** mediante `kube-apiserver`, asigna Pods a nodos mediante el **scheduler**, y ejecuta **controladores** que crean réplicas, endpoints, cuentas de servicio, etc.

Los **nodos worker** ejecutan **kubelet** (agente que arranca Pods hablando con el runtime), **kube-proxy** (reglas de red / iptables o IPVS hacia Services) y un **container runtime** compatible con CRI (**containerd** es el estándar actual).

Si el plano de control cae en un cluster auto-gestionado, el cluster deja de reconciliar estado; en **EKS**, AWS opera el plano de control y el usuario gestiona principalmente **worker nodes / Fargate**.

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
| **LoadBalancer** | Pide un balanceador externo al cloud controller                  | En AWS crea **NLB/ALB** según anotaciones; integración nativa con VPC.     |
| **ExternalName** | CNAME DNS                                                        | Integración con servicios externos.                                        |


**Headless Service** (`clusterIP: None`): sin VIP; DNS devuelve IPs de Pods —útil para StatefulSets y descubrimiento peer-to-peer.

### 1.11.5 Ingress y diferencia con Service

Un **Ingress** describe reglas **HTTP/HTTPS** (host, path, TLS). No hace nada solo: requiere un **Ingress Controller** (NGINX, Traefik, **AWS Load Balancer Controller** para ALB). Mientras un **Service** suele ser capa **L4** (TCP/UDP), Ingress opera **L7** (ruteo HTTP).

*-Arquitectura sugerida para imagen: Internet → ALB (AWS) → Ingress rules → Service ClusterIP → Pods.-*

En **Amazon EKS**, el **AWS Load Balancer Controller** observa objetos Ingress y provisiona **ALB** con target groups hacia Pods (normalmente vía IP mode en VPC CNI).

### 1.11.6 Imagen de contenedor en Kubernetes y relación con ECR

El campo `spec.containers[].image` referencia la misma cadena que Docker (`registry/repo:tag`). Para **ECR privado/público**, el nodo debe tener permisos IAM de **pull** o usar `**imagePullSecrets`** con credenciales generadas (`kubectl create secret docker-registry …`). En **EKS + IRSA**, los workloads pueden obtener credenciales temporales sin guardar AWS keys en el Secret de Kubernetes.

**imagePullPolicy**:

- `Always`: siempre consulta el registro (útil cuando `latest` se mueve).
- `IfNotPresent`: usa caché local si existe tag.
- `Never`: sólo local — raro salvo air-gapped.

### 1.11.7 Recursos, calidad de servicio (QoS) y escalado

**requests** y **limits** de CPU/memoria influyen en el scheduling y en el comportamiento ante presión de recursos: sobrepasar límites de CPU puede throttle; sobrepasar mem puede significar **OOMKill**.

Clases **QoS**: `Guaranteed` (requests=limits), `Burstable`, `BestEffort`. Importante al interpretar métricas bajo estrés en Laboratorio 2.

**Horizontal Pod Autoscaler (HPA)** escala réplicas según CPU/memoria u órdenes externas (métricas personalizadas + Prometheus adapter). Requiere **metrics-server** instalado.

**Vertical Pod Autoscaler** (opcional) sugiere requests/limits históricos.

### 1.11.8 Observabilidad interna del Pod: probes

- **livenessProbe**: si falla, kubelet reinicia el contenedor (la app “atascada”).
- **readinessProbe**: si falla, el Pod se saca del Service endpoints (no recibe tráfico).
- **startupProbe**: para apps lentas al iniciar; evita falsos positivos en liveness temprano.

Mal diseñadas, las probes son causa #1 de reinicios en bucle bajo carga.

### 1.11.9 ConfigMaps, Secrets y RBAC

**ConfigMap** para configuración no sensible (feature toggles estáticos, URLs); **Secret** para datos sensibles (base64 en etcd — **habilitar encryption at rest** en clusters serios). **RBAC** (`Roles`, `ClusterRoles`, `Bindings`) controla qué identidades pueden leer Secrets en qué namespaces —pedagógicamente crítico en equipos multi-tenant simulados.

### 1.11.10 Almacenamiento: volúmenes y CSI

**emptyDir** es efímero al Pod. **PVC** solicita al **StorageClass** un volumen dinámico (EBS CSI en EKS). Los **CSI drivers** estandarizan plug-ins de almacenamiento.

### 1.11.11 Red avanzada y políticas

**CNI** (Calico, Cilium, AWS VPC CNI en EKS) implementa redes Pod-to-Pod. **NetworkPolicy** filtra tráfico east-west (allow-list); sin políticas, muchos clusters permiten todo entre Pods —riesgo en zero-trust.

### 1.11.12 Scheduling avanzado y alta disponibilidad

**Taints/tolerations** reservan nodos para cargas especiales (GPU). **Affinity/anti-affinity** distribuye réplicas entre AZs. **PodDisruptionBudget** protege disponibilidad durante **drains** de nodos (kubelet evictions).

### 1.11.13 Comandos y flujo operativo habitual (`kubectl`)


| Acción             | Comando ilustrativo                                           |
| ------------------ | ------------------------------------------------------------- |
| Contexto / cluster | `kubectl config use-context`, `kubectl cluster-info`          |
| Namespace          | `kubectl get pods -n <ns>`                                    |
| Estado deseado     | `kubectl apply -f manifiesto.yaml`                            |
| Inspeccionar       | `kubectl describe pod`, `kubectl logs`, `kubectl get events`  |
| Debugging efímero  | `kubectl exec -it pod -- sh`, `kubectl port-forward svc/…`    |
| Rollout            | `kubectl rollout status deployment/…`, `kubectl rollout undo` |


*-Diagrama sugerido: ciclo operador — edit manifest → apply → observar Deployment conditions → revisar logs si CrashLoopBackOff.-*

### 1.11.14 Namespaces, etiquetas y multi-entorno

Los **namespaces** segmentan recursos lógicamente (`dev`, `staging`, `prd`). Las **labels** (`app=device-manager`, `tier=frontend`) conectan Deployments con Services. Patrones **GitOps** (Flux, Argo CD) verían esta misma API —fuera del alcance inicial pero contextualizan el Laboratorio 6.

### 1.11.15 Seguridad en runtime

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

### 1.12.4 Hooks, tests y buenas prácticas

**Hooks** (`pre-install`, `post-upgrade`, …) ejecutan Jobs en puntos del ciclo de vida; pueden bloquear si fallan —hay que diseñarlos idempotentes.

**Helm tests** (`helm test`) lanzan Pods de verificación post-install —buena práctica para smoke tests automáticos.

### 1.12.5 Helm en el PI (Laboratorios 2, 4 y 6)

Los manifiestos del Laboratorio 2 parametrizan **imagen ECR**, **réplicas**, **Service type**, **Ingress host**. En Laboratorio 4–6, charts oficiales despliegan **Prometheus/Grafana** sobre el mismo modelo: valores separados por entorno (`values-staging.yaml`, `values-prd.yaml`) evitan bifurcar plantillas.

### 1.12.6 Errores frecuentes y malentendidos (guía rápida)

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

El backend recomendado en AWS combina:

- **Amazon S3**: versionado opcional, cifrado SSE-S3 o SSE-KMS, políticas IAM de acceso por cuenta/rol.
- **Amazon DynamoDB**: tabla con **locking** condicional para que solo un `apply` modifique el estado a la vez.

Configuración típica:

```hcl
terraform {
  backend "s3" {
    bucket         = "mi-org-tf-state"
    key            = "eks/lab4/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

*-Imagen sugerida: consola S3 mostrando objeto `terraform.tfstate` versionado y tabla DynamoDB con partición LockID.-*

### 1.13.3 Módulos reutilizables

Un **módulo** es un paquete de recursos parametrizados (`modules/vpc`, `modules/eks`). Permite DRY (Don't Repeat Yourself) y versionado por **Git tags** o **Terraform Registry**. Inputs tipados (`validation` blocks) previenen valores ilegales (CIDR incorrectos).

### 1.13.4 Terragrunt — capa de orquestación sobre Terraform

**Terragrunt** (HashiCorp ecosystem, proyecto separado) envuelve Terraform para:

- **DRY de backends**: un `terragrunt.hcl` raíz define backend S3/Dynamo una vez; hijos heredan.
- **Dependencias entre stacks**: `dependency "vpc" { config_path = "../vpc" }` expone outputs como inputs sin copiar manualmente.
- **Múltiples entornos** (`dev/staging/prd`) como carpetas con `terraform.tfvars` distintos pero mismo código de módulo.

Flujo típico: `terragrunt run-all plan` en orden DAG de dependencias.

*-Diagrama sugerido: árbol de carpetas `live/dev/us-east-1/eks` apuntando a módulos remotos `modules//eks`.-*

No sustituye Terraform: genera `.terraform` y delega en binarios oficiales. En el PI puede adoptarse cuando crece el número de stacks (Laboratorio 3–6).

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
- **Alertmanager**: deduplica, agrupa, enruta alertas a Slack/PagerDuty.

En Kubernetes, **kube-prometheus-stack** despliega **node-exporter**, **kube-state-metrics** y adaptadores para exponer métricas del plano de datos.

Consultas **PromQL** ejemplo: `rate(http_requests_total[5m])`, `histogram_quantile(0.99, …)`.

*-Diagrama sugerido: targets → Prometheus → Grafana dashboards / Alertmanager → Slack.-*

### 1.13.7 Grafana — visualización, dashboards y alertas

**Grafana** consume datasources (Prometheus, Loki, CloudWatch) para construir **dashboards** declarativos en JSON o provisioning YAML. Soporta:

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

### 1.13.9 Grafana k6 — herramienta y conceptos de prueba de carga

#### ¿Qué es k6?

**k6** (hoy comercializado como **Grafana k6**) es una herramienta **open source** de **pruebas de carga** y rendimiento orientada a desarrolladores y pipelines CI/CD. El proyecto fue creado por Load Impact y pasó al ecosistema **Grafana Labs**; el binario está escrito en **Go** y es liviano (no requiere JVM). Los escenarios se escriben en **JavaScript** (compatibilidad ES6 según versión) mediante la API de k6: se define qué peticiones HTTP/gRPC (u otros protocolos vía extensiones) ejecuta cada **usuario virtual** y cómo evoluciona la carga en el tiempo.

En la práctica, k6 **simula muchos clientes concurrentes** que golpean la aplicación (API REST del Device Manager, Ingress en Kubernetes, balanceadores en AWS, etc.) y **mide** cómo responde el sistema (latencias, errores, throughput). Los resultados sirven para validar **SLAs** internos del laboratorio (“p95 < 500 ms con 200 RPS”), detectar cuellos de botella antes de producción y complementar el **Horizontal Pod Autoscaler**, porque muestran saturación incluso cuando el autoscaler aún no ha añadido réplicas.

Ejecución típica: `k6 run script.js` en CLI; también existe **k6 Cloud** (SaaS) para distribuir generación de carga geográficamente y guardar históricos —opcional en el PI si la cátedra lo habilita.

#### Conceptos generales de ingeniería de carga (aplicables a k6 y a JMeter)

Antes de nombrar ejecutores concretos de k6, conviene fijar vocabulario común:


| Concepto                     | Explicación breve                                                                                                                                                                                      |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Usuario virtual (VU)**     | Lógica de ejecución independiente (un “actor” que repite un guion: login, listar, crear recurso). No equivale a un humano real con tiempo de reflexión largo salvo que se modele **think time**.       |
| **Iteración**                | Una pasada completa del guion definido en el script (por ejemplo todas las peticiones del escenario default).                                                                                          |
| **Throughput / RPS**         | Peticiones completadas por segundo (**requests per second**, a veces **iteraciones por segundo**). Indica **capacidad de servicio** bajo carga.                                                        |
| **Latencia**                 | Tiempo entre envío de solicitud y respuesta completa. Suele reportarse como **p50** (mediana), **p95**, **p99**: percentil 95 significa “el 95 % de las peticiones fueron más rápidas que este valor”. |
| **Tasa de error**            | Porcentaje de respuestas HTTP no exitosas (4xx/5xx) o timeouts; umbrales típicos en CI (`< 1 %`).                                                                                                      |
| **Saturation / utilización** | En el sistema bajo prueba: CPU/memoria de Pods, colas en balanceador, **connection limits**. Cuando la latencia crece y los errores aparecen sin más CPU disponible, el servicio está **saturado**.    |


**Tipos de prueba** (patrones de comportamiento en el tiempo):

- **Smoke / sanity**: carga **mínima** para verificar que el endpoint responde y el script funciona; no evalúa capacidad.
- **Load / carga nominal**: intensidad cercana al **tráfico esperado** en operación normal (o al objetivo del Laboratorio); sirve para validar SLAs “de día a día”.
- **Stress / estrés**: se **incrementa la carga más allá** del nivel nominal hasta encontrar **degradación** o fallos; objetivo: conocer **punto de quiebre**, comportamiento bajo presión y recuperación.
- **Spike / pico**: aumento **brusco y corto** de concurrencia o de tasa de llegada (simula viralización o reapertura); evalúa si el sistema **absorbe el golpe** (autoscaler, colas, circuit breakers).
- **Soak / endurance / resistencia**: carga **moderada pero prolongada** (horas); revela **fugas de memoria**, agotamiento de conexiones, degradación lenta o problemas de disco/log.

**Ramping (rampa)**: subida o bajada **gradual** de usuarios virtuales o de **tasa de llegada** en el tiempo, en lugar de pasar de 0 a 1000 instantáneamente. Sirve para calentar cachés, dejar estabilizar réplicas del HPA o imitar el arranque de un evento real.

**Ramping arrival rate** (modelo que k6 expone como *executor*): en lugar de fijar solo “N usuarios concurrentes”, se controla **cuántas nuevas iteraciones por segundo** se **arrancan** (tasa de llegada al sistema). Es útil cuando el negocio piensa en **pedidos por segundo** más que en “usuarios”. Se combina con duración de rampa (`startRate`, `timeUnit`, etapas `preAllocatedVUs` / `maxVUs` para que el motor pueda abrir más VUs si hace falta cumplir la tasa).

**Constant VUs**: número fijo de usuarios virtuales que ejecutan el guion en bucle durante un tiempo; cada VU inicia la siguiente iteración según termina la anterior (salvo `sleep`). Es el modelo más intuitivo para empezar.

#### Ejecutores y elementos específicos de k6

k6 agrupa la lógica en **executors** (estrategias de cómo programar VUs e iteraciones):

- `**shared-iterations*`*: total de iteraciones repartidas entre VUs —útil cuando se quiere un número fijo de ejecuciones globales.
- `**per-vu-iterations**`: cada VU ejecuta exactamente N iteraciones.
- `**constant-vus**`: mantiene un número constante de VUs durante un tiempo.
- `**ramping-vus**`: rampas de concurrencia (sube/baja el número de VUs por etapas).
- `**ramping-arrival-rate**`: rampas de **tasa de llegada** (iteraciones/segundo u otra unidad según configuración).

**Checks**: aserciones por respuesta (`check(response, { 'status es 200': (r) => r.status === 200 })`); no detienen el test por defecto pero dejan trazabilidad.

**Thresholds (`thresholds`)**: criterios de fallo del ensayo global (`http_req_duration: ['p(95)<500']`, `http_req_failed: ['rate<0.01']`). Si se violan, k6 termina con código distinto de cero —ideal para **fallar el pipeline** CI cuando el rendimiento regresa.

**Salida**: métricas integradas (`http_req_duration`, `http_reqs`, `vus`, `iteration_duration`, …); integración con **Prometheus** (remote write), JSON, CSV o Grafana Cloud.

*-Diagrama sugerido: generador k6 → balanceador → Ingress → Pods → métricas Prometheus correlacionadas en Grafana.-*

### 1.13.10 Apache JMeter — herramienta complementaria de carga

#### ¿Qué es JMeter?

**Apache JMeter** es una aplicación **Java** de código abierto pensada inicialmente para pruebas de carga web y hoy extendida a FTP, JDBC, JMS, SOAP/REST, etc. A diferencia de k6 (orientado a código + CLI), JMeter ofrece una **interfaz gráfica (GUI)** para **grabar y ensamblar** planes de prueba: **Thread Groups** (hilos = usuarios virtuales), **Samplers** (petición HTTP), **Listeners** (tablas y gráficos de resultados), **Timers** (think time), **Assertions** y elementos de configuración (cookies, cabeceras).

El modelo mental es **hilos concurrentes** que ejecutan el árbol de elementos en bucles; la GUI consume **mucha memoria** para cargas grandes, por lo que en serio se usa **modo non-GUI** (`jmeter -n -t plan.jmx -l resultados.jtl`) al igual que **distributed testing** con **master/slaves** para superar el límite de una sola JVM.

#### ¿Cuándo usar JMeter frente a k6?


| Criterio                          | k6                                | JMeter                                     |
| --------------------------------- | --------------------------------- | ------------------------------------------ |
| Curva de aprendizaje CI/script    | Alta para quien ya programa JS    | GUI amigable para exploración manual       |
| Consumo de recursos del generador | Bajo (binario Go)                 | JVM; puede requerir más RAM y tuning heap  |
| Protocolos y plugins              | HTTP/gRPC muy maduros; extensible | Muy amplio ecosistema legacy (SOAP, JDBC…) |
| Integración pipeline              | Nativa, thresholds, salida JSON   | Requiere parsear JTL/XML o usar plugins    |


En el marco del PI, **k6** encaja como **herramienta por defecto** para laboratorios cloud/Kubernetes por ligereza y código versionado; **JMeter** aporta valor cuando el docente o el alumno necesitan **prototipar interacciones complejas en GUI**, integrar **BD** con JDBC o reutilizar planes corporativos ya existentes en `.jmx`. Las **definiciones de tipos de prueba** (stress, spike, ramping, métricas) de la subsección anterior aplican igual: solo cambia el mecanismo para expresar rampas (por ejemplo **Ultimate Thread Group** con plugins o escalones en Thread Group).

*-Imagen sugerida: captura de la GUI de JMeter con Thread Group + HTTP Request + Summary Report.-*

### 1.13.11 Figuras conceptuales (descripción textual)

Para cuando el informe se exporte a PDF con diagramas formales, aquí se anticipa la narrativa de tres vistas útiles:

**Vista A — Flujo Laboratorio 1 (desde cambio hasta registro):** un desarrollador abre una **PR** hacia `develop` o `main`; GitHub Actions ejecuta **checkout**, restauración de dependencias, **build**, **tests con cobertura**, **SonarCloud**. Si el job `ci` falla, el equipo corrige antes del merge. Tras merge/push a una rama protegida, el job **build-and-push** construye la imagen Docker con Buildx, autentica contra AWS, etiqueta con `rama-SHA` y `latest`, y publica en el **repositorio ECR** correspondiente (`develop` vs `main`). Opcionalmente, en `main`, un job **release** crea una versión visible en GitHub Releases para trazabilidad humana.

**Vista B — Capas de responsabilidad:** en la base, **infraestructura AWS** (red, IAM, registro); sobre ella **artefactos de imagen** inmutables; encima **Kubernetes** como plano de ejecución; finalmente **observabilidad** y **políticas de despliegue** que cierran el ciclo con feedback hacia desarrollo.

**Vista C — Separación dev/prd en registro:** dos repositorios ECR paralelos reciben líneas de vida distintas de la misma base de código; `latest` en cada uno apunta al último build válido **de esa línea**.

Estas vistas deben convertirse más adelante en figuras numeradas para el **Índice de figuras** cuando el documento se congele.

### 1.13.12 Límites del marco y trabajo futuro

Este marco **no** sustituye la documentación oficial ni los manuales de laboratorio: sintetiza conceptos para lectura continua. Ciertos temas —optimización de costos FinOps, multi-region active-active, service meshes como Istio o Linkerd, políticas OPA/Gatekeeper— quedan fuera del núcleo pedagógico pero pueden mencionarse en ampliaciones futuras de la tesis o en trabajos derivados.

---

## 1.14 Marco teórico consolidado de Amazon Web Services (AWS)

Esta sección concentra la teoría de los **servicios AWS** que el PI utiliza o prevé utilizar. Se acepta **solapamiento** con §1.7 y §1.11 cuando el concepto ya se anticipó: aquí el foco es **mapa de servicios**, **integraciones** y **detalle operativo** útil como referencia única.

*-Diagrama sugerido: mapa mental “AWS Organizations → cuenta → región → VPC → AZ → subnets → servicios anclados”.-*

### 1.14.1 Modelo global: regiones, zonas de disponibilidad y Local Zones

**AWS** particiona el mundo en **Regiones** (`us-east-1`, `sa-east-1`, …), cada una con múltiples **Availability Zones (AZ)** — centros de datos separados físicamente conectados por red de baja latencia. Diseñar para HA implica repartir réplicas entre AZ (Kubernetes `topologySpreadConstraints`, RDS Multi-AZ, etc.).

**Local Zones** y **Wavelength** existen para latencia ultra baja; no son núcleo del PI salvo casos especiales.

### 1.14.2 Modelo de responsabilidad compartida y cumplimiento

AWS opera la infraestructura física y los hipervisores de servicios gestionados; el cliente configura correctamente **IAM**, **cifrado**, **parches invitados en EC2**, **security groups**, datos sensibles. Errores de configuración no son “fallos del proveedor”.

### 1.14.3 Identidad y acceso: IAM en profundidad

**IAM** define:

- **Usuarios**: identidad humana o técnica con **Access Key** (ID + Secret) — evitar en prod madura; rotar y scope mínimo.
- **Roles**: entidades asumidas vía **STS AssumeRole** con credenciales temporales (**AccessKeyId**, **SecretAccessKey**, **SessionToken**).
- **Políticas JSON**: listas `Allow`/`Deny` sobre acciones (`ecr:BatchGetImage`) y recursos (ARN).
- **Federación OIDC/SAML**: GitHub → OIDC → rol IAM sin secretos estáticos.

**ARN** (`arn:partition:service:region:account-id:resource-type/resource-id`) identifica unívocamente recursos.

**Buenas prácticas PI**: políticas por laboratorio; etiquetas **cost allocation tags**; sin `AdministratorAccess` en usuarios estudiantiles.

### 1.14.4 Amazon ECR — segunda profundización (registro como columna vertebral)

(véase también §1.7) ECR es el servicio que materializa el vínculo entre **artifact** y **cuenta AWS**. Puntos adicionales:

- **Replication**: políticas multi-región para DR.
- **Lifecycle policies**: purga automática de imágenes sin tags o antiguas.
- **Image scanning**: integración con **Amazon Inspector** para CVE.

Permiso mínimo pull desde EKS: política en instancia worker o IRSA en Pod.

### 1.14.5 Redes: VPC, subnets, route tables, Internet Gateway, NAT

**VPC**: red virtual aislada (CIDR privado). **Subnets** públicas (ruta `0.0.0.0/0` → **Internet Gateway**) vs privadas (salida vía **NAT Gateway** para updates sin IP pública). **Security Groups** (stateful firewall a nivel de ENI) vs **NACL** (stateless, subnet).

Para **EKS**, el **AWS VPC CNI** asigna IPs de la VPC directamente a Pods (modo tráfico ENI) — implica planificar tamaños de subnet.

*-Diagrama sugerido: VPC con subnets públicas (ALB) y privadas (workers, Pods).-*

### 1.14.6 Balanceo de carga: ELB, ALB, NLB

**Classic Load Balancer** (legacy). **Application Load Balancer (ALB)**: HTTP/S, routing L7, integración nativa con **Ingress** en EKS. **Network Load Balancer (NLB)**: TCP/UDP de muy baja latencia, IPs estáticas, preservación de IP origen.

Target types: **instance** vs **IP** (para Pods en VPC CNI).

### 1.14.7 Amazon EKS — Kubernetes administrado en AWS

**EKS** ejecuta el **plano de control** como servicio; el cliente administra **node groups** (EC2 con AMI optimizada) o **Fargate** (sin gestionar instancias).

Integraciones clave:

- **eksctl**, **Terraform AWS EKS module**
- **IAM Roles for Service Accounts (IRSA)**: anotaciones ServiceAccount → rol IAM → tokens OIDC web identity
- **Cluster Autoscaler** / **Karpenter** para nodos elásticos
- **Load Balancer Controller** para ALB/NLB desde Ingress

*-Diagrama sugerido: control plane AWS-managed ↔ API ↔ worker nodes ASG ↔ Pods ↔ ECR pull.-*

### 1.14.8 Computación: EC2 y AMIs

**EC2** provee máquinas virtuales; **Auto Scaling Groups** mantienen capacidad deseada. Los nodos EKS son EC2 con disco, tipo instancia elegido según carga (CPU vs network optimized).

### 1.14.9 Almacenamiento: EBS, S3

**EBS** volúmenes por AZ para estado durable de bases en EC2; snapshots a S3.

**Amazon S3** es **objeto** altamente durable; caso PI típico: **Terraform remote state**, artefactos de build, logs estáticos. Versionado + **SSE-KMS** recomendado para buckets de estado.

### 1.14.10 Amazon DynamoDB

Base NoSQL serverless con modelo clave-valor y documentos; **uso PI**: tabla de **Terraform lock** (partition key `LockID`). Puede servir también como backend de feature flags caseros —no es el caso si se usa Split SaaS.

### 1.14.11 AWS Secrets Manager y Systems Manager Parameter Store

**Secrets Manager**: secretos **rotativos** automáticos para RDS, API keys con políticas de rotación lambda.

**Parameter Store** (Standard vs Advanced): configuración no sensible o secretos simples con histórico.

La Solicitud del PI cita **Secrets Manager** como referencia para gestión segura frente a YAML plano.

### 1.14.12 AWS KMS — cifrado

**KMS** gestiona **Customer Master Keys (CMK)**; uso: cifrado **S3**, **EBS**, **Secrets Manager**, **logs**. Integración IAM granular (`kms:Decrypt`).

### 1.14.13 AWS CloudWatch — métricas, logs y alarmas

**CloudWatch Metrics**: métricas estándar EC2, ELB, personalizadas via API.

**CloudWatch Logs**: agregación de logs; **insights** para consultas.

**Alarms**: disparan **SNS** → email/Slack/Lambda — útil si Grafana no está disponible en un laboratorio intermedio.

### 1.14.14 AWS STS y federación GitHub → AWS

**STS AssumeRoleWithWebIdentity** permite que GitHub Actions sin secretos AWS largos obtenga credenciales temporales si el admin creó **OIDC identity provider** en IAM y trust policy del rol referencia `repo:org/name:ref`.

### 1.14.15 Amazon Inspector y seguridad postura

**Inspector** escanea EC2, ECR imágenes, Lambda —informe CVE priorizado. Complementa Sonar / escaneo dependencias.

### 1.14.16 Route 53 (DNS)

**Route 53** hospeda zonas públicas/privadas; registros **ALIAS** hacia ALB. En Ingress EKS suele automatizarse DNS externo + cert **ACM**.

### 1.14.17 AWS Certificate Manager (ACM)

Emite certificados TLS para ALB/Ingress; renovación automática cuando validación DNS/route funciona.

### 1.14.18 Costos, etiquetado y Budgets

**Cost Explorer** + **Budgets** alertan deriva de gastos —crítico en cuentas educativas compartidas.

### 1.14.19 Relación servicios AWS ↔ laboratorios PI (tabla guía)


| Servicio AWS                            | Laboratorio típico |
| --------------------------------------- | ------------------ |
| IAM, ECR                                | 1                  |
| VPC concepts (cuando se use EKS pronto) | 2–4                |
| Terraform state S3 / DynamoDB           | 3                  |
| EKS, ELB, EC2                           | 4                  |
| Secrets Manager + KMS                   | 5–6                |
| CloudWatch end-to-end                   | 4–6                |


*-Nota para diseño gráfico: esta tabla puede pasarse al Índice de tablas como Tabla X.-*

---

# 2. Requerimientos y alcance del PI

## 2.1 Objetivo general

Diseñar y desarrollar una propuesta pedagógica basada en laboratorios técnicos iterativos que aborden de forma progresiva conocimientos y herramientas de **DevOps**, **cloud AWS** y **ingeniería de infraestructura**, fortaleciendo la vinculación entre teoría académica y práctica profesional, y potenciando la **alianza AWS-UNC**.

## 2.2 Objetivos parciales (por laboratorio)


| Lab | Objetivo parcial                                                                                           |
| --- | ---------------------------------------------------------------------------------------------------------- |
| 1   | Containerizar aplicación, automatizar CI/CD hasta registro ECR con pruebas y análisis estático.            |
| 2   | Desplegar cargas en Kubernetes con Helm; exponer servicios (NodePort/Ingress); bases de escalado y estrés. |
| 3   | Provisionar infraestructura en AWS con Terraform y buenas prácticas de estado y módulos.                   |
| 4   | Desplegar EKS con Terraform e integrar observabilidad (Prometheus/Grafana) vía Helm.                       |
| 5   | Incorporar feature flags y despliegues canary con segmentación de tráfico y rollback.                      |
| 6   | Integrar pipeline completo (build, IaC, deploy Helm, secretos, monitoreo, métricas tipo DORA).             |


## 2.3 Usuarios y destinatarios

- **Estudiantes** de materias vinculadas (Ingeniería de Software, Gestión de la Calidad de Software): ejecutan guías, cumplen consignas y documentan resultados.
- **Docentes**: adoptan o adaptan materiales, evalúan entregas y validan el alcance pedagógico.
- **Organización del proyecto**: los autores del PI mantienen consistencia entre repos, infraestructura de ejemplo y documentación.

## 2.4 Requerimientos funcionales (resumen)

- RF1: Disponer de una aplicación de referencia con API y cliente web desplegables como contenedores.
- RF2: Automatizar build, test y publicación de imágenes con política de ramas y registro.
- RF3: Proveer material didáctico por laboratorio (guía, consignas, informe modelo o informe final).
- RF4–RFn: Completar progresivamente despliegue en K8s, IaC, EKS, flags y pipeline integral según la Solicitud aprobada.

## 2.5 Requerimientos no funcionales

- **Seguridad**: secretos fuera del código; IAM mínimo; análisis estático en CI.
- **Reproducibilidad**: pipelines declarativos; infraestructura versionada.
- **Mantenibilidad**: documentación clara y decisiones justificadas.
- **Costo**: uso responsable de cuentas AWS en contexto académico.

## 2.6 Riesgos principales

- Complejidad de permisos AWS y costos inadvertidos → mitigación con límites, etiquetado y revisión.
- Divergencia entre documentación y estado real de repos → mitigación con revisión periódica de workflows.
- Sobrecarga estudiantil → mitigación con entregas incrementales y criterios de aceptación explícitos.

---

# 3. Selección de herramientas y stack


| Componente            | Elección                         | Justificación breve                                                   |
| --------------------- | -------------------------------- | --------------------------------------------------------------------- |
| Backend               | .NET 9 / ASP.NET Core            | Tipado fuerte, ecosistema empresarial, buen soporte Docker y pruebas. |
| Frontend              | React + Vite + MUI               | SPA moderna, build rápido, componentes accesibles.                    |
| CI/CD                 | GitHub Actions                   | Integración nativa con el código; mercado de acciones maduro.         |
| Registro              | Amazon ECR                       | Alineación AWS-UNC y continuidad hacia EKS.                           |
| Calidad               | SonarCloud + tests automatizados | Feedback temprano sobre deuda y cobertura.                            |
| Orquestación (Lab 2+) | Kubernetes + Helm                | Estándar de industria; charts reutilizables.                          |


---

# 4. Actividades desarrolladas — Laboratorios

## 4.1 Laboratorio 1 — Construcción de imágenes Docker y automatización de push

### 4.1.1 Objetivo

Construir imágenes Docker del backend y del frontend, ejecutar **integración continua** con pruebas y **SonarCloud**, y publicar automáticamente en **Amazon ECR** con separación de repositorios según la rama (`develop` vs `main`), incluyendo tags por commit y `latest`.

### 4.1.2 Resumen de tareas realizadas

1. **Cuenta AWS e IAM**: credenciales usadas vía **GitHub Secrets** (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`), sin valores en el código.
2. **Backend (.NET)**: solución en capas Web / Business / Data; Dockerfile multi-stage; escucha en puerto 8080 en runtime.
3. **Frontend (React)**: Dockerfile con build estático y servidor de archivos; configuración runtime para URL de API.
4. **Pipeline GitHub Actions**: job `ci` ejecuta tests + SonarCloud; job `build-and-push` construye con Buildx y publica en ECR **solo en push** a `develop` o `main`, eligiendo el repositorio ECR de desarrollo o producción según la rama. Tag principal `ref_name-SHA` más `latest`. Job **release** en backend crea GitHub Release en pushes a `main`.
5. **Política de ramas**: documentada en el workflow — integración vía PR sin push directo a ramas protegidas.

### 4.1.3 Referencia cruzada

El detalle pedagógico y las subsecciones de marco teórico específicas del laboratorio se encuentran en **[Informe final — Lab 1](../../lab1/informe-final-lab1.md)**. Este capítulo del informe PI sintetiza decisiones y evidencia para lectura global de la tesis.

### 4.1.4 Coherencia con el repositorio (verificación)

Los workflows en `backend/device-manager-api/.github/workflows/build.yml` y `frontend/device-manager-app/.github/workflows/build.yml` confirman: **dotnet test** con cobertura OpenCover y **SonarScanner** en backend; **npm run test:coverage** y **SonarCloud GitHub Action** en frontend; **ECR público** con repositorios distintos para `develop` y `main`; push de imagen condicionado al éxito del CI.

## 4.2 Laboratorio 2 — Kubernetes y Helm

Estado: **en curso / documentación parcial**. Se prevé narrar despliegue con manifiestos y charts Helm bajo `ICOMP-UNC-pi-2025-Infra-lab2/Kubernetes/`, exposición NodePort/Ingress, límites de recursos y pruebas de estrés. Completar este apartado al cerrar el informe del Lab 2.

## 4.3 Laboratorio 3 — Terraform en AWS

*(Pendiente de redacción según avance del PI.)*

## 4.4 Laboratorio 4 — EKS y observabilidad

*(Pendiente.)*

## 4.5 Laboratorio 5 — Feature flags y canary

*(Pendiente.)*

## 4.6 Laboratorio 6 — Pipeline integral

*(Pendiente.)*

---

# 5. Conclusiones

*(Pendiente: cerrar al finalizar los laboratorios y la evaluación de resultados frente a la Solicitud del PI. Incluir dificultades, amenazas superadas y trabajo futuro —mantenimiento de guías, métricas de adopción en cátedra si aplica—.)*

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
16. Amazon Web Services. *VPC User Guide*, *IAM User Guide*, *Elastic Load Balancing*, *CloudWatch*, *Secrets Manager* — documentación oficial consolidada por servicio.

*(Ampliar con referencias exactas de libros por edición y año según norma que defina la facultad.)*