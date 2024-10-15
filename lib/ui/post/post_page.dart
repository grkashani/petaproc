import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/core/constant/constants.dart';
import 'package:petaproc/ui/post/tablet_post_screen.dart';
import 'package:petaproc/zetaproc/constant/zconstants.dart';
import 'package:petaproc/zetaproc/providers/screen_provider.dart';

import '../../providers/my_providers.dart';
import 'desktop_post_screen.dart';
import 'mobile_post_screen.dart';

class PostPage extends ConsumerWidget {
  const PostPage({super.key});

  void goToHome(WidgetRef ref) {
    ref.read(MyPrividers.mainPageProvider).updateMainState(MainPageState.home);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientScreenPlatform = ref.watch(screenProvider).clienScreen;
    switch (clientScreenPlatform) {
      case ZClientScreen.desktop:
        return const DesktopPostScreen();
      case ZClientScreen.tablet:
        return const TabletPostScreen();
      case ZClientScreen.mobile:
        return MobilePostScreen(onCloseClickListener: () => goToHome);
    }
  }
}
