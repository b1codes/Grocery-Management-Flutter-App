from django.db import models
from django.conf import settings
from apps.generic.models import DefaultModel
from apps.pantry.models import PantryItem

class Meal(DefaultModel):
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True, null=True)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='meals')
    is_favorite = models.BooleanField(default=False)

    def __str__(self):
        return self.name

class MealIngredient(DefaultModel):
    meal = models.ForeignKey(Meal, on_delete=models.CASCADE, related_name='ingredients')
    pantry_item_template = models.ForeignKey(PantryItem, on_delete=models.CASCADE)
    quantity = models.DecimalField(max_digits=10, decimal_places=2)
    unit = models.CharField(max_length=50, blank=True, null=True)

    def __str__(self):
        return f"{self.quantity} {self.unit} of {self.pantry_item_template.name} for {self.meal.name}"
