from django.urls import path, include
from rest_framework.routers import DefaultRouter
from apps.meals.views import MealViewSet, MealIngredientViewSet
from apps.meals.insights_views import InsightsView

router = DefaultRouter()
router.register(r'meals', MealViewSet, basename='meal')
router.register(r'ingredients', MealIngredientViewSet, basename='mealingredient')

urlpatterns = [
    path('', include(router.urls)),
    path('insights/', InsightsView.as_view(), name='insights'),
]
