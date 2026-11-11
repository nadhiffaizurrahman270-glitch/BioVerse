# BioVerse Backend (FastAPI)

Backend ini menyediakan dua endpoint yang dipakai aplikasi Flutter BioVerse:

| Method | Endpoint              | Dipanggil dari                          |
|--------|-----------------------|------------------------------------------|
| GET    | `/api/v1/materi`      | `lib/services/api_service.dart`          |
| POST   | `/api/v1/ai/tutor`    | `lib/services/ai_tutor_service.dart`     |
| GET    | `/api/v1/health`      | (opsional, untuk uptime monitor)         |

Data materi saat ini disimpan langsung di kode (`app/data.py`), bukan di
database. Ini terpisah dari Firebase/Firestore yang dipakai fitur lain di
aplikasi (login, progres belajar, dll.) — tidak saling menyentuh.

## Jalankan di komputer sendiri (development)

```bash
cd backend
python -m venv .venv
source .venv/bin/activate      # Windows: .venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env           # isi GEMINI_API_KEY kalau mau BioBot aktif
uvicorn app.main:app --reload --port 8000
```

Cek di browser: `http://127.0.0.1:8000/docs`.

Selama backend jalan di komputer sendiri seperti ini, aplikasi Flutter
yang dijalankan dengan `flutter run -d chrome` di komputer yang sama akan
otomatis terhubung ke `http://127.0.0.1:8000` (lihat
`lib/config/api_config.dart`).

## PENTING: ini belum bisa diakses dari internet

`http://127.0.0.1:8000` dan IP seperti `192.168.x.x` cuma bisa diakses
dari jaringan/komputer itu sendiri. Website yang sudah di-deploy ke
GitHub Pages (diakses lewat HTTPS dari mana saja) **tidak akan pernah**
bisa memanggil alamat itu, siapa pun yang membukanya.

Supaya BioVerse yang sudah online bisa memuat materi dan BioBot, backend
ini harus di-deploy ke layanan yang memberi alamat publik dengan **HTTPS**
(wajib HTTPS, karena GitHub Pages pakai HTTPS dan browser akan memblokir
panggilan ke HTTP biasa / mixed content). Beberapa pilihan yang umum
dipakai untuk FastAPI kecil seperti ini:

- **Render** (render.com) — ada free tier, HTTPS otomatis.
- **Railway** (railway.app) — mudah deploy dari GitHub, HTTPS otomatis.
- **Fly.io** — HTTPS otomatis, perlu CLI.
- VPS sendiri + reverse proxy (nginx/caddy) + sertifikat TLS (certbot).

Langkah umumnya kurang lebih:

1. Push folder `backend/` ini ke repo (boleh repo yang sama atau repo
   terpisah).
2. Di layanan hosting, deploy dengan start command:
   `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
3. Isi environment variable `GEMINI_API_KEY` (dan `GEMINI_MODEL` kalau
   mau) di dashboard layanan tersebut.
4. Setelah deploy, layanan akan memberi URL publik, misalnya
   `https://bioverse-api.onrender.com`.
5. Tes dulu: buka `https://<url-dari-layanan>/api/v1/health` di browser,
   harus muncul `{"status":"ok"}`.
6. Set URL itu (ditambah `/api/v1`, jadi
   `https://bioverse-api.onrender.com/api/v1`) sebagai secret/variable
   `API_BASE_URL` di GitHub repo Settings → Secrets and variables →
   Actions, supaya dipakai otomatis saat build GitHub Pages
   (lihat `.github/workflows/deploy.yml`).

Tanpa langkah ini, build production akan tetap memakai alamat
development (`http://127.0.0.1:8000`) dan error "Failed to fetch" di
GitHub Pages akan tetap muncul — bukan karena kode Flutter-nya salah,
tapi karena memang belum ada backend yang bisa diakses dari internet.
