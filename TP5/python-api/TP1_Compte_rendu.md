FROM python:3.12-slim

On part d'une image Docker qui contient déjà Python 3.12.

Le suffixe slim indique une version allégée de l'image.

WORKDIR /app

On crée si nécessaire un répertoire /app dans l'image et on le définit comme répertoire de travail.

Les commandes suivantes seront exécutées depuis ce dossier.

COPY requirement.txt .

On copie le fichier requirement.txt depuis ton ordinateur vers le répertoire /app de l'image.

RUN pip install --no-cache-dir -r requirement.txt

Docker installe FastAPI et Uvicorn dans l'image.

COPY src/ ./src/

On copie le code Python dans l'image.

EXPOSE 8000

On indique que l'application utilise le port 8000.

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]

On définit la commande qui sera exécutée lorsque le conteneur démarrera.
