import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/providers/notification_provider.dart';

import '../../core/themes/styles.dart';

class DesktopNotificationsScreen extends ConsumerWidget {
  const DesktopNotificationsScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
              child: Text(ref.watch(notificationProvider).pageName),
              onTap: () {
              },
            ),
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
      body: const Center()
    );
  }
}
