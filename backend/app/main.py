"""
Backend BioVerse (FastAPI).

Menyediakan dua endpoint yang dipanggil Flutter:
    GET  /api/v1/materi      -> ApiService.fetchMateri()
    POST /api/v1/ai/tutor    -> AITutorService.askBioBot()

Cara jalanin lokal:
    cd backend
    python -m venv .venv && source .venv/bin/activate   # Windows: .venv\\Scripts\\activate
    pip install -r requirements.txt
    cp .env.example .env        # lalu isi GEMINI_API_KEY (opsional)
    uvicorn app.main:app --reload --port 8000

Dokumentasi otomatis ada di http://127.0.0.1:8000/docs setelah jalan.

Untuk production (GitHub Pages memanggil lewat HTTPS), backend ini harus
di-deploy ke layanan yang punya HTTPS publik (lihat backend/README.md),
lalu isi ALLOWED_ORIGINS dan GEMINI_API_KEY di environment variable
layanan tersebut.
"""

from __future__ import annotations

import os

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .routers import ai_tutor, materi

# ----------------------------------------------------------------
# CORS
#
# Default-nya hanya origin GitHub Pages BioVerse + localhost untuk
# development (`flutter run -d chrome` memakai port acak di localhost/
# 127.0.0.1). Sengaja TIDAK memakai allow_origins=["*"], supaya API ini
# tidak bisa dipanggil bebas dari domain lain.
#
# Kalau frontend pernah dipindah ke domain lain (custom domain, dsb),
# tambahkan originnya ke ALLOWED_ORIGINS (dipisah koma) lewat environment
# variable, tidak perlu ubah kode ini.
# ----------------------------------------------------------------

_DEFAULT_ORIGINS = [
    "https://nadhiffaizurrahman270-glitch.github.io",
]

_extra_origins = [
    origin.strip()
    for origin in os.getenv("ALLOWED_ORIGINS", "").split(",")
    if origin.strip()
]

ALLOWED_ORIGINS = _DEFAULT_ORIGINS + _extra_origins

app = FastAPI(
    title="BioVerse API",
    version="1.0.0",
    description="Backend untuk aplikasi belajar biologi BioVerse.",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    # Dev server Flutter Web (flutter run -d chrome) jalan di
    # localhost/127.0.0.1 dengan port acak, jadi diizinkan lewat regex,
    # bukan wildcard "*".
    allow_origin_regex=r"http://(localhost|127\.0\.0\.1)(:\d+)?",
    allow_credentials=False,
    allow_methods=["GET", "POST", "OPTIONS"],
    allow_headers=["Content-Type"],
)

app.include_router(materi.router)
app.include_router(ai_tutor.router)


@app.get("/api/v1/health", tags=["health"])
async def health() -> dict:
    """Dipakai untuk cek backend sudah hidup (uptime monitor, dsb)."""
    return {"status": "ok"}
