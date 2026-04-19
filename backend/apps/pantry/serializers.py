from rest_framework import serializers
from apps.pantry.models import PantryItem, Category

class PantryItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = PantryItem
        fields = ['id', 'user', 'name', 'category', 'quantity', 'regular_price', 'brand', 'upc', 'image_url', 'last_updated']
        read_only_fields = ['id', 'user']

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name']
        read_only_fields = ['id']