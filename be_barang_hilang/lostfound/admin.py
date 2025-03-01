from django.contrib import admin
from .models import Category, LostItem, FoundItem

admin.site.register(Category)
admin.site.register(LostItem)
admin.site.register(FoundItem)
