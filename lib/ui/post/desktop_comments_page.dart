import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/ui/post/widgets/comment_card.dart';

import '../../core/constant/constants.dart';
import '../../data/firebase/firebase_services.dart';
import '../../data/model/owner.dart';
import '../../providers/user_provider.dart';

class CommentsDesktopPage extends ConsumerWidget {
  final String postId;

  CommentsDesktopPage({super.key, required this.postId, required String workSampleId});

  final TextEditingController commentEditingController = TextEditingController();

  void postComment(String uid, String name) async {
    try {
      String res = await FirebaseServices.postComment(
        postId: postId,
        uid: uid,
        userName: name,
        comment: commentEditingController.text,
        profileImageUrl: ''
      );

      if (res != 'success') {}
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyUser owner = ref
        .watch(userProvider)
        .myUser as MyUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream:
        FirebaseFirestore.instance.collection('workSamples').doc(postId).collection('comments').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) =>
                CommentCard(
                  comment: snapshot.data!.docs[index],
                ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              // CircleAvatar(
              //   backgroundImage: NetworkImage(owner.photoUrl),
              //   radius: 18,
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${owner.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () =>
                    postComment(
                      owner.uid,
                      owner.username,
                    ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'WorkSamplet',
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
