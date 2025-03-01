from django.db import models
from users.models import User
import qrcode
from io import BytesIO
from django.core.files.base import ContentFile

class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name

class LostItem(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)  # User yang melaporkan
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True)
    name = models.CharField(max_length=255)
    description = models.TextField()
    location_lost = models.CharField(max_length=255)
    date_lost = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

class FoundItem(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)  # User yang menemukan
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True)
    name = models.CharField(max_length=255)
    description = models.TextField()
    location_found = models.CharField(max_length=255)
    date_found = models.DateField()
    image = models.ImageField(upload_to="found_items/", null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

class Verification(models.Model):
    found_item = models.OneToOneField(FoundItem, on_delete=models.CASCADE)
    finder = models.ForeignKey(User, on_delete=models.CASCADE, related_name="finder")
    claimer = models.ForeignKey(User, null=True, blank=True, on_delete=models.SET_NULL, related_name="claimer")
    verified_at = models.DateTimeField(null=True, blank=True)

    qr_code = models.ImageField(upload_to='qr_codes/', blank=True)

    def generate_qr_code(self):
        qr = qrcode.make(f"verify/{self.found_item.id}/")
        buffer = BytesIO()
        qr.save(buffer, format="PNG")
        self.qr_code.save(f"qr_{self.found_item.id}.png", ContentFile(buffer.getvalue()), save=False)

class Notification(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)  # User yang kehilangan barang
    found_item = models.ForeignKey(FoundItem, on_delete=models.CASCADE)  # Barang yang ditemukan
    message = models.TextField()
    is_read = models.BooleanField(default=False)  # Status notifikasi (sudah dibaca atau belum)
    created_at = models.DateTimeField(auto_now_add=True)
