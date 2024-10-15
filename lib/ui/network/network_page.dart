import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/ui/network/desktop_Network_screen.dart';
import 'package:petaproc/ui/network/mobile_Network_screen.dart';
import 'package:petaproc/ui/network/tablet_Network_screen.dart';
import 'package:petaproc/zetaproc/constant/zconstants.dart';
import 'package:petaproc/zetaproc/providers/screen_provider.dart';

class NetworkPage extends ConsumerWidget {
  const NetworkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientScreenPlatform = ref.watch(screenProvider).clienScreen;
    switch (clientScreenPlatform) {
      case ZClientScreen.desktop:
        return const DesktopNetworkScreen();
      case ZClientScreen.tablet:
        return const TabletNetworkScreen();
      default:
        return const MobileNetworkScreen();
    }
  }
}
