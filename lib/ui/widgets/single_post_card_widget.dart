import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/themes/styles.dart';
import '../../data/firebase/firebase_services.dart';
import '../../providers/user_provider.dart';
import '../post/mobile_comments_page.dart';
import '../post/widgets/like_animation.dart';

class SinglePostCardWidget extends ConsumerWidget {
  final Map<String, dynamic> snapshot;

  const SinglePostCardWidget({
    super.key,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // دسترسی به VolumeNotifier از طریق ref
    final volumeNotifier = ref.watch(volumeProvider); // مشاهده مقدار ولوم
    final isSliderVisible = ref.watch(isSliderVisibleProvider); // مشاهده وضعیت نمایش اسلایدر

    return Column(
      children: [
        Container(
          color: linkedInWhiteFFFFFF,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(snapshot['profileImageUrl']),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                snapshot['username'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  _openBottomModalSheet(context);
                                },
                                child: const Icon(Icons.more_vert))
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              snapshot['bio'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: linkedInMediumGrey86888A),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Text(
                              "${DateFormat('yyyy-MM-dd HH:mm').format(snapshot['timeCreated'].toDate())} - ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: linkedInMediumGrey86888A),
                            ),
                            const Icon(
                              FontAwesomeIcons.earthAmericas,
                              size: 15,
                              color: linkedInMediumGrey86888A,
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                snapshot['description'],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              // Wrap(
              //   children: post.tags!.map((tag) {
              //     return Text(
              //       "$tag ",
              //       style: const TextStyle(color: linkedInBlue0077B5),
              //     );
              //   }).toList(),
              // )
              Text(
                snapshot['tags'],
                style: const TextStyle(color: linkedInBlue0077B5),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(snapshot['postImageUrl']),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                child:
                    _singleReactItemWidget(bgColor: Colors.blue.shade200, image: "thumbs_up.png"),
              ),
              Positioned(
                left: 16,
                child: _singleReactItemWidget(bgColor: Colors.red.shade200, image: "love.png"),
              ),
              Positioned(
                left: 34,
                child:
                    _singleReactItemWidget(bgColor: Colors.amber.shade200, image: "insightful.png"),
              ),
              Positioned(
                left: 70,
                child: Text(snapshot['likes'].length.toString()),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    " comments - ",
                    style: TextStyle(color: linkedInMediumGrey86888A, fontSize: 15),
                  ),
                  Text(
                    " reposts",
                    style: TextStyle(color: linkedInMediumGrey86888A, fontSize: 15),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: linkedInLightGreyCACCCE,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            LikeAnimation(
              isAnimating: snapshot['likes'].contains(ref.watch(userProvider).myUser.uid),
              smallLike: true,
              child: Column(
                children: [
                  isSliderVisible
                      ? SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 8), // کوچک کردن دایره‌ی thumb
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 14), // تغییر اندازه‌ی overlay
                            trackHeight: 2.0, // کاهش ضخامت خط اسلایدر
                          ),
                          child: Slider(
                            value: volumeNotifier.volume,
                            // مقدار ولوم
                            min: 0.0,
                            max: 10.0,
                            divisions: 10,
                            // تنظیم مقادیر بین 0 تا 10
                            label: volumeNotifier.volume.toInt().toString(),
                            onChanged: (newVolume) {
                              ref
                                  .read(volumeProvider)
                                  .setVolume(newVolume); // به روز رسانی ولوم به صورت زنده
                            },
                            onChangeEnd: (newVolume) {
                              FirebaseServices.score(
                                points: newVolume.toInt(),
                                postId: snapshot['postId'],
                                uid: ref.watch(userProvider).myUser.uid,
                                likes: snapshot['likes'],
                              );
                              if (kDebugMode) {
                                print('Selected Volume: ${newVolume.toInt()}');
                              } // چاپ مقدار زمانی که کشیدن تمام شود
                              // بازگرداندن دکمه به جای اسلایدر
                              ref.read(isSliderVisibleProvider.notifier).state = false;
                            },
                          ),
                        )
                      : IconButton(
                          icon: snapshot['likes'].contains(ref.watch(userProvider).myUser.uid)
                              ? const Icon(
                                  Icons.thumb_up_alt_sharp,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.thumb_up_alt_outlined,
                                ),
                          onPressed: () {
                            // نمایش اسلایدر به جای دکمه
                            ref.read(isSliderVisibleProvider.notifier).state = true;
                            FirebaseServices.likePost(
                              postId: snapshot['postId'],
                              uid: ref.watch(userProvider).myUser.uid,
                              likes: snapshot['likes'],
                            );
                          },
                        ),
                  const Text(
                    "Like",
                    style: TextStyle(color: linkedInMediumGrey86888A),
                  )
                ],
              ),
            ),
            Column(children: [
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.commentDots,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsMobilePage(
                      postId: snapshot['postId'],
                      username: snapshot['username'],
                    ),
                  ),
                ),
              ),
              const Text(
                "Comment",
                style: TextStyle(color: linkedInMediumGrey86888A),
              )
            ]),
            Column(children: [
              IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.retweet,
                  ),
                  onPressed: () {}),
              const Text(
                "Repost",
                style: TextStyle(color: linkedInMediumGrey86888A),
              )
            ]),
            Column(children: [
              IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.paperPlane,
                  ),
                  onPressed: () {}),
              const Text(
                "Send",
                style: TextStyle(color: linkedInMediumGrey86888A),
              )
            ]),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          height: 8,
          color: linkedInLightGreyCACCCE,
        ),
      ],
    );
  }
}

_singleReactItemWidget({String? image, Color? bgColor}) {
  return Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(width: 2, color: linkedInWhiteFFFFFF)),
    child: Image.asset(
      "assets/pics/$image",
      width: 10,
      height: 10,
    ),
  );
}

_openBottomModalSheet(context) {
  showModalBottomSheet(
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: const BoxDecoration(
          color: linkedInWhiteFFFFFF,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 70,
                  height: 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), color: linkedInMediumGrey86888A),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              _bottomNavigationItem(title: "Save", iconData: Icons.bookmark_border),
              const SizedBox(
                height: 30,
              ),
              _bottomNavigationItem(title: "Share via", iconData: Icons.share),
              const SizedBox(
                height: 30,
              ),
              _bottomNavigationItem(title: "Unfollow", iconData: Icons.cancel),
              const SizedBox(
                height: 30,
              ),
              _bottomNavigationItem(
                  title: "Remove connection with Username", iconData: Icons.person_remove),
              const SizedBox(
                height: 30,
              ),
              _bottomNavigationItem(title: "Mute Username", iconData: FontAwesomeIcons.soundcloud),
              const SizedBox(
                height: 30,
              ),
              _bottomNavigationItem(title: "Report post", iconData: Icons.flag),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      );
    },
  );
}

_bottomNavigationItem({IconData? iconData, String? title}) {
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

// تعریف یک ChangeNotifier برای مدیریت ولوم
class VolumeNotifier extends ChangeNotifier {
  double _volume = 5.0; // مقدار اولیه ولوم

  double get volume => _volume;

  void setVolume(double newVolume) {
    _volume = newVolume;
    notifyListeners(); // اطلاع رسانی به ویجت‌ها
  }
}

// تعریف یک Provider برای مدیریت ولوم
final volumeProvider = ChangeNotifierProvider<VolumeNotifier>((ref) {
  return VolumeNotifier();
});

// تعریف Provider برای مدیریت وضعیت نمایش اسلایدر یا دکمه
final isSliderVisibleProvider = StateProvider<bool>((ref) => false);
