import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/core/themes/styles.dart';

class DesktopJobsScreen extends ConsumerWidget {
  const DesktopJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Text('DesktopJobsScreen'),
              Expanded(child: Container()),
              ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "Submit Request",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: linkedInBlue0077B5),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
