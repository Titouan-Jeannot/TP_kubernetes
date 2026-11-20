# TP2 — Premiers pas sur Kubernetes

## 1. Ma procédure

- Configuration de `kubectl` pour accéder au cluster Kubernetes de SSP Cloud.
- Vérification de la connexion au cluster avec `kubectl config get-contexts` et `kubectl get pods`.
- Création d'un fichier `deployment.yaml` décrivant un Deployment Kubernetes :
  - `apiVersion: apps/v1` : version de l'API Kubernetes utilisée.
  - `kind: Deployment` : type de ressource à créer.
  - `metadata` : nom du Deployment.
  - `replicas: 3` : nombre de Pods souhaités.
  - `selector` et `labels` : identification des Pods gérés par le Deployment.
  - `template` : configuration des Pods.
  - `containers` : utilisation de l'image Docker `titouan2235/tp1pythonkub:1.0`, créée lors du TP1, sur le port 8000.
- Déploiement de l'application avec `kubectl apply -f deployment.yaml`.
- Vérification des trois replicas avec `kubectl get deployments` et `kubectl get pods`. Les trois Pods sont bien à l'état `Running`, et le Deployment indique `3/3` replicas prêts.
- Test de l'API sans créer de Service Kubernetes, grâce à la commande `kubectl port-forward deployment/python-api-deployment 8000:8000`.
- Vérification avec `curl http://localhost:8000/hello`, qui renvoie `"world"`.
- Suppression manuelle d'un Pod avec `kubectl delete pod`, puis observation de la création automatique d'un nouveau Pod avec `kubectl get pods -w`.

## 2. Mes difficultés éventuelles

### Configuration de kubectl

- **Problème :** `kubectl` était installé, mais aucun contexte Kubernetes n'était configuré (`current-context is not set`).
- **Solution :** configuration de l'accès au cluster SSP Cloud à l'aide des informations fournies par la plateforme.

### Téléchargement de l'image Docker

- **Problème :** les trois Pods restaient à l'état `ErrImagePull`, et le Deployment indiquait `0/3` replicas prêts.
- **Cause :** erreur dans le nom d'utilisateur Docker Hub renseigné dans le manifest (`titou2235` au lieu de `titouan2235`).
- **Solution :** correction du nom de l'image dans le fichier `deployment.yaml`, puis réapplication du manifest avec `kubectl apply -f deployment.yaml`. Les trois Pods ont ensuite démarré correctement.

## 3. Mes remarques

### Ce que j'ai retenu

- Kubernetes permet de décrire l'état souhaité d'une application à l'aide de fichiers YAML, plutôt que de gérer directement les conteneurs.
- Un Deployment permet de gérer plusieurs replicas d'une application et de maintenir leur nombre.
- Kubernetes recrée automatiquement un Pod supprimé.
- Le chemin et le tag de l'image Docker doivent être correctement renseignés pour que Kubernetes puisse télécharger l'image.
- 
