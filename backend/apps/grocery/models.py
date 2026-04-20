from apps.generic.models import DefaultModel, Address
from django.db import models
from django.conf import settings
from apps.pantry.models import PantryItem


class Store(DefaultModel):
    """
    Represents a physical grocery store where the user shops.
    """
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    name = models.CharField(max_length=200)
    address = models.ForeignKey(
        Address,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        help_text="Optional address of the store.",
        related_name='stores'
    )
    trip_count = models.PositiveIntegerField(default=0, help_text="Automatically incremented count of trips to this store.")
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
    
class GroceryTrip(DefaultModel):
    """
    Represents a single grocery shopping trip.
    """
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    store = models.ForeignKey(Store, on_delete=models.CASCADE, related_name='trips')
    trip_date = models.DateField()
    total_spent = models.DecimalField(max_digits=10, decimal_places=2)
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
        return f"Trip to {self.store.name} on {self.trip_date}"

class PurchasedItem(DefaultModel):
    """
    An associative entity that links a PantryItem to a GroceryTrip,
    recording the specific details of that purchase.
    """
    trip = models.ForeignKey(GroceryTrip, on_delete=models.CASCADE, related_name='purchased_items')
    pantry_item = models.ForeignKey(PantryItem, on_delete=models.CASCADE, related_name='purchase_history')
    purchase_price = models.DecimalField(max_digits=10, decimal_places=2)
    quantity_bought = models.DecimalField(max_digits=10, decimal_places=2, default=1)
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
        return f"{self.quantity_bought} of {self.pantry_item.name} on trip {self.trip.id}"
