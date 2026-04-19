from rest_framework import serializers
from apps.meals.models import Meal, MealIngredient
from apps.pantry.models import PantryItem
from apps.pantry.serializers import PantryItemSerializer

class MealIngredientSerializer(serializers.ModelSerializer):
    class Meta:
        model = MealIngredient
        fields = ['id', 'meal', 'pantry_item_template', 'quantity', 'unit', 'created_at', 'updated_at']
        extra_kwargs = {
            'meal': {'required': False}
        }

    def __init__(self, *args, **kwargs):
        super(MealIngredientSerializer, self).__init__(*args, **kwargs)
        if 'request' in self.context:
            user = self.context['request'].user
            self.fields['meal'].queryset = Meal.objects.filter(user=user)
            self.fields['pantry_item_template'].queryset = PantryItem.objects.filter(user=user)

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['pantry_item_template'] = PantryItemSerializer(instance.pantry_item_template).data
        return representation

class MealSerializer(serializers.ModelSerializer):
    ingredients = MealIngredientSerializer(many=True, required=False)

    class Meta:
        model = Meal
        fields = ['id', 'name', 'description', 'user', 'is_favorite', 'ingredients', 'created_at', 'updated_at']
        read_only_fields = ['user']

    def create(self, validated_data):
        ingredients_data = validated_data.pop('ingredients', [])
        meal = Meal.objects.create(**validated_data)
        for ingredient_data in ingredients_data:
            MealIngredient.objects.create(meal=meal, **ingredient_data)
        return meal

    def update(self, instance, validated_data):
        ingredients_data = validated_data.pop('ingredients', None)
        
        # Update Meal fields
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        if ingredients_data is not None:
            # Delete existing ingredients and recreate them
            instance.ingredients.all().delete()
            for ingredient_data in ingredients_data:
                MealIngredient.objects.create(meal=instance, **ingredient_data)
        
        return instance
