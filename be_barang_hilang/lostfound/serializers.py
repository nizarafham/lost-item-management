from rest_framework import serializers
from .models import Category, LostItem, FoundItem

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = "__all__"

class LostItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = LostItem
        fields = "__all__"

class FoundItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = FoundItem
        fields = "__all__"
