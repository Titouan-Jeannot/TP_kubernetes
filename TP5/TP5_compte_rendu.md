# TP5 — Mettons à jour nos applications

## 1. Ma procédure

### Exercice 1 — Ajout des probes

J'ai commencé par redéployer l'API Python du TP2, ainsi que son Service et son Ingress du TP3, sur mon nouvel environnement SSP Cloud.

J'ai ensuite modifié l'application FastAPI pour ajouter une route `/health` qui renvoie `{"status": "ok"}` avec un code HTTP 200.

Comme Docker n'était pas installé dans mon environnement VS Code SSP Cloud, j'ai utilisé **Kaniko dans un Job Kubernetes** pour construire et publier une nouvelle image `titouan2235/tp1pythonkub:v2` sur Docker Hub.

Pour cela, j'ai créé un ConfigMap contenant les fichiers de l'application et un Secret Kubernetes pour l'authentification à Docker Hub.

J'ai ensuite ajouté les deux probes dans le Deployment :

- **Readiness probe** : route `/health`, délai initial de 5 secondes, vérification toutes les 5 secondes.
- **Liveness probe** : route `/health`, délai initial de 10 secondes, vérification toutes les 10 secondes.

Après avoir appliqué le manifest, j'ai vérifié le déploiement avec :

```bash
kubectl rollout status deployment/python-api-deployment
kubectl get pods -l app=python-api
kubectl describe deployment python-api-deployment
```

Les trois Pods étaient `Running` et `Ready`, et la route `/health` répondait correctement avec HTTP 200.


### Exercice 2 — RollingUpdate et rollback

J'ai ajouté une nouvelle route `/ensai` à l'application, puis construit et publié une image `v3` avec Kaniko.

J'ai configuré explicitement la stratégie de mise à jour :

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

Cette configuration permet de créer au maximum un Pod supplémentaire, tout en conservant au moins trois Pods disponibles.

Pour observer le déploiement progressif, j'ai exécuté :

```bash
kubectl get pods -l app=python-api -w
```

Puis j'ai déclenché la mise à jour :

```bash
kubectl set image deployment/python-api-deployment \
  python-api=titouan2235/tp1pythonkub:v3
```

Kubernetes a progressivement remplacé les Pods de la version v2 par ceux de la version v3.

J'ai vérifié que la nouvelle route `/ensai` répondait correctement, puis consulté l'historique :

```bash
kubectl rollout history deployment/python-api-deployment
```

Enfin, j'ai effectué un rollback :

```bash
kubectl rollout undo deployment/python-api-deployment
```

Après le rollback, les trois Pods utilisaient de nouveau l'image v2. La route `/health` répondait avec HTTP 200, tandis que `/ensai` répondait avec HTTP 404, puisqu'elle n'existait pas dans cette version.

## 2. Mes difficultés éventuelles


Je n'ai pas rencontré de difficultés importantes lors des mises à jour et du rollback.

## 3. Mes remarques

**Readiness probe :** si elle échoue, le Pod est considéré comme non prêt et retiré des endpoints prêts du Service. Son conteneur continue de fonctionner.

**Liveness probe :** si elle échoue plusieurs fois consécutivement, Kubernetes redémarre le conteneur pour tenter de rétablir son fonctionnement.

Le délai initial de la liveness probe est plus long que celui de la readiness probe pour laisser davantage de temps à l'application avant d'envisager un redémarrage.

Le RollingUpdate permet de déployer progressivement une nouvelle version sans arrêter simultanément tous les Pods. La configuration `maxSurge: 1` et `maxUnavailable: 0` vise à conserver les trois replicas disponibles durant la mise à jour.

Enfin, le rollback permet de revenir rapidement à une version précédente en utilisant l'historique du Deployment, sans avoir à recréer manuellement les Pods.
