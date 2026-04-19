import google.generativeai as genai
import json
from django.conf import settings
import logging

logger = logging.getLogger(__name__)

if settings.GEMINI_API_KEY:
    genai.configure(api_key=settings.GEMINI_API_KEY)

class GeminiService:
    """
    Service for interacting with Google's Gemini AI.
    """
    def __init__(self):
        self.model = genai.GenerativeModel(
            'gemini-1.5-flash',
            generation_config={"response_mime_type": "application/json"}
        )

    def get_nutritional_recommendations(self, user_data):
        """
        Analyze user grocery history and suggest healthy swaps.
        Expects user_data as a JSON-serializable structure.
        Returns a list of recommendations.
        """
        if not settings.GEMINI_API_KEY:
            logger.warning("GEMINI_API_KEY not configured. Returning empty recommendations.")
            return []

        prompt = (
            "Analyze this grocery history and suggest 3-5 healthier swaps. "
            "Ignore any non-food-related personal information if found in meal descriptions. "
            f"Format as JSON array of objects with 'original', 'swap', and 'reason' keys.\n\n"
            f"User History: {json.dumps(user_data)}"
        )

        try:
            response = self.model.generate_content(prompt)
            return json.loads(response.text)
        except Exception as e:
            logger.exception(f"Error calling Gemini API: {e}")
            return []
