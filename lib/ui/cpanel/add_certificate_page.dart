import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/zetaproc/constant/zconstants.dart';
import 'package:petaproc/zetaproc/providers/screen_provider.dart';

import 'desktop_add_certificate_screen.dart';

class AddCertificatePage extends ConsumerWidget {
  const AddCertificatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientScreenPlatform = ref.watch(screenProvider).clienScreen;
    switch (clientScreenPlatform) {
      case ZClientScreen.desktop:
        return const DesktopAddCretificateScreen();
      case ZClientScreen.tablet:
        return const DesktopAddCretificateScreen();
      default:
        return const DesktopAddCretificateScreen();
    }
  }
}
