# BioVerse FastAPI backend (PostgreSQL)

Backend ini menjalankan endpoint:
- `GET /api/v1/materi` — membaca `public.materi` dari PostgreSQL.
- `GET /api/v1/materi/{id}` — membaca satu materi dari PostgreSQL.
- `POST /api/v1/ai/tutor` — fitur BioBot yang sudah ada.
- `GET /api/v1/health` — pemeriksaan backend.

## Konfigurasi

Salin `.env.example` menjadi `.env`, lalu isi `DATABASE_PASSWORD` dengan password role PostgreSQL khusus backend (`bioverse_api`). Jangan gunakan akun `postgres` atau akun editor manusia untuk aplikasi.

FastAPI dan PostgreSQL dirancang berjalan pada Ubuntu server yang sama. Backend terhubung ke PostgreSQL melalui `127.0.0.1:5432`; port PostgreSQL tidak perlu dibuka ke internet.

## Install dan jalankan

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# Edit .env terlebih dahulu
uvicorn app.main:app --host 127.0.0.1 --port 8000
```

Uji dari server: `curl http://127.0.0.1:8000/api/v1/health` dan `curl http://127.0.0.1:8000/api/v1/materi`.

Untuk frontend GitHub Pages, publikasikan FastAPI melalui HTTPS (misalnya Cloudflare Tunnel) dan set GitHub Actions variable `API_BASE_URL` ke `https://HOST-API/api/v1`. Pastikan `ALLOWED_ORIGINS` berisi origin GitHub Pages yang benar.
