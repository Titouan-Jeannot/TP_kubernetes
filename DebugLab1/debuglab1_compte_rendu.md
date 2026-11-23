# Debug Lab 1 — Le Service qui perd des requêtes

## 1. Ma procédure et mon diagnostic

### Déploiement et reproduction du problème

- Création du fichier `debug-lab-service.yaml` contenant deux Deployments (`api-alpha` et `api-beta`), chacun avec 2 replicas, et un Service `api-service`.
- Déploiement avec `kubectl apply -f debug-lab-service.yaml`.
- Vérification avec `kubectl get deployments` et `kubectl get pods -l app=mon-api -o wide` : les quatre Pods sont à l'état `Running`.
- Création d'un Pod temporaire `debug-client` pour effectuer des requêtes HTTP depuis le cluster.
- Exécution d'une boucle de 10 requêtes vers `http://api-service`.

**Résultat : 6 requêtes sur 10 échouent**, alors que les quatre Pods sont en cours d'exécution.


### Identification de la cause

- Inspection du Service avec `kubectl describe service api-service`.
- Vérification des Endpoints avec `kubectl get endpoints api-service` : le Service redirige les requêtes vers le port `5678` des quatre Pods.
- Analyse des configurations des deux Deployments :
  - `api-alpha` écoute sur le port `5678`.
  - `api-beta` écoute sur le port `8080`, malgré un `containerPort` déclaré à `5678`.
- Test direct du Pod Beta :
  - `curl http://10.233.106.27:5678` : connexion refusée.
  - `curl http://10.233.106.27:8080` : réponse `Reponse du deploiement Beta`.

**Cause identifiée :** le Service utilise le port cible `5678` pour tous les Pods, alors que les Pods Beta écoutent réellement sur le port `8080`. Les requêtes envoyées vers les Pods Beta échouent donc.

### Correction et validation

- Modification du Deployment `api-beta` pour faire écouter l'application sur le port `5678` au lieu de `8080`.
- Réapplication du manifest avec `kubectl apply -f debug-lab-service.yaml`.
- Vérification de la mise à jour avec `kubectl rollout status deployment/api-beta`.
- Nouvelle boucle de 10 requêtes vers le Service.

**Résultat : 10 requêtes sur 10 réussissent**, avec des réponses HTTP 200 provenant des Deployments Alpha et Beta.


## 2. Mes difficultés éventuelles

- Les quatre Pods étaient à l'état `Running`, ce qui pouvait laisser penser que l'application fonctionnait correctement. Pourtant, les requêtes HTTP échouaient une fois sur deux.
- L'inspection des Endpoints et les tests directs des Pods ont permis d'identifier une incohérence entre les ports d'écoute réels et le port cible du Service.

