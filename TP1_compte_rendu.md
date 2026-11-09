# TP1 — Introduction à Docker

## 1. Ma procédure

### Exercice 1 — Conteneurisation d'une API Python

- Récupération du code de l'API Python utilisant FastAPI et Uvicorn.
- Création d'un `Dockerfile` à partir de l'image `python:3.12-slim` :
  - définition du répertoire de travail `/app` ;
  - copie et installation des dépendances Python ;
  - copie du code source ;
  - exposition du port 8000 ;
  - lancement de l'API avec Uvicorn.
- Construction de l'image avec `docker build -t python-api:1.0 .`.
- Création et lancement du conteneur avec `docker run -d --name mon-api -p 8000:8000 python-api:1.0`.
- Vérification du fonctionnement de l'API avec `curl http://localhost:8000/hello`, qui renvoie `"world"`.
- Consultation des logs avec `docker logs mon-api` et `docker logs -f mon-api`.
- Publication de l'image sur Docker Hub : `titou2235/tp1pythonkub:1.0`.

### Exercice 2 — API Java et multi-stage build

- Récupération du code de l'API Java développée avec Spring Boot.
- Compilation du projet avec Maven (`mvn package`), générant un fichier JAR.
- Vérification du fonctionnement de l'application en local avec `java -jar`.
- Création d'un Dockerfile utilisant deux stages :
  - **Build :** utilisation de Maven et d'un JDK 21 pour compiler l'application.
  - **Run :** utilisation d'un JRE 21 pour exécuter uniquement le JAR généré.
- Construction de l'image avec `docker build -t java-api:multi-stage .`.
- Exécution du conteneur et vérification de l'API avec `curl http://localhost:8081/hello`, qui renvoie `world`.
- Création d'un second Dockerfile, `Dockerfile.single`, utilisant un seul stage avec Maven et le JDK.
- Construction de l'image single-stage et comparaison des tailles avec `docker images`.

**Résultats de la comparaison :**

| Indicateur   | Single-stage | Multi-stage | Réduction |
| ------------ | -----------: | ----------: | --------: |
| Disk usage   |       937 Mo |      494 Mo |    47,3 % |
| Content size |       302 Mo |      133 Mo |    56,0 % |

Le multi-stage permet donc de réduire significativement la taille de l'image finale. Cette différence s'explique par l'absence de Maven, du JDK complet et des fichiers de compilation dans le second stage : seul le JAR compilé est transféré vers l'environnement d'exécution.

## 2. Mes difficultés éventuelles

### Installation de Docker Desktop

- **Problème :** l'installation du paquet `.deb` échouait avec l'erreur `docker-desktop : Dépend: docker-ce-cli mais il n'est pas installable`.
- **Solution :** ajout du dépôt officiel de Docker aux sources APT d'Ubuntu, permettant d'installer les dépendances manquantes.

### Authentification et publication sur Docker Hub

- **Problème :** impossibilité d'enregistrer les identifiants (`pass not initialized`), puis refus de publication (`insufficient_scope: authorization failed`).
- **Solution :** initialisation du gestionnaire de mots de passe `pass` avec une clé GPG, création d'un jeton d'accès Docker Hub avec les permissions de lecture et d'écriture, puis utilisation du nom exact du dépôt lors du `docker push`.

### Exécution de l'API Java

- **Problème :** la commande `java -jar application.jar` ne trouvait pas le fichier JAR.

- **Solution :** utilisation du chemin réel du fichier généré par Maven : `target/java-api-1.0.0.jar`.

- **Problème :** impossible de lancer le conteneur Docker sur le port 8080 (`bind: address already in use`), car celui-ci était déjà occupé.

- **Solution :** utilisation du port 8081 sur la machine hôte, redirigé vers le port 8080 du conteneur (`-p 8081:8080`).

## 3. Mes remarques

### Ce que j'ai retenu

- La distinction entre un **Dockerfile**, une **image** et un **conteneur**.
- L'intérêt de Docker pour exécuter une application avec ses dépendances dans un environnement reproductible.
- Le fonctionnement du système de couches (*layers*) et de leur mise en cache lors de la construction.
- L'utilisation des commandes Docker pour construire, lancer, tester et surveiller une application.
- L'intérêt de Docker Hub pour partager des images.
- L'importance du multi-stage build, séparer la compilation de l'exécution permet de réduire la taille des images et de limiter les composants inutiles.
