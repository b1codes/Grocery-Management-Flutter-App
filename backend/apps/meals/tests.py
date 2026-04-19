from django.test import TestCase
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from django.contrib.auth import get_user_model
from apps.pantry.models import PantryItem
from apps.meals.models import Meal, MealIngredient

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
