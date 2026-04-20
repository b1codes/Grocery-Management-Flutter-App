from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from django.contrib.auth import get_user_model
from apps.budget.models import MonthlyBudget
from apps.grocery.models import GroceryTrip, Store
from apps.generic.models import Address
import datetime

User = get_user_model()

class BudgetStatsTest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(email='test@example.com', username='testuser', password='password')
        self.client.force_authenticate(user=self.user)
        
        self.address = Address.objects.create(address_line='123 Test St', city='Test City', state='TS', zip_code='12345', country='Test Country')
        self.store = Store.objects.create(name='Test Store', user=self.user, address=self.address)
        
        # Create budget for current month
        self.now = datetime.datetime.now()
        self.budget = MonthlyBudget.objects.create(
            user=self.user,
            month=self.now.month,
            year=self.now.year,
            budget_amount=500.00
        )
        
        # Create some trips for the current month
        self.trip1 = GroceryTrip.objects.create(
            user=self.user,
            store=self.store,
            trip_date=self.now.date(),
            total_spent=50.00
        )
        
        self.trip2 = GroceryTrip.objects.create(
            user=self.user,
            store=self.store,
            trip_date=self.now.date() - datetime.timedelta(days=2),
            total_spent=75.50
        )
        
        # Create a trip for another month (should not be included in stats)
        other_date = self.now.date() - datetime.timedelta(days=40)
        self.trip_other = GroceryTrip.objects.create(
            user=self.user,
            store=self.store,
            trip_date=other_date,
            total_spent=100.00
        )

    def test_get_budget_stats(self):
        url = reverse('monthlybudget-stats')  # DRF DefaultRouter uses 'modelname-actionname' or similar. 
        # Wait, if router.register(r'budgets', BudgetViewSet), then basename is 'monthlybudget' or 'budget'?
        # Let's check BudgetViewSet basename.
        
        # I'll try to find the url name.
        response = self.client.get('/api/budget/budgets/stats/', {'month': self.now.month, 'year': self.now.year})
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['month'], self.now.month)
        self.assertEqual(response.data['year'], self.now.year)
        self.assertEqual(response.data['budget_amount'], 500.00)
        self.assertEqual(response.data['total_spent'], 125.50)
        self.assertEqual(len(response.data['spending_trends']), 2)
        
        # Check trend data
        dates = [item['date'] for item in response.data['spending_trends']]
        self.assertIn(self.now.date().strftime('%Y-%m-%d'), dates)
        self.assertIn((self.now.date() - datetime.timedelta(days=2)).strftime('%Y-%m-%d'), dates)
