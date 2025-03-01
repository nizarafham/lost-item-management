from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import FoundItem, LostItem, Notification

@receiver(post_save, sender=FoundItem)
def check_matching_lost_items(sender, instance, created, **kwargs):
    if created:
        lost_items = LostItem.objects.filter(
            category=instance.category,
            location_lost=instance.location_found
        )

        for lost_item in lost_items:
            Notification.objects.create(
                user=lost_item.user,
                found_item=instance,
                message=f"Barang yang mirip dengan laporan kehilangan Anda ditemukan di {instance.location_found}"
            )
