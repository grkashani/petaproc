import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petaproc/zetaproc/sign/sign_page.dart';
import 'package:petaproc/zetaproc/constant/ztheme_styles.dart';
import 'package:petaproc/zetaproc/widgets/widget_google_button_container.dart';

class DesktopSigninScreen extends ConsumerWidget {
  final ConsumerWidget signButton;
  final TextEditingController emailController;

  final TextEditingController passwordController;

  const DesktopSigninScreen({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.signButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DesktopSigninScreen'),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Image.asset(
                  "assets/pictures/logo.png",
                  height: 100,
                  color: Colors.blue,
                ),
              ),
              const Text(
                "Sign in",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Stay updated on your professional world",
                style: TextStyle(fontSize: 14),
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
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Forgot password?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: zlinkedInBlue0077B5),
              ),
              const SizedBox(
                height: 15,
              ),
              SignInButton(
                emailController: emailController,
                passwordController: passwordController,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      color: zlinkedInMediumGrey86888A,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("or"),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      color: zlinkedInMediumGrey86888A,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              GoogleWidgetButtonContainer(
                hasIcon: true,
                icon: SvgPicture.asset(
                  "assets/pictures/google_logo_svg.svg",
                  width: 30,
                  height: 30,
                ),
                title: "Sign In with Google",
              ),
              const SizedBox(
                height: 10,
              ),
              const GoogleWidgetButtonContainer(
                hasIcon: true,
                icon: Icon(
                  FontAwesomeIcons.apple,
                  size: 22,
                ),
                title: "Sign In with Apple",
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
