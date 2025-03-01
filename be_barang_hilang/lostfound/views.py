from rest_framework import generics, permissions
from .models import Category, LostItem, FoundItem, Notification
from .serializers import CategorySerializer, LostItemSerializer, FoundItemSerializer
from rest_framework.permissions import BasePermission
from django.db.models import Q
from difflib import SequenceMatcher
from rest_framework.response import Response
from rest_framework.views import APIView
from django.utils.timezone import now

class IsAdminUser(BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_staff 


class CategoryListCreateView(generics.ListCreateAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer


    def get_permissions(self):
        if self.request.method == "POST": 
            return [IsAdminUser()]
        return [permissions.IsAuthenticated()]


class LostItemListCreateView(generics.ListCreateAPIView):
    queryset = LostItem.objects.all()
    serializer_class = LostItemSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class FoundItemListCreateView(generics.ListCreateAPIView):
    queryset = FoundItem.objects.all()
    serializer_class = FoundItemSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


def similarity(a, b):
    return SequenceMatcher(None, a.lower(), b.lower()).ratio()


class MatchUserLostItemsView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        lost_items = LostItem.objects.filter(user=request.user)
        matched_results = []

        for lost_item in lost_items:
            matched_items = []
            found_items = FoundItem.objects.filter(category=lost_item.category)

            for found in found_items:
                desc_similarity = similarity(lost_item.description, found.description)
                loc_similarity = similarity(lost_item.location_lost, found.location_found)

                if desc_similarity > 0.5 and loc_similarity > 0.5:
                    matched_items.append(FoundItemSerializer(found).data)

            matched_results.append({
                "lost_item": LostItemSerializer(lost_item).data,
                "matched_items": matched_items
            })

        return Response({"matches": matched_results})


class CancelLostItemView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def delete(self, request, lost_item_id):
        try:
            lost_item = LostItem.objects.get(id=lost_item_id, user=request.user)
            lost_item.delete()
            return Response({"message": "Laporan kehilangan berhasil dibatalkan"}, status=200)
        except LostItem.DoesNotExist:
            return Response({"error": "Laporan tidak ditemukan atau bukan milik Anda"}, status=404)


class GenerateQRCodeView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, found_item_id):
        try:
            found_item = FoundItem.objects.get(id=found_item_id, user=request.user)
        except FoundItem.DoesNotExist:
            return Response({"error": "Barang tidak ditemukan atau bukan milik Anda"}, status=404)

        verification, created = Verification.objects.get_or_create(found_item=found_item, finder=request.user)
        verification.generate_qr_code()
        verification.save()

        return Response({"qr_code_url": verification.qr_code.url})


class VerifyItemView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, found_item_id):
        try:
            verification = Verification.objects.get(found_item_id=found_item_id)
        except Verification.DoesNotExist:
            return Response({"error": "QR Code tidak valid"}, status=404)

        if verification.claimer:
            return Response({"error": "Barang sudah diklaim sebelumnya"}, status=400)

        verification.claimer = request.user
        verification.verified_at = now()
        verification.save()

        return Response({"message": "Barang berhasil diverifikasi"})


class VerificationHistoryView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        verifications = Verification.objects.filter(verified_at__isnull=False)
        data = []

        for verification in verifications:
            data.append({
                "found_item": {
                    "id": verification.found_item.id,
                    "name": verification.found_item.name,
                    "description": verification.found_item.description,
                    "location_found": verification.found_item.location_found,
                    "category": verification.found_item.category.name,
                    "image": request.build_absolute_uri(verification.found_item.image.url) if verification.found_item.image else None,
                },
                "finder": {
                    "nim": verification.finder.nim if hasattr(verification.finder, "nim") else None,
                    "email": verification.finder.email,
                },
                "claimer": {
                    "nim": verification.claimer.nim if verification.claimer and hasattr(verification.claimer, "nim") else None,
                    "email": verification.claimer.email if verification.claimer else None,
                },
                "verified_at": verification.verified_at.strftime("%Y-%m-%d %H:%M:%S") if verification.verified_at else None,
            })

        return Response(data)


class NotificationListView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        notifications = Notification.objects.filter(user=request.user, is_read=False).order_by("-created_at")
        data = [{
            "id": notification.id,
            "message": notification.message,
            "found_item": {
                "id": notification.found_item.id,
                "name": notification.found_item.name,
                "description": notification.found_item.description,
                "location_found": notification.found_item.location_found,
                "category": notification.found_item.category.name,
                "image": request.build_absolute_uri(notification.found_item.image.url) if notification.found_item.image else None,
            },
            "created_at": notification.created_at.strftime("%Y-%m-%d %H:%M:%S")
        } for notification in notifications]

        return Response(data)


class MarkNotificationAsReadView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, notification_id):
        try:
            notification = Notification.objects.get(id=notification_id, user=request.user)
            notification.is_read = True
            notification.save()
            return Response({"message": "Notifikasi ditandai sebagai dibaca"})
        except Notification.DoesNotExist:
            return Response({"error": "Notifikasi tidak ditemukan"}, status=404)
