import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashProvider = FutureProvider<bool>((ref) async {
  // Simulating a splash screen delay of 3 seconds
  await Future.delayed(const Duration(milliseconds: 3000));
  return true;
});

class SplashPage extends ConsumerStatefulWidget {
  final Widget child;

  const SplashPage({super.key, required this.child});

  @override
  SplashPageState createState() => SplashPageState(); // Public State class
}

class SplashPageState extends ConsumerState<SplashPage> {
  @override
  Widget build(BuildContext context) {
    final splashState = ref.watch(splashProvider);

    splashState.when(
      data: (isReady) {
        if (isReady) {
          // Ensure the widget is still mounted before navigating
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => widget.child),
                    (route) => false,
              );
            });
          }
        }
      },
      loading: () => const CircularProgressIndicator(), // Optional loading indicator
      error: (error, stack) => Text('Error: $error'), // Error handling
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/pictures/logo.png", // Ensure the image exists in your assets
          color: Colors.blue,
        ),
      ),
    );
  }
}
