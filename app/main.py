from fastapi import FastAPI
from app.api.hosts import router as hosts_router

APP_VERSION = "1.0.0"

app = FastAPI(
    title="Infrastructure Inventory API",
    version=APP_VERSION
)


@app.get("/health", tags=["System"])
def health():
    return {
        "status": "UP"
    }


@app.get("/version", tags=["System"])
def version():
    return {
        "version": APP_VERSION
    }


app.include_router(hosts_router)
