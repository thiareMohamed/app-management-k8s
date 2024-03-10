### CI/CD avec GitHub Actions

#### Prérequis
Avant de commencer, assurez-vous d'avoir les éléments suivants :

- Un compte GitHub
- Un compte Docker Hub
- Un projet Java avec un fichier pom.xml

#### Configuration de GitHub Actions
Le fichier `ci-cd.yml` dans le répertoire `.github/workflows/` contient la configuration de GitHub Actions pour notre processus CI/CD. Il est configuré pour :

- Déclencher le workflow à chaque push sur la branche principale (`main`)
- Cloner le dépôt
- Configurer JDK 17
- Construire le projet avec Maven
- Exécuter les tests
- Publier l'image Docker sur Docker Hub
  Assurez-vous de définir les secrets `DOCKER_USERNAME` et `DOCKER_PASSWORD` dans les paramètres secrets de votre dépôt GitHub pour permettre la publication de l'image Docker.

#### Maven Configuration
Le fichier `pom.xml` contient la configuration Maven pour notre projet Java. Il utilise le plugin Spring Boot Maven pour construire et packager l'application, ainsi que le plugin Docker pour construire et publier l'image Docker.

Assurez-vous de remplir les propriétés `docker.user` et `docker.token` avec votre nom d'utilisateur et votre token Docker Hub.

#### Exemple d'utilisation
Clonez ce dépôt sur votre machine locale :
```bash
git clone https://github.com/thiareMohamed/app-management.git
```
Ajoutez votre code source Java dans le répertoire du projet.

Configurez les secrets `DOCKER_USERNAME` et `DOCKER_PASSWORD` dans les paramètres secrets de votre dépôt GitHub avec vos informations d'identification Docker Hub.

Effectuez un push sur votre dépôt GitHub :

```bash
git add .
git commit -m "Ajouter mon code source"
git push origin main
```
Accédez à l'onglet "Actions" de votre dépôt GitHub pour suivre l'exécution du workflow.

Après l'exécution réussie du workflow, votre image Docker sera publiée sur Docker Hub.

