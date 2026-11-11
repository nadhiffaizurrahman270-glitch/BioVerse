"""
Skema response, dibuat sama persis dengan field yang dibaca
`BiologyTopic.fromJson` di lib/models/biology_topic.dart:

    id, judul, deskripsi, kategori, level, konten, video_id

Jangan ubah nama field di sini tanpa mengubah juga sisi Flutter-nya.
"""

from __future__ import annotations

from typing import Optional

from pydantic import BaseModel, Field


class MateriOut(BaseModel):
    id: int
    judul: str
    deskripsi: str
    kategori: str
    level: str
    konten: str
    video_id: Optional[str] = None


class TutorRequest(BaseModel):
    pertanyaan: str = Field(..., min_length=1, max_length=2000)


class TutorResponse(BaseModel):
    jawaban: str
