from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, permissions
from django.db.models import Count
from apps.grocery.models import PurchasedItem
from apps.meals.models import Meal
from apps.utils.gemini_service import GeminiService
from django.contrib.auth import get_user_model

User = get_user_model()

class InsightsView(APIView):
    """
    API endpoint that provides nutritional insights based on user history.
    """
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user

        # 1. Fetch user's top 10 PurchasedItems from the 100 most recent items
        recent_purchases_ids = PurchasedItem.objects.filter(trip__user=user) \
            .order_by('-trip__trip_date', '-id')[:100] \
            .values_list('id', flat=True)

        top_purchases = PurchasedItem.objects.filter(id__in=recent_purchases_ids) \
            .values('pantry_item__name') \
            .annotate(purchase_count=Count('pantry_item')) \
            .order_by('-purchase_count')[:10]

        # 2. Fetch user's Meals
        user_meals = Meal.objects.filter(user=user).values('name', 'description')

        # Combine data for Gemini
        user_data = {
            "top_purchases": list(top_purchases),
            "favorite_meals": list(user_meals)
        }

        # 3. Call GeminiService
        gemini = GeminiService()
        recommendations = gemini.get_nutritional_recommendations(user_data)

        # 4. Return results
        return Response({
            "recommendations": recommendations,
            "data_analyzed": user_data
        })
