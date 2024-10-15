import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/providers/certificate_provider.dart';

class QuestionDialog extends ConsumerWidget {
  const QuestionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isSelected = ref.watch(certificateProvider).isTest;

    // فقط یک بار از ref.read استفاده می‌کنیم تا کنترلرها رو بگیریم
    final qc = ref.read(certificateProvider).questionController;
    final hc = ref.read(certificateProvider).hintController;
    final a1c = ref.read(certificateProvider).answer1Controller;
    final a2c = ref.read(certificateProvider).answer2Controller;
    final a3c = ref.read(certificateProvider).answer3Controller;
    final a4c = ref.read(certificateProvider).answer4Controller;

    return AlertDialog(
      title: const Text('Add a Question'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Do you want to add a four-choice question?'),
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  ref.read(certificateProvider).updateQuestion(value!);
                },
              ),
            ],
          ),
          TextField(
            controller: qc,
            decoration: const InputDecoration(
              label: Text('Question:'),
              hintText: "Enter your question",
            ),
          ),
          TextField(
            controller: hc,
            decoration: const InputDecoration(
              hintText: "Hint The Answer",
              labelText: 'Help user',
            ),
          ),
          if (isSelected)
            Column(
              children: [
                Row(
                  children: [
                    const Text('A : '),
                    Expanded(
                      child: TextField(
                        controller: a1c,
                        decoration: const InputDecoration(
                          hintText: "The first answer",
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('B : '),
                    Expanded(
                      child: TextField(
                        controller: a2c,
                        decoration: const InputDecoration(hintText: "The second answer"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('C : '),
                    Expanded(
                      child: TextField(
                        controller: a3c,
                        decoration: const InputDecoration(hintText: "The third answer:"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('D : '),
                    Expanded(
                      child: TextField(
                        controller: a4c,
                        decoration: const InputDecoration(hintText: "The fourth answer:"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            if (isSelected) {
              ref.read(certificateProvider).addQuestionTest(
                question: qc.text,
                hint: hc.text,
                answer1: a1c.text,
                answer2: a2c.text,
                answer3: a3c.text,
                answer4: a4c.text,
              );
            } else {
              ref.read(certificateProvider).addQuestionExplaination(
                question: qc.text,
                hint: hc.text,
              );
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
