from rest_framework import serializers
from apps.meals.models import Meal, MealIngredient
from apps.pantry.models import PantryItem

class MealIngredientSerializer(serializers.ModelSerializer):
    class Meta:
        model = MealIngredient
        fields = ['id', 'meal', 'pantry_item_template', 'quantity', 'unit', 'created_at', 'updated_at']

    def __init__(self, *args, **kwargs):
        super(MealIngredientSerializer, self).__init__(*args, **kwargs)
        if 'request' in self.context:
            user = self.context['request'].user
            self.fields['meal'].queryset = Meal.objects.filter(user=user)
            self.fields['pantry_item_template'].queryset = PantryItem.objects.filter(user=user)

class MealSerializer(serializers.ModelSerializer):
    ingredients = MealIngredientSerializer(many=True, read_only=True)

    class Meta:
        model = Meal
        fields = ['id', 'name', 'description', 'user', 'is_favorite', 'ingredients', 'created_at', 'updated_at']
        read_only_fields = ['user']
