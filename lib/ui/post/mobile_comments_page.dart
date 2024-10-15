import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/ui/post/widgets/comment_card.dart';

import '../../data/firebase/firebase_services.dart';
import '../../data/model/user_profile_model.dart';
import '../../providers/post_provider.dart';
import '../../providers/user_provider.dart';

class CommentsMobilePage extends ConsumerWidget {
  final String postId;
  final String username;

  CommentsMobilePage({
    super.key,
    required this.postId,
    required this.username,
  });

  final TextEditingController commentEditingController = TextEditingController();

  void postComment(
      {required String uid, required String userName, required String profileImageUrl}) async {
    try {
      String res = await FirebaseServices.postComment(
        postId: postId,
        uid: uid,
        userName: userName,
        profileImageUrl: profileImageUrl,
        comment: commentEditingController.text,
      );

      if (res != 'success') {}
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserProfileModel owner = ref.watch(userProvider).myUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ITJA Post')
            .doc(postId)
            .collection('comments')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              comment: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: MemoryImage(ref.watch(userProvider).image),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: ref.watch(postProvider).reply.userName.isEmpty
                      ?'Add a comment for $username'
                      :'@${ref.watch(postProvider).reply.userName}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  postComment(
                    uid: owner.uid,
                    userName: owner.userName,
                    profileImageUrl: owner.profileImageUrl,
                  );
                  commentEditingController.text = '';
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Send',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
