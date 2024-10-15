import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/ui/home/desktop_home_screen.dart';
import 'package:petaproc/ui/home/mobile_home_screen.dart';
import 'package:petaproc/ui/home/tablet_home_screen.dart';
import 'package:petaproc/zetaproc/constant/zconstants.dart';
import 'package:petaproc/zetaproc/providers/screen_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientScreenPlatform = ref.watch(screenProvider).clienScreen;
    switch (clientScreenPlatform) {
      case ZClientScreen.desktop:
        return const DesktopHomeScreen();
      case ZClientScreen.tablet:
        return const TabletHomeScreen();
      default:
        return const MobileHomeScreen();
    }
  }
}
