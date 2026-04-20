from rest_framework import serializers
from .models import Address


class AddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = Address
        fields = ['id', 'address_line', 'city', 'state', 'zip_code', 'country']
        read_only_fields = ['id']