from django.urls import path, include
from rest_framework.routers import DefaultRouter
from apps.meals.views import MealViewSet, MealIngredientViewSet

router = DefaultRouter()
router.register(r'meals', MealViewSet, basename='meal')
router.register(r'ingredients', MealIngredientViewSet, basename='mealingredient')

urlpatterns = [
    path('', include(router.urls)),
]
