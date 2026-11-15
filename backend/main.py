from __future__ import annotations

from datetime import datetime, timedelta
import logging
import os
from typing import List

from dotenv import load_dotenv
from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from google.auth.transport import requests as google_requests
from google.oauth2 import id_token
from google import genai
from google.genai import types
from jose import JWTError, jwt
from passlib.context import CryptContext
from pydantic import BaseModel
from sqlalchemy import func, text
from sqlalchemy.orm import Session

import models
import schemas
from database import engine, get_db

load_dotenv(override=True)
logger = logging.getLogger("bioverse.backend")

# Otomatis buat semua tabel di PostgreSQL jika belum ada
models.Base.metadata.create_all(bind=engine)

from database import engine, get_db, SessionLocal
from seed import seed_initial_materi

models.Base.metadata.create_all(bind=engine)

# Isi 4 materi awal otomatis jika tabel materi masih kosong
with SessionLocal() as db:
    seed_initial_materi(db)

app = FastAPI(
    title="BioVerse API",
    version="1.0.0",
    description="Backend BioVerse terintegrasi dengan PostgreSQL, Auth JWT, dan BioBot AI Tutor.",
)

# Menggunakan CORS terbuka agar GitHub Pages, localhost, Tailscale, dan Header JWT Authorization berjalan lancar
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ==========================================
# HEALTH CHECK ENDPOINT
# ==========================================
@app.get("/api/v1/health", tags=["health"])
def health_check(db: Session = Depends(get_db)):
    try:
        db.execute(text("SELECT 1"))
        return {
            "status": "ok",
            "database": "Terhubung ke PostgreSQL bioverse_db!",
        }
    except Exception as e:
        return {
            "status": "error",
            "database": f"Gagal terhubung ke DB: {str(e)}",
        }


# ==========================================
# KONFIGURASI KEAMANAN & JWT
# ==========================================
pwd_context = CryptContext(schemes=["pbkdf2_sha256", "bcrypt"], deprecated="auto")

SECRET_KEY = os.getenv("SECRET_KEY", "rahasia_bioverse_super_aman")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)


def create_access_token(data: dict, expires_delta: timedelta | None = None) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=15))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Token tidak valid atau telah kadaluwarsa",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str | None = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = db.query(models.User).filter(models.User.email == email).first()
    if user is None:
        raise credentials_exception
    return user


