import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/zetaproc//sign/mobile_signinscreen.dart';
import 'package:petaproc/zetaproc/constant/zconstants.dart';
import 'package:petaproc/zetaproc/constant/ztheme_styles.dart';
import 'package:petaproc/zetaproc/data/zfirebase_service.dart';
import 'package:petaproc/zetaproc/providers/screen_provider.dart';
import 'package:petaproc/zetaproc/providers/sign_page_provider.dart';
import 'package:petaproc/zetaproc/sign/desktop_signin_screen.dart';
import 'package:petaproc/zetaproc/sign/desktop_signup_screen.dart';
import 'package:petaproc/zetaproc/sign/mobile_signup_screen.dart';
import 'package:petaproc/zetaproc/sign/tablet_signin_screen.dart';
import 'package:petaproc/zetaproc/sign/tablet_signup_screen.dart';
import 'package:petaproc/zetaproc/widgets/wiget_button_container.dart';

import '../providers/providers.dart';


class SignInButton extends ConsumerWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignInButton({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(signInLoadingProvider);
    return WidgetButtonContainer(
      title: isLoading ? "Signing In..." : "Sign In",
      onTap: isLoading? null : () async {
        ref.read(signInLoadingProvider.notifier).state = true;
        await ZFirebaseServices.loginUser(email: emailController.text, password: passwordController.text);
        ref.read(signInLoadingProvider.notifier).state = false;
      },
    );
  }
}


class SignButton extends ConsumerWidget {
  // final String projectName;
  final ZSignPageState currentStaet;

  const SignButton({
    super.key,
    required this.currentStaet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
        child: RichText(
      text: TextSpan(
          text: currentStaet == ZSignPageState.signdIn ? "New to Itja ? " : "Already on Itja? ",
          style: const TextStyle(color: zlinkedInBlack000000, fontSize: 16),
          children: [
            TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (currentStaet == ZSignPageState.signdIn) {
                      ref.read(signPageProvider).updateUserState(ZSignPageState.signUp);
                    } else {
                      ref.read(signPageProvider).updateUserState(ZSignPageState.signdIn);
                    }
                  },
                text: currentStaet == ZSignPageState.signdIn ? " Join now" : " Sign In",
                style: const TextStyle(color: zlinkedInBlue0077B5, fontWeight: FontWeight.bold, fontSize: 16))
          ]),
    ));
  }
}


class SignPage extends ConsumerWidget {
  const SignPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = ref.read(signPageProvider).emailController;
    final passwordController = ref.read(signPageProvider).passwordController;
    final usernameController = ref.read(signPageProvider).usernameController;
    final clientScreenPlatform = ref.watch(screenProvider).clienScreen;
    final zSignPageState = ref.watch(signPageProvider).signPageState;
    switch (clientScreenPlatform) {
      case ZClientScreen.mobile:
        if (zSignPageState == ZSignPageState.signdIn) {
          return MobileSigninScreen(
            signButton: SignButton(currentStaet: zSignPageState),
            emailController: emailController,
            passwordController: passwordController,
          );
        } else {
          return MobileSignupScreen(
            signButton: SignButton(currentStaet: zSignPageState),
            usernameController: usernameController,
            emailController: emailController,
            passwordController: passwordController,
          );
        }
      case ZClientScreen.tablet:
        if (zSignPageState == ZSignPageState.signdIn) {
          return TabletSigninScreen(
            signButton: SignButton(currentStaet: zSignPageState),
            emailController: emailController,
            passwordController: passwordController,
          );
        } else {
          return TabletSignupScreen(
            signButton: SignButton(currentStaet: zSignPageState),
            usernameController: usernameController,
            emailController: emailController,
            passwordController: passwordController,
          );
        }
      case ZClientScreen.desktop:
        if (zSignPageState == ZSignPageState.signdIn) {
          return DesktopSigninScreen(
            signButton: SignButton(currentStaet: zSignPageState),
            emailController: emailController,
            passwordController: passwordController,
          );
        } else {
          return DesktopSignupScreen(
            signButton: SignButton(currentStaet: zSignPageState),
            usernameController: usernameController,
            emailController: emailController,
            passwordController: passwordController,
          );
        }
      default:
        if (zSignPageState == ZSignPageState.signdIn) {
          return MobileSigninScreen(
            signButton: SignButton(currentStaet: zSignPageState),
            emailController: emailController,
            passwordController: passwordController,
          );
        } else {
          return MobileSignupScreen(
            signButton: SignButton(currentStaet: zSignPageState),
            usernameController: usernameController,
            emailController: emailController,
            passwordController: passwordController,
          );
        }
    }
  }
}
