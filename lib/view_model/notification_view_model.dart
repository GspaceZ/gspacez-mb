import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/model/notification_model.dart';
import 'package:untitled/service/event_bus_service.dart';
import 'package:untitled/service/notification_service.dart';

import '../service/user_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final List<NotificationModel> notifications = [];
  bool _isLoading = false;
  String urlAvatar = AppConstants.urlImageDefault;
  String profileTag = '';
  String token = '';
  late StompClient stompClient;

  bool get isLoading => _isLoading;

  NotificationViewModel() {
    _init();
  }

  Future<void> _init() async {
    /// TODO: use profileId
    profileTag = await LocalStorage.instance.userId ?? '';
    urlAvatar = await LocalStorage.instance.userUrlAvatar ??
        AppConstants.urlImageDefault;
    Log.info("WebSocket connecting with profileId: $profileTag");
    token = await LocalStorage.instance.userToken ?? '';
    connectWithToken(
      "wss://gspacez.tech/api/v1/notification/ws",
      token,
      "/queue/notifications/$profileTag",
    );
    await fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final fetched = await UserService.instance.getNotifications(profileTag);
      notifications.clear();
      notifications.addAll(fetched);
    } catch (e) {
      throw Exception("Fetch notification error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void connectWithToken(String url, String token, String topic) {
    stompClient = StompClient(
      config: StompConfig(
        url: url,
        stompConnectHeaders: {
          'Authorization': 'Bearer $token',
        },
        reconnectDelay: const Duration(seconds: 5),
        heartbeatIncoming: const Duration(seconds: 5),
        heartbeatOutgoing: const Duration(seconds: 5),
        onConnect: (frame) {
          Log.info('Websocket Connected');
          stompClient.subscribe(
            destination: topic,
            callback: (frame) {
              Log.info('Notification response: ${frame.body}');
              KeyedEventBus().sink(AppConstants.keyNotification, 1);
              final notification = NotificationModel.fromJson(
                jsonDecode(frame.body ?? '{}'),
              );
              notifications.insert(0, notification);
              notifyListeners();
              NotificationService().showInstantNotification(
                id: 1,
                title: notification.entity.sender.profileName ?? "",
                body: notification.content,
              );
            },
          );
        },
        onStompError: (frame) {
          Log.error('STOMP Error: ${frame.body}');
        },
        onWebSocketError: (error) {
          Log.error('WebSocket Error: $error');
        },
      ),
    );

    stompClient.activate();
  }
}
