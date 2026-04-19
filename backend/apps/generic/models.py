from django.conf import settings
from django.db import models
from django.db.models import Q

class Status(models.TextChoices):
    ACTIVE = 'active', 'Active'
    INACTIVE = 'inactive', 'Inactive'
    COMPLETED = 'completed', 'Completed'

class DefaultModelManager(models.Manager):
    def active(self):
        return self.filter(status=Status.ACTIVE)

    def inactive(self):
        return self.filter(status=Status.INACTIVE)

class DefaultModel(models.Model):
    status = models.CharField(
        max_length=10,
        choices=Status.choices,
        default=Status.ACTIVE,
        null=False,
        blank=True
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    objects = DefaultModelManager()

    class Meta:
        abstract = True
        ordering = ['-created_at']


class Address(DefaultModel):
    address_line = models.CharField(max_length=255)
    city = models.CharField(max_length=100)
    state = models.CharField(max_length=100)
    zip_code = models.CharField(max_length=20)
    country = models.CharField(max_length=100, default='USA')
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
        return f"{self.address_line}, {self.city}, {self.state}, {self.zip_code}, {self.country}"
    
    class Meta:
        verbose_name_plural = 'Addresses'
        ordering = ['-created_at']
        unique_together = ('address_line', 'city', 'state', 'zip_code', 'country')