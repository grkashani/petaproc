
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider = ChangeNotifierProvider<NotificationProvider>((ref) {
  return NotificationProvider(refProvider: ref);
});

class NotificationProvider with ChangeNotifier {
  final ChangeNotifierProviderRef<NotificationProvider> refProvider;
  NotificationProvider({required this.refProvider});

  String pageName = 'Notification Screen';
}
