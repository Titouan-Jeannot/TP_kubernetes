# TP3 — Exposons notre application sur Internet

## 1. Ma procédure

### Exercice 1 — Exposition sur le réseau interne du cluster

- Réutilisation du Deployment de l'API Python du TP2, contenant 3 replicas.
- Création d'un Service Kubernetes de type `ClusterIP` nommé `python-api-service`.
- Configuration du Service pour rediriger le port 80 vers le port 8000 des Pods Python.
- Déploiement avec `kubectl apply -f exercice1/service.yaml`.
- Vérification avec `kubectl get services` : le Service possède l'adresse interne `10.233.27.183`.
- Création d'un Pod temporaire `test-client`, contenant l'outil `curl`.
- Test de l'API depuis le réseau interne du cluster :

  `kubectl exec test-client -- curl -s http://python-api-service/hello`

  Résultat : `"world"`.

### Exercice 2 — Exposition de l'API sur Internet

- Création d'un Ingress Kubernetes utilisant le contrôleur `nginx`.
- Configuration du nom de domaine `python-api-titouanjeannot.lab.sspcloud.fr`.
- Redirection des requêtes HTTP/HTTPS vers le Service `python-api-service`, sur le port 80.
- Déploiement avec `kubectl apply -f exercice2/ingress.yaml`.
- Vérification avec `kubectl get ingress`.
- Test depuis le poste de travail :

  `curl -i https://python-api-titouanjeannot.lab.sspcloud.fr/hello`

  Résultat : **HTTP 200** et réponse `"world"`.

### Exercice 3 — Déploiement d'une application trois tiers

Déploiement de trois composants à partir des images Docker fournies :

- **PostgreSQL** (`postgres:13`) : création d'un Deployment et d'un Service `postgres` sur le port 5432. Configuration de la base `reviews` avec les identifiants fournis dans l'énoncé.
- **Backend** (`hugosmn5/backend-3-tier:1.1`) : création d'un Deployment et d'un Service `backend` sur le port 5000. Configuration des variables d'environnement `DB_USER`, `DB_PASS`, `DB` et `DB_HOST` pour accéder à PostgreSQL.
- **Frontend** (`hugosmn5/frontend-3-tier:1.1`) : création d'un Deployment et d'un Service `frontend` sur le port 5000.
- Création d'un Ingress pour exposer le frontend à l'adresse `frontend-titouanjeannot.lab.sspcloud.fr`.
- Vérification de l'état des Pods avec `kubectl get pods` et consultation des logs des applications avec `kubectl logs`.
- Test fonctionnel depuis le navigateur : soumission d'un avis dans le formulaire, puis vérification de son affichage sur la page `/reviews`.

**Résultat :** l'application trois tiers fonctionne. Le frontend est accessible depuis Internet et communique avec le backend, qui permet d'enregistrer et de récupérer les avis stockés dans PostgreSQL.

## 2. Mes difficultés éventuelles

### Test du Service interne

- **Problème :** lors du premier test avec `curl`, la réponse `"world"` était difficile à lire à cause de l'affichage de la barre de progression.
- **Solution :** utilisation de l'option `-s` de `curl` pour afficher uniquement la réponse de l'API et vérification du code HTTP 200.


## 3. Mes remarques

### Ce que j'ai retenu

- Un **Service ClusterIP** fournit un point d'accès stable aux Pods, accessible depuis le réseau interne du cluster.
- Le DNS interne de Kubernetes permet aux applications de communiquer en utilisant les noms des Services plutôt que leurs adresses IP.
- Un **Ingress** permet d'exposer une application HTTP/HTTPS sur Internet en redirigeant les requêtes vers un Service.
- La séparation entre frontend, backend et base de données permet de déployer et de gérer indépendamment les composants d'une application.
- Les variables d'environnement permettent de configurer la connexion du backend à PostgreSQL.
- Les commandes `kubectl get`, `kubectl logs` et `kubectl describe` facilitent la vérification et le diagnostic des ressources Kubernetes.

