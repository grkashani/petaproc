import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/ui/jobs/desktop_jobs_screen.dart';
import 'package:petaproc/ui/jobs/mobile_jobs_screen.dart';
import 'package:petaproc/ui/jobs/tablet_jobs_screen.dart';
import 'package:petaproc/zetaproc/constant/zconstants.dart';
import 'package:petaproc/zetaproc/providers/screen_provider.dart';

class JobsPage extends ConsumerWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientScreenPlatform = ref.watch(screenProvider).clienScreen;
    switch (clientScreenPlatform) {
      case ZClientScreen.desktop:
        return const DesktopJobsScreen();
      case ZClientScreen.tablet:
        return const TabletJobsScreen();
      default:
        return const MobileJobsScreen();
    }
  }
}
