import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/view_model/notification_view_model.dart';
import 'package:untitled/components/common_notification.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel(),
      child: Consumer<NotificationViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: viewModel.fetchNotifications,
              child: ListView.builder(
                itemCount: viewModel.notifications.length,
                itemBuilder: (context, index) {
                  return CommonNotification(notification: viewModel.notifications[index]);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
