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
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
# Configure 'Deployment' of mysql server
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
spec:
  selector:
    matchLabels:
      app: mysql
  strategy:
    type: Recreate
    spec:
      containers:
        - image: mysql:5.8
          name: mysql
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: 'password-value'

            - name: MYSQL_DATABASE
              value: management

          ports:
            - containerPort: 3306
              name: mysql
          volumeMounts:
            - name: mysql-persistent-storage
              mountPath: /var/lib/mysql
      volumes:
        - name: mysql-persistent-storage
          persistentVolumeClaim:
            claimName: mysql-pv-claim
---
# Configure 'Service' of mysql server
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  ports:
    - port: 3306
      targetPort: 3306
  selector:
    app: mysql
```
### Déploiement de l'Application:

Utilisez le fichier app/app-deployment.yaml pour déployer l'application sur Kubernetes.

Exemple du fichier app/app-deployment.yaml :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-management
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: app-management
    spec:
      containers:
        - name: app-management
          image: thiare29/app-management:0.0.1
          imagePullPolicy: Always
          ports:
            - name: http
              containerPort: 8081
          resources:
            limits:
              cpu: 0.2
              memory: "200Mi"
          env:
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-pass
                  key: mysql-user-password
            - name: DB_SERVER
              valueFrom:
                configMapKeyRef:
                  name:  mysql-config-map
                  key: mysql-server
            - name: DB_NAME
              valueFrom:
                configMapKeyRef:
                  name:  mysql-config-map
                  key: mysql-database-name
            - name: DB_USERNAME
              valueFrom:
                configMapKeyRef:
                  name: mysql-config-map
                  key: mysql-user-username
      imagePullSecrets:
        - name: regcred
---
apiVersion: v1
kind: Service
metadata:
  name: app-management
  labels:
    app: app-management
spec:
  type: LoadBalancer
  selector:
    app: app-management
  ports:
    - protocol: TCP
      name: http
      port: 8081
      targetPort: 8081
      nodePort: 30001
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
name: CI/CD

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Build with Maven
        run: docker compose build

      - name: connect to Docker Hub
        run: docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}

      - name: Tag with Docker Hub
        run: docker tag app-management ${{ secrets.DOCKER_USERNAME }}/app-management:0.0.1

      - name: Publish to Docker Hub
        run: docker push ${{ secrets.DOCKER_USERNAME }}/app-management:0.0.1
```

### Merci