import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petaproc/core/constant/constants.dart';
import 'package:petaproc/data/model/enum.dart';
import 'package:petaproc/data/model/widgets_info.dart';

import '../../core/themes/styles.dart';
import '../../core/utils/utils.dart';
import '../../providers/certificate_provider.dart';
import '../../zetaproc/data/zfirebase_service.dart';
import '../widgets/video_player_widget.dart';
import 'dialogs/certificate_name_dialog.dart';
import 'dialogs/question_dialog.dart';

class DesktopAddCretificateScreen extends ConsumerWidget {
  const DesktopAddCretificateScreen({super.key});

  _createSubPostNavigationItem({IconData? iconData, String? title}) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Column(
        children: [
          Icon(
            iconData,
            size: 25,
            color: linkedInMediumGrey86888A,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "$title",
            style: const TextStyle(
                fontSize: 16, color: linkedInMediumGrey86888A, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Future<void> myShowDialog(BuildContext context, WidgetRef ref, WhichDialog whichDialog) async {
    Widget myDialog;
    switch (whichDialog) {
      case WhichDialog.certificateName:
        myDialog = const CertificateNameDialog();
      case WhichDialog.addQuestion:
        myDialog = const QuestionDialog();
      // default:
      //   myDialog = const QuestionDialog();
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return (myDialog);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> st = ['A', 'B', 'C', 'D'];
    final wl = ref.watch(certificateProvider).myWidgetList;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
              child: Text(ref.watch(certificateProvider).certificateName),
              onTap: () {
                myShowDialog(context, ref, WhichDialog.certificateName);
              },
            ),
            Expanded(child: Container()),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                "Submit Request",
                style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: linkedInBlue0077B5),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ZFirebaseServices.signOut();
              },
              child: const Text('Sign Out'),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ListView.builder(
                itemCount: wl.length,
                itemBuilder: (context, index) {
                  switch (wl[index].type) {
                    case WidgetType.question:
                      final q = (wl[index] as MyQuestion);
                      if (q.isTest) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                q.question,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                q.hint,
                                style: const TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (int i = 0; i < q.answers.length; i++)
                                      if (q.answers[i].isNotEmpty)
                                        Text(
                                          '${st[i]} - ${q.answers[i]}',
                                          style: const TextStyle(fontSize: 14, color: Colors.black),
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                q.question,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                q.hint,
                                style: const TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        );
                      }

                    case WidgetType.image:
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 400,
                              height: 400,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage((wl[index] as MyImage).fileU8),
                                  // fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      );
                    case WidgetType.video:
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 400,
                                height: 400,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: VideoPlayerWidget(videoBytes: (wl[index] as MyVideo).fileU8)),
                          ],
                        ),
                      );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    myShowDialog(context, ref, WhichDialog.addQuestion);
                  },
                  child:
                      _createSubPostNavigationItem(title: "Add a Question", iconData: Icons.work),
                ),
                InkWell(
                  onTap: () async {
                    await ref
                        .read(certificateProvider)
                        .addImage(file: await pickImage(source: ImageSource.gallery));
                  },
                  child: _createSubPostNavigationItem(title: "Add a photo", iconData: Icons.image),
                ),
                InkWell(
                  onTap: () async {
                    await ref
                        .read(certificateProvider)
                        .addVideo(file: await pickVideo(source: ImageSource.gallery));
                  },
                  child: _createSubPostNavigationItem(
                      title: "Add a video", iconData: Icons.video_call),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
