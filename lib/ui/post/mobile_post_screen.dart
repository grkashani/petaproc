import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/utils.dart';
import '../../core/themes/styles.dart';
import '../../providers/post_provider.dart';
import '../../providers/user_provider.dart';

class MobilePostScreen extends ConsumerStatefulWidget {
  final Function onCloseClickListener;

  const MobilePostScreen({super.key, required this.onCloseClickListener});

  @override
  ConsumerState createState() => _MobilePostState();
}

class _MobilePostState extends ConsumerState<MobilePostScreen> {
  bool _openTwoBottomModalSheetsOnce = false;

  final FocusScopeNode _subPostBottomModalSheetFocusNode = FocusScopeNode();
  final FocusScopeNode _superPostBottomModalSheetFocusNode = FocusScopeNode();

  bool _isPostButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    ref.read(postProvider).descriptionController.addListener(() {
      setState(() {
        // دکمه زمانی فعال می‌شود که متن موجود نباشد
        _isPostButtonEnabled = ref.read(postProvider).descriptionController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    ref.read(postProvider).descriptionController.dispose();
    ref.read(postProvider).tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_openTwoBottomModalSheetsOnce == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _createSuperPostBottomModalSheet();
        _createSubPostBottomModalSheet();
        if (kDebugMode) {
          print("value before = $_openTwoBottomModalSheetsOnce");
        }
        setState(() {
          _openTwoBottomModalSheetsOnce = true;
        });
        if (kDebugMode) {
          print("value after = $_openTwoBottomModalSheetsOnce");
        }
      });
    }

    return const Scaffold();
  }

