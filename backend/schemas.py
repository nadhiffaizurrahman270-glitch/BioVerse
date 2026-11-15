from __future__ import annotations
from datetime import datetime
from typing import Optional
from pydantic import BaseModel, EmailStr, Field


# ==========================================
# SCHEMA UNTUK MATERI
# (Field diselaraskan dengan BiologyTopic.fromJson di Flutter)
# ==========================================
class MateriBase(BaseModel):
    judul: str
    deskripsi: Optional[str] = ""
    kategori: Optional[str] = "General"
    level: Optional[str] = "Beginner"
    konten: str
    video_id: Optional[str] = None


class MateriCreate(MateriBase):
    pass


class MateriOut(MateriBase):
    id: int

    class Config:
        from_attributes = True


class MateriResponse(MateriBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True


# ==========================================
# SCHEMA UNTUK USER & AUTENTIKASI
# ==========================================
class UserCreate(BaseModel):
    nama: str
    email: EmailStr
    password: str


class UserOut(BaseModel):
    id: int
    nama: str
    email: EmailStr
    role: str
    is_active: bool

    class Config:
        from_attributes = True


class UserResponse(BaseModel):
    id: int
    username: str
    email: str

    class Config:
        from_attributes = True


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class Token(BaseModel):
    access_token: str
    token_type: str


# ==========================================
# SCHEMA UNTUK SCORE & LEADERBOARD
# ==========================================
class ScoreSubmit(BaseModel):
    user_id: int
    skor: int


class ScoreCreate(BaseModel):
    kategori_quiz: str
    skor: int


class ScoreOut(BaseModel):
    id: int
    user_id: int
    kategori_quiz: str
    skor: int
    created_at: datetime

    class Config:
        from_attributes = True


# ==========================================
# SCHEMA UNTUK BIOBOT AI TUTOR
# (Digabung dengan validasi Field dari schemas_teman.py)
# ==========================================
class AITutorRequest(BaseModel):
    pertanyaan: str = Field(..., min_length=1, max_length=2000)


# Alias agar tetap kompatibel jika ada kode yang memanggil TutorRequest
TutorRequest = AITutorRequest


class TutorResponse(BaseModel):
    jawaban: str