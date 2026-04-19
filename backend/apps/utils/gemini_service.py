import google.generativeai as genai
import json
from django.conf import settings
import logging

logger = logging.getLogger(__name__)

class GeminiService:
    """
    Service for interacting with Google's Gemini AI.
    """
    def __init__(self):
        if settings.GEMINI_API_KEY:
            genai.configure(api_key=settings.GEMINI_API_KEY)
        self.model = genai.GenerativeModel('gemini-1.5-flash')

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
            f"Analyze this grocery history and suggest 3-5 healthier swaps. "
            f"Format as JSON: [{{'original': '...', 'swap': '...', 'reason': '...'}}].\n\n"
            f"User History: {json.dumps(user_data)}"
        )

        try:
            response = self.model.generate_content(prompt)
            # Find the JSON array in the response
            content = response.text
            start = content.find('[')
            end = content.rfind(']') + 1
            if start != -1 and end != -1:
                json_data = content[start:end]
                return json.loads(json_data)
            else:
                logger.error(f"Could not parse JSON from Gemini response: {content}")
                return []
        except Exception as e:
            logger.exception(f"Error calling Gemini API: {e}")
            return []