  _createSuperPostBottomModalSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, void Function(void Function()) setState) {
          return FocusScope(
            node: _superPostBottomModalSheetFocusNode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 110,
                  decoration: const BoxDecoration(color: linkedInWhiteFFFFFF, boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 2),
                        color: linkedInLightGreyCACCCE,
                        blurRadius: 5,
                        spreadRadius: 0.1),
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                                onTap: (){
                                  widget.onCloseClickListener;
                                },
                                child: const Icon(
                                  Icons.close_outlined,
                                  size: 30,
                                )),
                            const SizedBox(
                              width: 15,
                            ),
                            const Text(
                              "Share Post",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: linkedInMediumGrey86888A),
                            )
                          ],
                        ),
                        ElevatedButton(
                          onPressed: _isPostButtonEnabled
                              ? () {
                                  // کد مربوط به ارسال پست
                                  ref.watch(postProvider).addPost();
                                }
                              : null, // اگر دکمه غیرفعال باشد، onPressed باید null باشد
                          child: Text(
                            "Post",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _isPostButtonEnabled
                                    ? linkedInBlue0077B5
                                    : linkedInLightGreyCACCCE),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: MemoryImage(ref.watch(userProvider).image),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _switchWidget(
                                    title: "Doug Stevenson",
                                    prefixIcon: Icons.account_circle_rounded,
                                    suffixIcon: Icons.arrow_drop_down_outlined),
                                const SizedBox(
                                  height: 5,
                                ),
                                _switchWidget(
                                    title: "Anyone",
                                    prefixIcon: FontAwesomeIcons.earthAmericas,
                                    suffixIcon: Icons.arrow_drop_down_outlined),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: ref.watch(postProvider).descriptionController,
                          onTap: () {
                            ref.watch(postProvider).descriptionController.addListener(() {
                              if (ref.watch(postProvider).descriptionController.text.length == 1) {
                                setState(() {});
                                if (kDebugMode) {
                                  print("call first IF setState");
                                }
                              } else if (ref
                                  .watch(postProvider)
                                  .descriptionController
                                  .text
                                  .isEmpty) {
                                setState(() {});
                                if (kDebugMode) {
                                  print("2nd ELSE IF setState");
                                }
                              }

                              if (kDebugMode) {
                                print("onTap called");
                              }
                            });
                          },
                          style: const TextStyle(fontSize: 22),
                          maxLines: 3,
                          decoration: const InputDecoration(
                              hintText: "What do you want to talk about?",
                              border: InputBorder.none),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: ref.watch(postProvider).tagsController,
                          onTap: () {
                            ref.watch(postProvider).tagsController.addListener(() {
                              if (ref.watch(postProvider).tagsController.text.length == 1) {
                                setState(() {});
                                if (kDebugMode) {
                                  print("call first IF setState");
                                }
                              } else if (ref.watch(postProvider).tagsController.text.isEmpty) {
                                setState(() {});
                                if (kDebugMode) {
                                  print("2nd ELSE IF setState");
                                }
                              }

                              if (kDebugMode) {
                                print("onTap called");
                              }
                            });
                          },
                          style: const TextStyle(fontSize: 22),
                          maxLines: 3,
                          decoration: const InputDecoration(
                              hintText: "What do you want to tags about?",
                              border: InputBorder.none),
                        ),
                        if (ref.watch(postProvider).image.isNotEmpty)
                          Container(
                            width: 400,
                            height: 400,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(ref.watch(postProvider).image),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            color: linkedInMediumGrey86888A,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Icon(
                            Icons.video_call,
                            color: linkedInMediumGrey86888A,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Icon(
                            Icons.image,
                            color: linkedInMediumGrey86888A,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          GestureDetector(
                              onTap: () {
                                _createSubPostBottomModalSheet();
                              },
                              child: const Icon(
                                Icons.more_horiz,
                                color: linkedInMediumGrey86888A,
                              )),
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.message_outlined,
                            color: linkedInMediumGrey86888A,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Anyone",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: linkedInMediumGrey86888A),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        });
      },
    ).then((value) {
      _superPostBottomModalSheetFocusNode.unfocus();
    });
  }

  _switchWidget({String? title, IconData? prefixIcon, IconData? suffixIcon}) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: linkedInMediumGrey86888A)),
      child: Row(
        children: [
          Icon(
            prefixIcon,
            color: linkedInMediumGrey86888A,
            size: 18,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            "$title",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(
            width: 5,
          ),
          Icon(
            suffixIcon,
            size: 30,
          ),
        ],
      ),
    );
  }

  _createSubPostBottomModalSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return FocusScope(
          node: _subPostBottomModalSheetFocusNode,
          child: Container(
            decoration: BoxDecoration(color: linkedInWhiteFFFFFF, boxShadow: [
              BoxShadow(
                  offset: const Offset(5, 0),
                  blurRadius: 1,
                  color: linkedInLightGreyCACCCE.withOpacity(0.6),
                  spreadRadius: 0.5)
            ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 80,
                        height: 6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: linkedInMediumGrey86888A),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        await ref
                            .read(postProvider)
                            .addImage(file: await pickImage(source: ImageSource.gallery));
                        _createSuperPostBottomModalSheet();
                      },
                      child:
                          _createSubPostNavigationItem(title: "Add a photo", iconData: Icons.image),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    _createSubPostNavigationItem(title: "Take a video", iconData: Icons.video_call),
                    const SizedBox(
                      height: 25,
                    ),
                    _createSubPostNavigationItem(
                        title: "Use a template", iconData: Icons.temple_buddhist),
                    const SizedBox(
                      height: 25,
                    ),
                    _createSubPostNavigationItem(
                        title: "Celebrate an occasion", iconData: Icons.celebration),
                    const SizedBox(
                      height: 25,
                    ),
                    _createSubPostNavigationItem(
                        title: "Add a document", iconData: Icons.document_scanner),
                    const SizedBox(
                      height: 25,
                    ),
                    _createSubPostNavigationItem(
                        title: "Share that you're hiring", iconData: Icons.work),
                    const SizedBox(
                      height: 25,
                    ),
                    _createSubPostNavigationItem(
                        title: "Find an expert", iconData: Icons.account_circle_rounded),
                    const SizedBox(
                      height: 25,
                    ),
                    _createSubPostNavigationItem(title: "Create a poll", iconData: Icons.bar_chart),
                    const SizedBox(
                      height: 25,
                    ),
                    _createSubPostNavigationItem(title: "Create an event", iconData: Icons.event),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) {
      _subPostBottomModalSheetFocusNode.unfocus();
    });
  }

  _createSubPostNavigationItem({IconData? iconData, String? title}) {
    return Row(
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
    );
  }
}
