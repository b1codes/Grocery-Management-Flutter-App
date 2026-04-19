from django.test import TestCase
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from django.contrib.auth import get_user_model
from apps.pantry.models import PantryItem
from apps.meals.models import Meal, MealIngredient
from apps.grocery.models import GroceryTrip, PurchasedItem, Store
from unittest.mock import patch
import datetime

User = get_user_model()

class MealModelTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(username='testuser', email='test@example.com', password='password')
        self.meal = Meal.objects.create(name='Test Meal', user=self.user)
        self.pantry_item = PantryItem.objects.create(name='Test Item', user=self.user, regular_price=2.99)
        self.meal_ingredient = MealIngredient.objects.create(
            meal=self.meal,
            pantry_item_template=self.pantry_item,
            quantity=1.0,
            unit='kg'
        )

    def test_pantry_item_related_name(self):
        # This should fail if related_name='meal_ingredients' is not set
        self.assertTrue(hasattr(self.pantry_item, 'meal_ingredients'))
        self.assertEqual(self.pantry_item.meal_ingredients.first(), self.meal_ingredient)

class MealAPITest(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(username='apiuser', email='api@example.com', password='password')
        self.client.force_authenticate(user=self.user)
        self.meal = Meal.objects.create(name='API Meal', user=self.user)
        self.pantry_item = PantryItem.objects.create(name='API Item', user=self.user, regular_price=1.99)
        self.meal_ingredient = MealIngredient.objects.create(
            meal=self.meal,
            pantry_item_template=self.pantry_item,
            quantity=2.0,
            unit='pcs'
        )

    def test_list_meals(self):
        url = reverse('meal-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['name'], 'API Meal')

    def test_list_meal_ingredients(self):
        url = reverse('mealingredient-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(float(response.data[0]['quantity']), 2.0)

class InsightsAPITest(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(username='insightuser', email='insight@example.com', password='password')
        self.client.force_authenticate(user=self.user)
        
        # Create some data for insights
        self.store = Store.objects.create(user=self.user, name='Test Store')
        self.trip = GroceryTrip.objects.create(user=self.user, store=self.store, trip_date=datetime.date.today(), total_spent=50.0)
        self.pantry_item = PantryItem.objects.create(user=self.user, name='Regular Milk', regular_price=3.50)
        self.purchased_item = PurchasedItem.objects.create(trip=self.trip, pantry_item=self.pantry_item, purchase_price=3.50, quantity_bought=2)
        
        self.meal = Meal.objects.create(user=self.user, name='Cereal', description='Milk and cereal')

    @patch('apps.utils.gemini_service.GeminiService.get_nutritional_recommendations')
    def test_get_insights(self, mock_gemini):
        mock_gemini.return_value = [
            {'original': 'Regular Milk', 'swap': 'Skim Milk', 'reason': 'Lower fat content'}
        ]
        
        url = reverse('insights')
        response = self.client.get(url)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('recommendations', response.data)
        self.assertEqual(len(response.data['recommendations']), 1)
        self.assertEqual(response.data['recommendations'][0]['swap'], 'Skim Milk')
        self.assertIn('data_analyzed', response.data)
        self.assertEqual(response.data['data_analyzed']['top_purchases'][0]['pantry_item__name'], 'Regular Milk')
