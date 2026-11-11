"""
Data materi biologi.

Ini TIDAK menyentuh Firestore (yang dipakai TopicService / TopicController
di sisi Flutter) ataupun database kasir lain mana pun. Ini sumber data
terpisah, khusus untuk endpoint /api/v1/materi yang dipanggil ApiService
di lib/services/api_service.dart.

Judul (`judul`) sengaja dibuat SAMA PERSIS dengan key di
lib/models/quiz_data.dart, supaya kuis di TopicDetailPage
(`quizData[widget.topic.title]`) tetap ketemu datanya:

    'DNA & Genetics', 'Cell Biology', 'Viruses', 'Life & Ecosystems'

Kalau mau menambah topik baru, tambahkan dict baru di MATERI dengan id unik,
atau tambahkan quiz baru dengan judul yang sama di quiz_data.dart kalau mau
topik itu juga punya kuis.
"""

from __future__ import annotations

from .schemas import MateriOut

MATERI: list[MateriOut] = [
    MateriOut(
        id=1,
        judul="DNA & Genetics",
        deskripsi="Struktur DNA, basa nitrogen, dan dasar-dasar genetika.",
        kategori="Genetics",
        level="Beginner",
        konten=(
            "# DNA & Genetics\n\n"
            "DNA (*Deoxyribonucleic Acid*) adalah molekul pembawa informasi "
            "genetik pada hampir semua makhluk hidup. DNA berbentuk **double "
            "helix** (heliks ganda) yang tersusun dari untaian nukleotida.\n\n"
            "## Komponen Nukleotida\n"
            "- Gula deoksiribosa\n"
            "- Gugus fosfat\n"
            "- Basa nitrogen\n\n"
            "## Pasangan Basa Nitrogen\n"
            "- Adenine (A) berpasangan dengan Thymine (T)\n"
            "- Guanine (G) berpasangan dengan Cytosine (C)\n\n"
            "Pasangan basa ini dihubungkan oleh ikatan hidrogen, dan "
            "urutannya menyimpan instruksi genetik yang diwariskan dari "
            "orang tua ke keturunannya."
        ),
        video_id=None,
    ),
    MateriOut(
        id=2,
        judul="Cell Biology",
        deskripsi="Struktur sel sebagai unit dasar kehidupan.",
        kategori="Cell Biology",
        level="Beginner",
        konten=(
            "# Cell Biology\n\n"
            "Sel adalah unit struktural dan fungsional terkecil dari semua "
            "makhluk hidup. Ada dua jenis sel utama: **sel prokariotik** "
            "(tanpa membran inti, misalnya bakteri) dan **sel eukariotik** "
            "(dengan membran inti, misalnya sel hewan dan tumbuhan).\n\n"
            "## Organel Utama Sel Eukariotik\n"
            "- **Nukleus** - menyimpan materi genetik\n"
            "- **Mitokondria** - pusat respirasi sel / penghasil energi\n"
            "- **Retikulum Endoplasma** - sintesis dan transport protein/lipid\n"
            "- **Ribosom** - tempat sintesis protein\n"
            "- **Membran Sel** - mengatur keluar-masuknya zat\n\n"
            "Memahami struktur sel adalah dasar untuk memahami bagaimana "
            "seluruh tubuh makhluk hidup bekerja."
        ),
        video_id=None,
    ),
    MateriOut(
        id=3,
        judul="Viruses",
        deskripsi="Struktur virus dan cara virus menginfeksi sel inang.",
        kategori="Microbiology",
        level="Intermediate",
        konten=(
            "# Viruses\n\n"
            "Virus adalah partikel mikroskopis yang hanya bisa bereplikasi "
            "di dalam sel inang. Virus tidak dianggap sepenuhnya hidup "
            "karena tidak memiliki struktur sel dan tidak bisa bermetabolisme "
            "sendiri.\n\n"
            "## Struktur Dasar Virus\n"
            "- **Materi genetik** - DNA atau RNA\n"
            "- **Kapsid** - selubung protein pelindung materi genetik\n"
            "- **Selubung (envelope)** - pada beberapa virus, lapisan lipid "
            "tambahan dari membran sel inang\n\n"
            "## Siklus Hidup Virus (Litik)\n"
            "1. Penempelan (attachment) ke reseptor sel inang\n"
            "2. Penyuntikan materi genetik ke dalam sel\n"
            "3. Replikasi menggunakan mesin seluler inang\n"
            "4. Perakitan partikel virus baru\n"
            "5. Pelepasan (lisis sel inang)"
        ),
        video_id=None,
    ),
    MateriOut(
        id=4,
        judul="Life & Ecosystems",
        deskripsi="Interaksi makhluk hidup dengan lingkungannya dalam ekosistem.",
        kategori="Ecology",
        level="Beginner",
        konten=(
            "# Life & Ecosystems\n\n"
            "Ekosistem adalah satuan interaksi antara makhluk hidup "
            "(komponen biotik) dengan lingkungan fisiknya (komponen "
            "abiotik) di suatu tempat.\n\n"
            "## Komponen Ekosistem\n"
            "- **Produsen** - organisme yang membuat makanan sendiri, "
            "misalnya tumbuhan (fotosintesis)\n"
            "- **Konsumen** - organisme yang memakan organisme lain\n"
            "- **Dekomposer** - mengurai sisa organisme menjadi zat hara\n\n"
            "## Rantai dan Jaring Makanan\n"
            "Energi mengalir dari produsen ke konsumen melalui rantai "
            "makanan. Kumpulan rantai makanan yang saling berhubungan "
            "membentuk jaring-jaring makanan yang menjaga keseimbangan "
            "ekosistem."
        ),
        video_id=None,
    ),
]


def get_all_materi() -> list[MateriOut]:
    return MATERI


def get_materi_by_id(materi_id: int) -> MateriOut | None:
    return next((m for m in MATERI if m.id == materi_id), None)
