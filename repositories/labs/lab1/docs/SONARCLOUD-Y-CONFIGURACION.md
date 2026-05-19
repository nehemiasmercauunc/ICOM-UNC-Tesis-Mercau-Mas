# Configuración de SonarCloud y secrets para los workflows (Lab 1)

Para que los pipelines de **backend** y **frontend** ejecuten tests y análisis con SonarCloud, y publiquen imágenes en ECR (repos develop y main), tenés que configurar lo siguiente en **cada** repositorio (backend y frontend) en GitHub.

---

## 1. SonarCloud (análisis estático y cobertura)

### 1.1 Crear cuenta y proyecto en SonarCloud

1. Entrá a [sonarcloud.io](https://sonarcloud.io) e iniciá sesión con **GitHub**.
2. Creá una **Organization** si no tenés (por ejemplo con el nombre de tu usuario o del equipo).
3. **Analizar un nuevo proyecto** → elegí el repositorio (por ejemplo `device-manager-api` para backend).
4. SonarCloud te va a dar:
   - **Organization key** (ej. `tu-usuario-github` o el nombre que hayas puesto).
   - **Project key** (ej. `tu-usuario-github_device-manager-api` o el que asigne SonarCloud).
5. Repetí el proceso para el **segundo** repositorio (frontend): otro proyecto en SonarCloud para ese repo.

### 1.2 Token de SonarCloud

1. En SonarCloud: **My Account** (arriba a la derecha) → **Security** → **Generate Tokens**.
2. Dale un nombre (ej. `github-actions-backend`) y generá el token.
3. **Copiá el token** (solo se muestra una vez).

### 1.3 Configurar en cada repositorio de GitHub

En **cada** repo (backend y frontend):

1. **Settings** → **Secrets and variables** → **Actions**.
2. **Secrets** (New repository secret):
   - Nombre: `SONAR_TOKEN`  
   - Valor: el token que generaste en SonarCloud (podés usar el mismo token para ambos repos o uno por repo).
3. **Variables** (Variables tab → New repository variable):
   - `SONAR_ORGANIZATION`: la **Organization key** de SonarCloud (ej. `tu-usuario-github`).
   - `SONAR_PROJECT_KEY`: el **Project key** del proyecto de ese repo en SonarCloud (ej. `tu-usuario-github_device-manager-api`).

### 1.4 Análisis automático vs CI (GitHub Actions)

Si en SonarCloud tenés activado **Automatic Analysis** para el repositorio y además corrés el scanner desde **GitHub Actions**, el análisis falla con:

`You are running CI analysis while Automatic Analysis is enabled`

**Solución (elegí una):**

- **Recomendado para este lab:** en SonarCloud, abrí el **proyecto** → **Administration** → **Analysis Method** (o el asistente de análisis del repo) y **desactivá Automatic Analysis**, dejando solo el análisis por **CI** con el token.
- O bien quitá el paso de Sonar del workflow y usá solo Automatic Analysis (no tendrías cobertura LCOV desde Actions salvo que la integres de otro modo).

### 1.5 Frontend: inputs del action `sonarcloud-github-action@v2`

En la versión actual del action, los únicos `with` válidos suelen ser `args`, `projectBaseDir` y `entryPoint`. El **project key** y la **organization** deben pasarse en `args` como `-Dsonar.projectKey=...` y `-Dsonar.organization=...` (como en el workflow del frontend), no como `with: projectKey` / `organization`.

Resumen por repo:

| Repo      | Secret        | Variables                          |
|-----------|---------------|-------------------------------------|
| Backend   | `SONAR_TOKEN` | `SONAR_ORGANIZATION`, `SONAR_PROJECT_KEY` (del proyecto backend en SonarCloud) |
| Frontend  | `SONAR_TOKEN` | `SONAR_ORGANIZATION`, `SONAR_PROJECT_KEY` (del proyecto frontend en SonarCloud) |

---

## 2. AWS / ECR (publicación de imágenes)

Ya deberías tener configurado:

- **Secrets**: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` (con permisos para ECR).

Además, en **AWS** tenés que tener creados **dos repositorios por servicio** (o el path que uses en ECR):

- **Backend**
  - Repo para **develop**: valor de `ECR_REPOSITORY_DEVELOP` en el workflow (por defecto `b4c0c6w7/tesis/tp1-backend-develop`).
  - Repo para **main**: valor de `ECR_REPOSITORY_MAIN` (por defecto `b4c0c6w7/tesis/tp1-backend`).
- **Frontend**
  - Repo para **develop**: `ECR_REPOSITORY_DEVELOP` (por defecto `b4c0c6w7/tesis/tp1-frontend-develop`).
  - Repo para **main**: `ECR_REPOSITORY_MAIN` (por defecto `b4c0c6w7/tesis/tp1-frontend`).

Si usás otro namespace/repo en ECR, cambiá los `env` al inicio del workflow en cada repo.

---

## 3. Resumen de lo que tiene que existir

**En GitHub (cada repo):**

- Secrets: `SONAR_TOKEN`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`.
- Variables: `SONAR_ORGANIZATION`, `SONAR_PROJECT_KEY`.

**En SonarCloud:**

- Un proyecto vinculado al repo de backend (organization + project key).
- Un proyecto vinculado al repo de frontend (organization + project key).
- Token generado y guardado en GitHub como `SONAR_TOKEN`.

**En AWS ECR:**

- Repositorios para imágenes de **develop** y **main** (backend y frontend), con permisos para la cuenta que usa `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`.

Con eso, al hacer push a `develop` o `main` (o abrir/actualizar un PR), el workflow correrá tests, SonarCloud y, en push, publicará la imagen en el repo ECR correspondiente.
