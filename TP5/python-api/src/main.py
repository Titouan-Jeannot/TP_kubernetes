from fastapi import FastAPI

app = FastAPI()


@app.get("/hello")
def hello():
    return "world"

@app.get("/health")
def health():
    return {"status": "ok"}
