import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/ui/Notifications/desktop_Notifications_screen.dart';
import 'package:petaproc/ui/Notifications/mobile_Notifications_screen.dart';
import 'package:petaproc/ui/Notifications/tablet_Notifications_screen.dart';
import 'package:petaproc/zetaproc/constant/zconstants.dart';
import 'package:petaproc/zetaproc/providers/screen_provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientScreenPlatform = ref.watch(screenProvider).clienScreen;
    switch (clientScreenPlatform) {
      case ZClientScreen.desktop:
        return const DesktopNotificationsScreen();
      case ZClientScreen.tablet:
        return const TabletNotificationsScreen();
      default:
        return const MobileNotificationsScreen();
    }
  }
}
