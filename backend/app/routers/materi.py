from fastapi import APIRouter, HTTPException

from .. import data
from ..schemas import MateriOut

router = APIRouter(prefix="/api/v1/materi", tags=["materi"])


@router.get("", response_model=list[MateriOut])
async def list_materi() -> list[MateriOut]:
    """Dipanggil oleh ApiService.fetchMateri() di Flutter."""
    return data.get_all_materi()


@router.get("/{materi_id}", response_model=MateriOut)
async def get_materi(materi_id: int) -> MateriOut:
    """Belum dipakai di sisi Flutter saat ini, disiapkan untuk detail topik."""
    materi = data.get_materi_by_id(materi_id)

    if materi is None:
        raise HTTPException(status_code=404, detail="Materi tidak ditemukan")

    return materi
