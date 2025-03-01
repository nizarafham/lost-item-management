from django.urls import path
from .views import CancelLostItemView, CategoryListCreateView, GenerateQRCodeView, LostItemListCreateView, FoundItemListCreateView, MarkNotificationAsReadView, MatchUserLostItemsView, NotificationListView, VerificationHistoryView, VerifyItemView

urlpatterns = [
    path("categories/", CategoryListCreateView.as_view(), name="category-list"),
    path("lost-items/", LostItemListCreateView.as_view(), name="lost-item-list"),
    path("found-items/", FoundItemListCreateView.as_view(), name="found-item-list"),
    path("match/", MatchUserLostItemsView.as_view(), name="match-user-lost-items"),
    path("cancel-lost/<int:lost_item_id>/", CancelLostItemView.as_view(), name="cancel-lost-item"),
    path("generate-qr/<int:found_item_id>/", GenerateQRCodeView.as_view(), name="generate-qr"),
    path("verify/<int:found_item_id>/", VerifyItemView.as_view(), name="verify-item"),
    path("verification-history/", VerificationHistoryView.as_view(), name="verification-history"),
    path("notifications/", NotificationListView.as_view(), name="notifications"),
    path("notifications/read/<int:notification_id>/", MarkNotificationAsReadView.as_view(), name="mark-notification-read"),

]
