from apps.grocery.models import Store, GroceryTrip, PurchasedItem
from apps.generic.models import Address
from apps.generic.serializers import AddressSerializer
from rest_framework import serializers

class PurchasedItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = PurchasedItem
        fields = ['id', 'trip', 'pantry_item', 'purchase_price', 'quantity_bought']
        read_only_fields = ['id']

class StoreSerializer(serializers.ModelSerializer):
    address = AddressSerializer(required=False, allow_null=True)
    address_pk = serializers.PrimaryKeyRelatedField(
        queryset=Address.objects.all(),
        write_only=True,
        required=False,
        allow_null=True
    )

    class Meta:
        model = Store
        fields = ['id', 'user', 'name', 'address', 'address_pk', 'trip_count']
        read_only_fields = ['id', 'user', 'trip_count']

    def create(self, validated_data):
        address_data = validated_data.pop('address', None)
        address_pk = validated_data.pop('address_pk', None)
        user = self.context['request'].user
        
        if address_pk:
            validated_data['address'] = address_pk
        elif address_data:
            address = Address.objects.create(created_by=user, **address_data)
            validated_data['address'] = address
            
        return super().create(validated_data)

    def update(self, instance, validated_data):
        address_data = validated_data.pop('address', None)
        address_pk = validated_data.pop('address_pk', None)
        user = self.context['request'].user

        if address_pk:
            instance.address = address_pk
        elif address_data:
            if instance.address:
                for attr, value in address_data.items():
                    setattr(instance.address, attr, value)
                instance.address.updated_by = user
                instance.address.save()
            else:
                instance.address = Address.objects.create(created_by=user, **address_data)
        
        # Other fields like 'name'
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        
        instance.updated_by = user
        instance.save()
        return instance

class GroceryTripSerializer(serializers.ModelSerializer):
    purchased_items = PurchasedItemSerializer(many=True, read_only=True)

    class Meta:
        model = GroceryTrip
        fields = ['id', 'user', 'store', 'trip_date', 'total_spent', 'purchased_items']
        read_only_fields = ['id', 'user', 'purchased_items']