import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/ui/main_page.dart';
import 'package:petaproc/zetaproc/data/zfirebase_service.dart';
import 'package:petaproc/zetaproc/pages/splash_page.dart';
import 'package:petaproc/zetaproc/zeta_main_page.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options: ZFirebaseServices.currentPlatform);
    runApp(const ProviderScope(
      child: ZetaApp(),
    ));
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
}

class ZetaApp extends ConsumerWidget {
  const ZetaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zeta Project',
      home: SplashPage(
        child: ZetaMainPage(
          mainPage: MainPage(),
        ),
      ),
    );
  }
}