# ==========================================
# API ENDPOINTS MATERI
# ==========================================
@app.post("/api/v1/materi", response_model=schemas.MateriResponse, tags=["materi"])
def create_materi(
    materi: schemas.MateriCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    db_materi = models.Materi(**materi.dict())
    db.add(db_materi)
    db.commit()
    db.refresh(db_materi)
    return db_materi


@app.get("/api/v1/materi", response_model=List[schemas.MateriResponse], tags=["materi"])
def get_all_materi(db: Session = Depends(get_db)):
    return db.query(models.Materi).order_by(models.Materi.id.asc()).all()


@app.get("/api/v1/materi/{materi_id}", response_model=schemas.MateriResponse, tags=["materi"])
def get_materi_by_id(materi_id: int, db: Session = Depends(get_db)):
    materi = db.query(models.Materi).filter(models.Materi.id == materi_id).first()
    if not materi:
        raise HTTPException(status_code=404, detail="Materi tidak ditemukan")
    return materi


# ==========================================
# API ENDPOINTS LEADERBOARD & SCORES
# ==========================================
@app.get("/api/v1/leaderboard", tags=["leaderboard"])
def get_leaderboard(db: Session = Depends(get_db)):
    leaderboard = (
        db.query(
            models.User.id.label("user_id"),
            models.User.nama,
            models.User.email,
            func.coalesce(func.sum(models.UserScore.skor), 0).label("total_score"),
        )
        .outerjoin(models.UserScore, models.User.id == models.UserScore.user_id)
        .group_by(models.User.id, models.User.nama, models.User.email)
        .order_by(func.sum(models.UserScore.skor).desc().nullslast())
        .all()
    )

    return [
        {
            "user_id": item.user_id,
            "nama": item.nama,
            "email": item.email,
            "total_score": item.total_score,
        }
        for item in leaderboard
    ]


@app.post("/api/v1/scores", tags=["leaderboard"])
def submit_score(score_data: schemas.ScoreSubmit, db: Session = Depends(get_db)):
    new_score = models.UserScore(user_id=score_data.user_id, skor=score_data.skor)
    db.add(new_score)
    db.commit()
    return {"message": "Skor berhasil disimpan!"}


# ==========================================
# API ENDPOINTS AUTHENTICATION & USER PROFILE
# ==========================================
@app.post(
    "/api/v1/auth/register",
    response_model=schemas.UserOut,
    status_code=status.HTTP_201_CREATED,
    tags=["auth"],
)
def register_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    existing_user = db.query(models.User).filter(models.User.email == user.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email sudah terdaftar")

    hashed_pwd = get_password_hash(user.password)
    new_user = models.User(
        nama=user.nama,
        email=user.email,
        hashed_password=hashed_pwd,
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


@app.post("/api/v1/auth/login", response_model=schemas.Token, tags=["auth"])
def login_user(db: Session = Depends(get_db), form_data: OAuth2PasswordRequestForm = Depends()):
    user = db.query(models.User).filter(models.User.email == form_data.username).first()

    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email atau password salah",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.email}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}


@app.get("/api/v1/users/me", tags=["auth"])
def read_users_me(current_user: models.User = Depends(get_current_user), db: Session = Depends(get_db)):
    total_xp = (
        db.query(func.coalesce(func.sum(models.UserScore.skor), 0))
        .filter(models.UserScore.user_id == current_user.id)
        .scalar()
    )

    return {
        "id": current_user.id,
        "nama": current_user.nama,
        "username": current_user.nama,
        "email": current_user.email,
        "role": current_user.role,
        "xp": total_xp,
    }


class GoogleLoginRequest(BaseModel):
    id_token: str


@app.post("/api/v1/auth/google", response_model=schemas.Token, tags=["auth"])
def google_login(req: GoogleLoginRequest, db: Session = Depends(get_db)):
    try:
        idinfo = id_token.verify_oauth2_token(
            req.id_token, google_requests.Request(), None
        )

        email = idinfo.get("email")
        nama = idinfo.get("name") or email.split("@")[0]

        if not email:
            raise HTTPException(status_code=400, detail="Email tidak ditemukan dari akun Google")

        user = db.query(models.User).filter(models.User.email == email).first()

        if not user:
            random_pwd = get_password_hash(os.urandom(16).hex())
            user = models.User(
                nama=nama,
                email=email,
                hashed_password=random_pwd,
            )
            db.add(user)
            db.commit()
            db.refresh(user)

        access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = create_access_token(
            data={"sub": user.email}, expires_delta=access_token_expires
        )
        return {"access_token": access_token, "token_type": "bearer"}

    except ValueError:
        raise HTTPException(status_code=401, detail="Token Google tidak valid atau kadaluwarsa")


# ==========================================
# KONFIGURASI & ENDPOINT GEMINI AI TUTOR
# ==========================================
_SYSTEM_PROMPT = (
    "Kamu adalah BioBot, tutor biologi untuk siswa di aplikasi belajar "
    "BioVerse. Jawab pertanyaan dalam Bahasa Indonesia, singkat, jelas, "
    "dan ramah. Fokus pada topik biologi (DNA & genetika, biologi sel, "
    "virus, ekosistem). Kalau pertanyaan di luar biologi, arahkan dengan "
    "sopan kembali ke topik biologi."
)

_FALLBACK_MESSAGE = (
    "BioBot belum terhubung ke Gemini AI. Minta admin mengisi "
    "GEMINI_API_KEY di file .env backend, lalu jalankan ulang servernya."
)

_ai_client = None
_model_name = os.getenv("GEMINI_MODEL", "gemini-3.8-flash")


def _get_ai_client():
    global _ai_client
    if _ai_client is not None:
        return _ai_client

    api_key = (os.getenv("GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY") or "").strip()
    if not api_key:
        return None

    try:
        _ai_client = genai.Client(api_key=api_key)
    except Exception:
        logger.exception("Gagal inisialisasi client Gemini")
        return None

    return _ai_client


@app.post("/api/v1/ai/tutor", tags=["ai-tutor"])
def ask_ai_tutor(req: schemas.AITutorRequest):
    client = _get_ai_client()

    if client is None:
        return {
            "status": "fallback",
            "pertanyaan": req.pertanyaan,
            "jawaban": _FALLBACK_MESSAGE,
        }

    try:
        response = client.models.generate_content(
            model=_model_name,
            contents=req.pertanyaan,
            config=types.GenerateContentConfig(
                system_instruction=_SYSTEM_PROMPT,
                max_output_tokens=600,
            ),
        )
        text_answer = (response.text or "").strip()

        return {
            "status": "sukses",
            "pertanyaan": req.pertanyaan,
            "jawaban": text_answer or "BioBot tidak menemukan jawaban untuk itu.",
        }
    except Exception:
        logger.exception("Gagal memanggil Gemini API")
        return {
            "status": "error",
            "pertanyaan": req.pertanyaan,
            "jawaban": "BioBot sedang bermasalah menghubungi Gemini AI. Coba lagi sebentar lagi.",
        }