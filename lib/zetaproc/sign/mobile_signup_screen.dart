import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petaproc/zetaproc/widgets/wiget_button_container.dart';
import 'package:petaproc/zetaproc/widgets/widget_google_button_container.dart';

import 'package:petaproc/zetaproc/data/zfirebase_service.dart';
import 'package:petaproc/zetaproc/providers/message_provider.dart';

class MobileSignupScreen extends ConsumerWidget {
  final ConsumerWidget signButton;
  const MobileSignupScreen({
    super.key,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.signButton,
  });

  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobileSignupScreen'),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/pictures/logo.png",
                height: 100,
                color: Colors.blue,
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              const Text(
                "Join ITJA",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "UserName",
                ),
                controller: usernameController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
                controller: emailController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
                controller: passwordController,
              ),
              const SizedBox(height: 10),
              WidgetButtonContainer(
                title: "Continue",
                onTap: () async {
                  // ref.read(responsiveProvider).changeIsLoading();
                  String res = await ZFirebaseServices.signUpUser(
                    email: emailController.text,
                    password: passwordController.text,
                    username: usernameController.text,
                  );
                  if (res == "success") {
                    if (!context.mounted) return;
                    // ref.read(responsiveProvider).changeIsLoading();
                  } else {
                    // ref.read(responsiveProvider).changeIsLoading();
                    if (!context.mounted) return;
                    // showSnackBar(context, res);
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              GoogleWidgetButtonContainer(onTap: (){
                ref.read(messageProvider).showMessage('Sign up with Google is not ready');
              },
                hasIcon: true,
                icon: SvgPicture.asset(
                  "assets/pictures/google_logo_svg.svg",
                  width: 30,
                  height: 30,
                ),
                title: "Sign up with Google",
              ),
              const SizedBox(
                height: 10,
              ),
              GoogleWidgetButtonContainer(onTap: (){
                ref.read(messageProvider).showMessage('Sign up with Apple is not ready');
              },
                hasIcon: true,
                icon: const Icon(
                  FontAwesomeIcons.apple,
                  size: 22,
                ),
                title: "Sign Up with Apple",
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: signButton,
              )
            ],
          ),
        ),
      ),
    );
  }
}