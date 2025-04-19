import 'package:flutter/material.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/model/notification_model.dart';

import '../service/user_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final List<NotificationModel> notifications = [];
  bool _isLoading = false;
  String urlAvatar = AppConstants.urlImageDefault;
  String profileId = '';

  bool get isLoading => _isLoading;

  NotificationViewModel() {
    _init();
  }

  Future<void> _init() async {
    profileId = await LocalStorage.instance.userId ?? '';
    urlAvatar = await LocalStorage.instance.userUrlAvatar ?? AppConstants.urlImageDefault;
    await fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final fetched = await UserService.instance.getNotifications(profileId);
      notifications.clear();
      notifications.addAll(fetched);
    } catch (e) {
      throw Exception("Fetch notification error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
