import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/certificate_provider.dart';

class CertificateNameDialog extends ConsumerWidget {
  const CertificateNameDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Add a Certificate'),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          TextField(
            controller: ref.read(certificateProvider).certificateNameController,
            decoration: const InputDecoration(
              label: Text('Certificate Name:'),
              hintText: "Enter your Certificate Name",
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(); // بستن دیالوگ بدون انجام کاری
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            ref.read(certificateProvider).updateCertificateName();
            Navigator.of(context).pop(); // بستن دیالوگ
          },
        ),
      ],
    );
  }
}
