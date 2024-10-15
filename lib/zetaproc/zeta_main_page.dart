import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/ui/cpanel/add_certificate_page.dart';
import 'package:petaproc/zetaproc/constant/zutils.dart';
import 'package:petaproc/zetaproc/data/zfirebase_service.dart';
import 'package:petaproc/zetaproc/sign/sign_page.dart';
import 'package:petaproc/zetaproc/providers/message_provider.dart';
import 'package:petaproc/zetaproc/providers/screen_provider.dart';

class ZetaMainPage extends ConsumerWidget {
  final ConsumerWidget mainPage;

  const ZetaMainPage({super.key, required this.mainPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Size screenSize = MediaQuery.of(context).size;
      ref.read(screenProvider).updateClientScreen(screenSize);
    });
    final authState = ref.watch(ZFirebaseServices.authStateProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.watch(messageProvider).isMessage) {
        zshowSnackBar(context, ref.read(messageProvider).message);
        ref.read(messageProvider).hideMessage();
      }
    });

    return authState.when(data: (User? user) {
      if (user != null) {
        return user.email == 'grkashani@gmail.com'? const AddCertificatePage() : mainPage;
      } else {
        return const SignPage();
      }
    }, error: (Object error, StackTrace stackTrace) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error Page'),
        ),
      );
    }, loading: () {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error Page'),
        ),
      );
    });
  }
}
