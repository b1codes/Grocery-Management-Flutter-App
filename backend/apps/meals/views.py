from rest_framework import viewsets, permissions
from apps.meals.models import Meal, MealIngredient
from apps.meals.serializers import MealSerializer, MealIngredientSerializer

class MealViewSet(viewsets.ModelViewSet):
    serializer_class = MealSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Meal.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class MealIngredientViewSet(viewsets.ModelViewSet):
    serializer_class = MealIngredientSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return MealIngredient.objects.filter(meal__user=self.request.user)
