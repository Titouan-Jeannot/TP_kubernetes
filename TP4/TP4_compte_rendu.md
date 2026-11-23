# TP4 — Gestion de la persistance

## 1. Ma procédure

### Exercice 1 — Persistance de PostgreSQL avec un StatefulSet

- Réutilisation de l'application trois tiers du TP3, dont la base PostgreSQL était initialement déployée avec un `Deployment`, sans stockage persistant.
- Sauvegarde de la base existante avec `pg_dump`, contenant deux avis.
- Suppression du Deployment PostgreSQL, en conservant son Service pour maintenir la communication avec le backend.
- Création d'un `StatefulSet` PostgreSQL avec :
  - un replica nommé `postgres-0` ;
  - un Service Headless `postgres-headless` ;
  - un `volumeClaimTemplates` créant un PVC de 1 Gi avec la StorageClass `rook-ceph-block` ;
  - un montage du volume dans `/var/lib/postgresql/data`.
- Déploiement avec `kubectl apply -f exercice1/postgres-statefulset.yaml`.
- Vérification de la création du PVC `postgres-data-postgres-0`, à l'état `Bound`.
- Restauration des deux avis à partir de la sauvegarde SQL avec `psql`.
- Vérification des données avec `SELECT * FROM public.reviews;`.
- Suppression du Pod avec `kubectl delete pod postgres-0`.
- Observation de la recréation automatique de `postgres-0` par le StatefulSet.
- Nouvelle interrogation de la base : les deux avis sont toujours présents et le PVC est conservé.

**Résultat :** les données PostgreSQL persistent après la suppression et la recréation du Pod.

### Exercice 2 — Filesystem en lecture seule et volume emptyDir

**Étape 1 — Activer la lecture seule**

- Reprise du Deployment de l'API Python du TP2 avec trois replicas.
- Ajout du paramètre `readOnlyRootFilesystem: true` dans le `securityContext` du conteneur.
- Réapplication du manifest avec `kubectl apply -f exercice2/python-api.yaml`.
- Vérification des Pods et des logs : l'application FastAPI démarre correctement malgré le filesystem en lecture seule.
- Tentative d'écriture dans `/tmp` avec `kubectl exec` : échec avec le message `Read-only file system`.
- Vérification du fonctionnement de l'API avec `kubectl port-forward` et `curl` : l'API répond toujours `"world"`.

**Étape 2 — Ajouter un volume emptyDir**

- Ajout d'un volume `emptyDir` monté sur `/tmp` grâce à `volumeMounts` et `volumes`.
- Application du manifest et vérification du démarrage des trois Pods.
- Nouvelle tentative d'écriture dans `/tmp` : le fichier est créé et son contenu peut être lu.
- Tentative d'écriture dans `/app` : toujours refusée avec `Read-only file system`.

**Étape 3 — Vérifier le caractère temporaire du volume**

- Création d'un fichier `/tmp/persistance.txt` dans un Pod précis.
- Vérification du contenu du fichier avec `kubectl exec`.
- Suppression de ce Pod avec `kubectl delete pod`.
- Recréation automatique d'un nouveau Pod par le Deployment.
- Vérification de l'absence du fichier dans le nouveau Pod : `No such file or directory`.

**Résultat :** le volume `emptyDir` autorise les écritures temporaires dans `/tmp`, sans désactiver la protection du système de fichiers racine. Son contenu disparaît lorsque le Pod est supprimé.

