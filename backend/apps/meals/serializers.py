from rest_framework import serializers
from apps.meals.models import Meal, MealIngredient

class MealIngredientSerializer(serializers.ModelSerializer):
    class Meta:
        model = MealIngredient
        fields = ['id', 'meal', 'pantry_item_template', 'quantity', 'unit', 'created_at', 'updated_at']

class MealSerializer(serializers.ModelSerializer):
    ingredients = MealIngredientSerializer(many=True, read_only=True)

    class Meta:
        model = Meal
        fields = ['id', 'name', 'description', 'user', 'is_favorite', 'ingredients', 'created_at', 'updated_at']
        read_only_fields = ['user']
