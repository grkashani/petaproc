import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../zetaproc/data/zfirebase_service.dart';

class TabletHomeScreen extends ConsumerWidget {
  const TabletHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabletHomeScreen'),
      ),
      body: Center(
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ZFirebaseServices.signOut();
                },
                child: const Text('Sign Out'),
              ),
            )
          ],
        ),
      ),
    );
  }
}