import 'package:flutter/material.dart';

class ZLoadingProgress extends StatelessWidget {
  const ZLoadingProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Text("Loading"),
        ],
      ),
    );
  }
}
