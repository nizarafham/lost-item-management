from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.db import models
from django.core.exceptions import ValidationError

def validate_email_domain(email):
    allowed_domains = ["student.universitaspertamina.ac.id", "universitaspertamina.ac.id"]
    domain = email.split("@")[-1]
    if domain not in allowed_domains:
        raise ValidationError("Email harus menggunakan domain universitaspertamina.ac.id")

class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError("Email wajib diisi")
        email = self.normalize_email(email)
        validate_email_domain(email)  # Validasi domain email
        extra_fields.setdefault("is_active", True)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password, **extra_fields):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)
        return self.create_user(email, password, **extra_fields)

class User(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True, validators=[validate_email_domain])
    nim = models.CharField(max_length=9, unique=True, blank=True, null=True)  # Hanya untuk mahasiswa
    name = models.CharField(max_length=25, blank=True, null=True)  # Untuk dosen
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = CustomUserManager()

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = []

    def __str__(self):
        return self.email
