import logging
import os

import psycopg
from psycopg.rows import dict_row
from fastapi import APIRouter, HTTPException

from ..schemas import MateriOut

logger = logging.getLogger("bioverse.materi")
router = APIRouter(prefix="/api/v1/materi", tags=["materi"])


def _connect():
    """Connect to the PostgreSQL database configured through environment variables."""
    required = ["DATABASE_HOST", "DATABASE_NAME", "DATABASE_USER", "DATABASE_PASSWORD"]
    missing = [name for name in required if not os.getenv(name)]
    if missing:
        raise RuntimeError("Konfigurasi database belum lengkap: " + ", ".join(missing))

    return psycopg.connect(
        host=os.environ["DATABASE_HOST"],
        port=os.getenv("DATABASE_PORT", "5432"),
        dbname=os.environ["DATABASE_NAME"],
        user=os.environ["DATABASE_USER"],
        password=os.environ["DATABASE_PASSWORD"],
        row_factory=dict_row,
        connect_timeout=5,
    )


_COLUMNS = "id, judul, deskripsi, kategori, level, konten, video_id"


@router.get("", response_model=list[MateriOut])
def list_materi() -> list[MateriOut]:
    """Read all learning materials directly from PostgreSQL."""
    try:
        with _connect() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    f"SELECT {_COLUMNS} FROM public.materi ORDER BY id"
                )
                return [MateriOut(**row) for row in cur.fetchall()]
    except Exception as exc:
        logger.exception("Gagal membaca tabel public.materi")
        raise HTTPException(
            status_code=503,
            detail="Database materi sedang tidak dapat diakses.",
        ) from exc


@router.get("/{materi_id}", response_model=MateriOut)
def get_materi(materi_id: int) -> MateriOut:
    """Read one learning material from PostgreSQL by its ID."""
    try:
        with _connect() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    f"SELECT {_COLUMNS} FROM public.materi WHERE id = %s",
                    (materi_id,),
                )
                row = cur.fetchone()
    except Exception as exc:
        logger.exception("Gagal membaca materi id=%s", materi_id)
        raise HTTPException(
            status_code=503,
            detail="Database materi sedang tidak dapat diakses.",
        ) from exc

    if row is None:
        raise HTTPException(status_code=404, detail="Materi tidak ditemukan")

    return MateriOut(**row)
