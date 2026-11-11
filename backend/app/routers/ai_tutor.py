import logging
import os

from fastapi import APIRouter

from ..schemas import TutorRequest, TutorResponse

logger = logging.getLogger("bioverse.ai_tutor")

router = APIRouter(prefix="/api/v1/ai", tags=["ai-tutor"])

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

_model = None
_model_name = os.getenv("GEMINI_MODEL", "gemini-2.5-flash")


def _get_model():
    """Inisialisasi model Gemini sekali saja (lazy), supaya backend tetap
    bisa jalan untuk endpoint lain walau GEMINI_API_KEY belum diisi."""
    global _model

    if _model is not None:
        return _model

    api_key = os.getenv("GEMINI_API_KEY", "").strip()

    if not api_key:
        return None

    try:
        import google.generativeai as genai

        genai.configure(api_key=api_key)
        _model = genai.GenerativeModel(
            _model_name,
            system_instruction=_SYSTEM_PROMPT,
        )
    except Exception:
        logger.exception("Gagal inisialisasi model Gemini")
        return None

    return _model


@router.post("/tutor", response_model=TutorResponse)
async def ask_tutor(payload: TutorRequest) -> TutorResponse:
    """Dipanggil oleh AITutorService.askBioBot() di Flutter."""
    model = _get_model()

    if model is None:
        return TutorResponse(jawaban=_FALLBACK_MESSAGE)

    try:
        response = model.generate_content(payload.pertanyaan)
        text = (response.text or "").strip()

        return TutorResponse(
            jawaban=text or "BioBot tidak menemukan jawaban untuk itu."
        )
    except Exception:
        logger.exception("Gagal memanggil Gemini API")

        return TutorResponse(
            jawaban=(
                "BioBot sedang bermasalah menghubungi Gemini AI. "
                "Coba lagi sebentar lagi."
            )
        )
