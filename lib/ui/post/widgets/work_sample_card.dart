import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constant/constants.dart';
import '../../../data/firebase/firebase_services.dart';
import '../../../data/model/owner.dart';
import '../../../providers/user_provider.dart';
import '../../post/desktop_comments_page.dart';
import '../../post/desktop_work_sample_page.dart';
import 'like_animation.dart';

class WorkSampletCard extends ConsumerWidget {
  final int commentLen = 0;
  final isLikeAnimating = false;
  final Map<String, dynamic> snapshot;

  const WorkSampletCard({
    super.key,
    required this.snapshot,
  });

  fetchCommentLen() async {}

  deleteWorkSamplet(String workSampleId) async {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyUser owner = ref.watch(userProvider).myUser as MyUser;
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webPageSize ? secondaryColor : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    snapshot['profImage'].toString(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Container(
                      alignment: Alignment.topRight,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: primaryColor, fontSize: 20),
                          children: [
                            TextSpan(
                              text: ' ${snapshot['description']}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                snapshot['uid'].toString() == owner.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: ListView(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      'Delete',
                                    ]
                                        .map(
                                          (e) => InkWell(
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                child: Text(e),
                                              ),
                                              onTap: () {
                                                deleteWorkSamplet(
                                                  snapshot['workSampleId'].toString(),
                                                );

                                                Navigator.of(context).pop();
                                              }),
                                        )
                                        .toList()),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      )
                    : Container(),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () {
              FirebaseServices.likePost(
                postId: snapshot['workSampleId'].toString(),
                uid: owner.uid,
                likes: snapshot['likes'],
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WorkSampletDesktopPage(
                        workSampleId: snapshot['workSampleId'].toString(),
                      ),
                    ),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      snapshot['workSampleUrl'].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {},
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              LikeAnimation(
                isAnimating: snapshot['likes'].contains(owner.uid),
                smallLike: true,
                child: IconButton(
                  icon: snapshot['likes'].contains(owner.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                  onPressed: () => FirebaseServices.likePost(
                   postId: snapshot['workSampleId'].toString(),
                    uid: owner.uid,
                    likes: snapshot['likes'],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.comment_outlined,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsDesktopPage(
                      workSampleId: snapshot['workSampleId'].toString(), postId: '',
                    ),
                  ),
                ),
              ),
              IconButton(
                  icon: const Icon(
                    Icons.send,
                  ),
                  onPressed: () {}),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: snapshot['favourites'].contains(owner.uid)
                      ? const Icon(
                          Icons.bookmark,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.bookmark_border,
                        ),
                  onPressed: () => FirebaseServices.favouriteWorkSamplet(
                    snapshot['workSampleId'].toString(),
                    owner.uid,
                    snapshot['favourites'],
                  ),
                ),
              ))
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DefaultTextStyle(
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${snapshot['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsDesktopPage(
                        workSampleId: snapshot['workSampleId'].toString(), postId: '',
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(snapshot['datePublished'].toDate()),
                    style: const TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('snapshot', snapshot));
  }
}
