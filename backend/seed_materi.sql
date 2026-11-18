-- ============================================================
-- Seed database BioVerse (PostgreSQL)
--
-- Cara pakai di pgAdmin:
--   1. Pastikan koneksi Query Tool berada di database bioverse_db
--      (klik kanan database bioverse_db -> Query Tool).
--   2. Klik ikon folder (Open File) -> pilih file ini.
--   3. Tekan F5 (Execute).
--
-- Skrip ini idempotent: aman dijalankan berulang kali.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.materi (
    id        integer PRIMARY KEY,
    judul     text    NOT NULL,
    deskripsi text    NOT NULL,
    kategori  text    NOT NULL,
    level     text    NOT NULL,
    konten    text    NOT NULL,
    video_id  text
);

INSERT INTO public.materi (id, judul, deskripsi, kategori, level, konten, video_id)
VALUES
(
    1,
    'DNA & Genetics',
    'Struktur DNA, basa nitrogen, dan dasar-dasar genetika.',
    'Genetics',
    'Beginner',
    $md$# DNA & Genetics

DNA (*Deoxyribonucleic Acid*) adalah molekul pembawa informasi genetik pada hampir semua makhluk hidup. DNA berbentuk **double helix** (heliks ganda) yang tersusun dari untaian nukleotida.

## Komponen Nukleotida
- Gula deoksiribosa
- Gugus fosfat
- Basa nitrogen

## Pasangan Basa Nitrogen
- Adenine (A) berpasangan dengan Thymine (T)
- Guanine (G) berpasangan dengan Cytosine (C)

Pasangan basa ini dihubungkan oleh ikatan hidrogen, dan urutannya menyimpan instruksi genetik yang diwariskan dari orang tua ke keturunannya.$md$,
    NULL
),
(
    2,
    'Cell Biology',
    'Struktur sel sebagai unit dasar kehidupan.',
    'Cell Biology',
    'Beginner',
    $md$# Cell Biology

Sel adalah unit struktural dan fungsional terkecil dari semua makhluk hidup. Ada dua jenis sel utama: **sel prokariotik** (tanpa membran inti, misalnya bakteri) dan **sel eukariotik** (dengan membran inti, misalnya sel hewan dan tumbuhan).

## Organel Utama Sel Eukariotik
- **Nukleus** - menyimpan materi genetik
- **Mitokondria** - pusat respirasi sel / penghasil energi
- **Retikulum Endoplasma** - sintesis dan transport protein/lipid
- **Ribosom** - tempat sintesis protein
- **Membran Sel** - mengatur keluar-masuknya zat

Memahami struktur sel adalah dasar untuk memahami bagaimana seluruh tubuh makhluk hidup bekerja.$md$,
    NULL
),
(
    3,
    'Viruses',
    'Struktur virus dan cara virus menginfeksi sel inang.',
    'Microbiology',
    'Intermediate',
    $md$# Viruses

Virus adalah partikel mikroskopis yang hanya bisa bereplikasi di dalam sel inang. Virus tidak dianggap sepenuhnya hidup karena tidak memiliki struktur sel dan tidak bisa bermetabolisme sendiri.

## Struktur Dasar Virus
- **Materi genetik** - DNA atau RNA
- **Kapsid** - selubung protein pelindung materi genetik
- **Selubung (envelope)** - pada beberapa virus, lapisan lipid tambahan dari membran sel inang

## Siklus Hidup Virus (Litik)
1. Penempelan (attachment) ke reseptor sel inang
2. Penyuntikan materi genetik ke dalam sel
3. Replikasi menggunakan mesin seluler inang
4. Perakitan partikel virus baru
5. Pelepasan (lisis sel inang)$md$,
    NULL
),
(
    4,
    'Life & Ecosystems',
    'Interaksi makhluk hidup dengan lingkungannya dalam ekosistem.',
    'Ecology',
    'Beginner',
    $md$# Life & Ecosystems

Ekosistem adalah satuan interaksi antara makhluk hidup (komponen biotik) dengan lingkungan fisiknya (komponen abiotik) di suatu tempat.

## Komponen Ekosistem
- **Produsen** - organisme yang membuat makanan sendiri, misalnya tumbuhan (fotosintesis)
- **Konsumen** - organisme yang memakan organisme lain
- **Dekomposer** - mengurai sisa organisme menjadi zat hara

## Rantai dan Jaring Makanan
Energi mengalir dari produsen ke konsumen melalui rantai makanan. Kumpulan rantai makanan yang saling berhubungan membentuk jaring-jaring makanan yang menjaga keseimbangan ekosistem.$md$,
    NULL
)
ON CONFLICT (id) DO UPDATE SET
    judul     = EXCLUDED.judul,
    deskripsi = EXCLUDED.deskripsi,
    kategori  = EXCLUDED.kategori,
    level     = EXCLUDED.level,
    konten    = EXCLUDED.konten,
    video_id  = EXCLUDED.video_id;

-- Beri hak baca ke role backend, kalau role-nya sudah ada.
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'bioverse_api') THEN
        EXECUTE 'GRANT USAGE ON SCHEMA public TO bioverse_api';
        EXECUTE 'GRANT SELECT ON public.materi TO bioverse_api';
    END IF;

    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'bioverse_user1') THEN
        EXECUTE 'GRANT USAGE ON SCHEMA public TO bioverse_user1';
        EXECUTE 'GRANT SELECT ON public.materi TO bioverse_user1';
    END IF;
END $$;

SELECT id, judul, kategori, level FROM public.materi ORDER BY id;
