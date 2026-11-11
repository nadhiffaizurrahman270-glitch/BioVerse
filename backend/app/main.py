"""Backend BioVerse (FastAPI). Materi dibaca dari PostgreSQL."""

from __future__ import annotations

import os
from dotenv import load_dotenv

# Load backend/.env before importing routers that read environment variables.
load_dotenv()

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .routers import ai_tutor, materi

_DEFAULT_ORIGINS = [
    "https://nadhiffaizurrahman270-glitch.github.io",
]

_extra_origins = [
    origin.strip()
    for origin in os.getenv("ALLOWED_ORIGINS", "").split(",")
    if origin.strip()
]

ALLOWED_ORIGINS = list(dict.fromkeys(_DEFAULT_ORIGINS + _extra_origins))

app = FastAPI(
    title="BioVerse API",
    version="1.0.0",
    description="Backend BioVerse; materi diambil langsung dari PostgreSQL.",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_origin_regex=r"http://(localhost|127\.0\.0\.1)(:\d+)?",
    allow_credentials=False,
    allow_methods=["GET", "POST", "OPTIONS"],
    allow_headers=["Content-Type"],
)

app.include_router(materi.router)
app.include_router(ai_tutor.router)


@app.get("/api/v1/health", tags=["health"])
async def health() -> dict:
    return {"status": "ok"}
