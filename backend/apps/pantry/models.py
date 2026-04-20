from django.conf import settings
from django.db import models
from apps.generic.models import DefaultModel


class Category(DefaultModel):
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True, null=True)
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='%(class)s_created'
    )
    updated_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='%(class)s_updated'
    )

    def __str__(self):
        return self.name
    
class PantryItem(DefaultModel):
    """
    Represents a generic item that can be stored in the pantry.
    This model holds the 'master' information about a product.
    """
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    name = models.CharField(max_length=200)
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True, blank=True)
    quantity = models.PositiveIntegerField(default=0, help_text="Current quantity in the pantry.")
    regular_price = models.DecimalField(max_digits=10, decimal_places=2, help_text="The typical, non-discounted price.")
    last_updated = models.DateTimeField(auto_now=True)
    min_threshold = models.PositiveIntegerField(default=1, help_text="Notify when quantity drops below this.")
    
    # Fields to be populated by the UPC API
    upc = models.CharField(max_length=50, blank=True, null=True, unique=True)
    brand = models.CharField(max_length=100, blank=True, null=True)
    image_url = models.URLField(max_length=500, blank=True, null=True)
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='%(class)s_created'
    )
    updated_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='%(class)s_updated'
    )

    def __str__(self):
        return self.name