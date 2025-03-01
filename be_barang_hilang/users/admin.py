from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User

class CustomUserAdmin(UserAdmin):
    model = User
    list_display = ("email", "nim", "name", "is_staff", "is_active")
    search_fields = ("email", "nim", "name")
    ordering = ("email",)

admin.site.register(User, CustomUserAdmin)
    