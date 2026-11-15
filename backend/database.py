import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

load_dotenv(override=True)


def _build_database_url() -> str:
    # 1. Prioritaskan DATABASE_URL jika ada di .env
    direct_url = os.getenv("DATABASE_URL", "").strip()
    if direct_url:
        return direct_url

    # 2. Jika memakai format variabel terpisah (seperti di materi.py temanmu)
    host = os.getenv("DATABASE_HOST", "").strip()
    dbname = os.getenv("DATABASE_NAME", "").strip()
    user = os.getenv("DATABASE_USER", "").strip()
    password = os.getenv("DATABASE_PASSWORD", "").strip()
    port = os.getenv("DATABASE_PORT", "5432").strip()

    if host and dbname and user and password:
        return f"postgresql://{user}:{password}@{host}:{port}/{dbname}"

    # 3. Default lokal PostgreSQL kamu
    return "postgresql://postgres:afterngopi8@localhost:5432/bioverse_db"


DATABASE_URL = _build_database_url()

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()