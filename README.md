# 🧬 BIOVERSE

BioVerse adalah platform pembelajaran biologi interaktif berbasis web yang dirancang untuk membantu siswa memahami konsep-konsep biologi secara visual, terstruktur, dan menyenangkan. Dilengkapi dengan materi kurikulum interaktif, sistem kuis dan papan peringkat (leaderboard), serta asisten belajar cerdas berbasis AI (BioBot).

---

## ✨ Fitur

- 🔐 Autentikasi Terintegrasi
- 🧬 Eksplorasi Materi Biologi Dinamis
- 🖥️ BioBot — AI Biology Tutor
- 🎨 Gamifikasi & Evaluasi BelajarUI biologi

---

## 🛠️ Spesifikasi Teknis (Tech Stack)

### Frontend
| Teknologi | Penggunaan |
|---|---|
| FLutter | Framework |
| Provider | State Management |
| dio & http | Networking / HTTP Client |
| google_sign_in (v7+), shared_preferences | Autentikasi & Penyimpanan Lokal |
| GitHub | Deployment |

### Backend
| Teknologi | Penggunaan |
|---|---|
| FastAPI(Python 3.10+ | Framework |
| Uvicorn | Server ASGI |
| SQLAlchemy + PostgreSQL | ORM & Database |
| OAuth2 Password Bearer, python-jose, passlib, google-auth | Keamanan & Autentikasi |
| google-generativeai | Integrasi AI |
| Tailscale VPN | Jaringan / Tunneling Development |

---

## 🌐 Live Demo
**[Aplikasi](https://nadhiffaizurrahman270-glitch.github.io/BioVerse/)**
&nbsp; • &nbsp;
**[API Documentation (Swagger UI)](http://127.0.0.1:8000/docs#/)**

## 📁 Struktur Project

```text
├── lib/                        # Kode sumber utama Flutter
│   ├── config/                 # Konfigurasi API Base URL (api_config.dart)
│   ├── controllers/            # State management (TopicController, BookmarkController)
│   ├── models/                 # Model data Dart
│   ├── services/               # Layanan integrasi API & Auth (auth_service.dart, api_service.dart)
│   ├── views/                  # Halaman UI (HomePage, LoginPage, SignUpPage, DashboardPage, dll.)
│   └── main.dart               # Entry point aplikasi Flutter
├── web/                        # Konfigurasi Flutter Web & Google OAuth Client ID (index.html)
└── bioverse-backend/           # Server Backend FastAPI (terpisah/terintegrasi)
    ├── database.py             # Koneksi engine & session PostgreSQL
    ├── models.py               # Definisi tabel SQLAlchemy (User, Materi, UserScore)
    ├── schemas.py              # Validasi skema data Pydantic
    ├── main.py                 # Endpoint API, CORS, JWT Auth, & Gemini AI Tutor
    └── requirements.txt        # Daftar dependensi Python
```
## Daftar Endpoint API Utama
| Method | Endpoint | Deskripsi | Autentikasi |
| :--- | :--- | :--- | :---: |
| `GET` | `/api/v1/health` | Mengecek status kesehatan server & koneksi PostgreSQL | Tidak |
| `POST` | `/api/v1/auth/register` | Mendaftarkan akun pengguna baru | Tidak |
| `POST` | `/api/v1/auth/login` | Login pengguna (OAuth2 Form) & menghasilkan JWT | Tidak |
| `POST` | `/api/v1/auth/google` | Verifikasi Google ID Token & menghasilkan JWT | Tidak |
| `GET` | `/api/v1/users/me` | Mengambil profil & total XP pengguna yang sedang login | **Ya (Bearer)** |
| `GET` | `/api/v1/materi` | Mengambil seluruh daftar materi biologi | Tidak |
| `GET` | `/api/v1/materi/{id}` | Mengambil detail materi berdasarkan ID | Tidak |
| `POST` | `/api/v1/materi` | Menambahkan materi baru ke database | **Ya (Bearer)** |
| `POST` | `/api/v1/scores` | Menyimpan skor hasil kuis pengguna | Tidak |
| `GET` | `/api/v1/leaderboard` | Menampilkan peringkat pengguna berdasarkan total skor | Tidak |
| `POST` | `/api/v1/ai/tutor` | Mengirim pertanyaan biologi ke BioBot (Gemini AI) | Tidak |

---

## 🚀 Panduan Menjalankan Proyek Secara Lokal

### 1. Menjalankan Backend (FastAPI)
```bash
# Masuk ke direktori backend
cd bioverse-backend

# Buat dan aktifkan virtual environment
python -m venv venv
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Install dependensi
pip install -r requirements.txt

# Buat file .env dan isi konfigurasi berikut:
# DATABASE_URL=postgresql://user:password@localhost:5432/bioverse_db
# GOOGLE_API_KEY=your_gemini_api_key

# Jalankan server
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

### 2. Menjalankan Frontend (Flutter Web)
```bash
# Masuk ke direktori root Flutter
flutter pub get

# Pastikan baseUrl di lib/config/api_config.dart mengarah ke server backend Anda
# Jalankan di browser Chrome pada port 8080 (sesuai Google OAuth Authorized Origin)
flutter run -d chrome --web-port=8080
```

---
