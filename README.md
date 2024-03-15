# Projet Gestion des etudiant avec Kubernetes
Ce projet est une application de gestion etudiant déployée sur Kubernetes, utilisant une base de données MySQL. L'objectif de ce README est de fournir des instructions détaillées sur le déploiement, la configuration et l'automatisation du processus CI/CD à l'aide de GitHub Actions.

### Structure du Projet
Le projet est organisé comme suit :

app: Contient les fichiers de déploiement Kubernetes pour l'application.
database: Contient les fichiers de déploiement Kubernetes pour la base de données MySQL.
docker: Contient le Dockerfile pour construire l'image Docker de l'application.
.github/workflows: Contient le workflow GitHub Actions pour le processus CI/CD.
Configuration Requise
Pour exécuter ce projet avec succès, vous devez disposer des éléments suivants :

Un cluster Kubernetes configuré et opérationnel.
Un compte Docker Hub pour publier les images Docker.
Les secrets `DOCKER_USERNAME` et `DOCKER_PASSWORD` configurés dans les paramètres du référentiel GitHub.
###  Déploiement
Pour déployer ce projet, suivez les étapes ci-dessous :

Déploiement de la Base de Données MySQL:

Utilisez le fichier database/db-deployment.yaml pour déployer la base de données MySQL sur Kubernetes.

Exemple du fichier database/db-deployment.yaml :

```yaml
# Configure 'PersistentVolume' for mysql server
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
  labels:
    app: mysql
    tier: database
spec:
  accessModes:
    - ReadWriteOnce   #This specifies the mode of the claim that we are trying to create.
  resources:
    requests:
      storage: 1Gi    #This will tell kubernetes about the amount of space we are trying to claim.
#    limits:
#      memory: "512Mi"
#      cpu: "1500m"
---
# Configure 'Deployment' of mysql server
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  labels:
    app: mysql
    tier: database
spec:
  selector: # mysql Pod Should contain same labels
    matchLabels:
      app: mysql
      tier: database
  strategy:
    type: Recreate
  template:
    metadata:
      labels: # Must match 'Service' and 'Deployment' selectors
        app: mysql
        tier: database
    spec:
      containers:
        - image: mysql:5.8 # image from docker-hub
          args:
            - "--ignore-db-dir=lost+found" # Workaround for https://github.com/docker-library/mysql/issues/186
          name: mysql
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: thiare29

            - name: MYSQL_DATABASE # Setting Database Name from a 'ConfigMap'
              value: management

          ports:
            - containerPort: 3306
              name: mysql
          volumeMounts:        # Mounting voulume obtained from Persistent Volume Claim
            - name: mysql-persistent-storage
              mountPath: /var/lib/mysql #This is the path in the container on which the mounting will take place.
      volumes:
        - name: mysql-persistent-storage # Obtaining 'vloume' from PVC
          persistentVolumeClaim:
            claimName: mysql-pv-claim
---
# Define a 'Service' To Expose mysql to Other Services
apiVersion: v1
kind: Service
metadata:
  name: mysql  # DNS name
  labels:
    app: mysql
    tier: database
spec:
  ports:
    - port: 3306
      targetPort: 3306
  selector:       # mysql Pod Should contain same labels
    app: mysql
    tier: database
  clusterIP: None  # We Use DNS, Thus ClusterIP is not relevant
```
### Déploiement de l'Application:

Utilisez le fichier app/app-deployment.yaml pour déployer l'application sur Kubernetes.

Exemple du fichier app/app-deployment.yaml :

```yaml

```

### Exposition des Services:

Assurez-vous que les services sont correctement exposés pour permettre l'accès à l'application.

Accès à l'Application:

Accédez à l'application via l'adresse du service exposé.

Processus CI/CD
Le processus CI/CD est automatisé à l'aide de GitHub Actions. Voici comment cela fonctionne :

À chaque push sur la branche principale (main), le workflow GitHub Actions (CI/CD) est déclenché.

Le workflow effectue les actions suivantes :

Construit l'image Docker de l'application à l'aide du `Dockerfile` situé dans le dossier docker.
Tag l'image Docker avec la version correspondante.
Publie l'image Docker sur Docker Hub en utilisant les secrets `DOCKER_USERNAME` et `DOCKER_PASSWORD`.

### Configuration de GitHub Actions

Le fichier `ci-cd.yml` dans le répertoire `.github/workflows/` contient la configuration de GitHub Actions pour notre processus CI/CD. Il est configuré pour :
```yaml

```

### Merci