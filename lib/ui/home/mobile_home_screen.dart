import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/data/firebase/firebase_services.dart';

import '../../core/constant/constants.dart';
import '../widgets/single_post_card_widget.dart';

class MobileHomeScreen extends ConsumerWidget {
  const MobileHomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final width = MediaQuery.of(context).size.width;
    try {
      return Scaffold(
        body: StreamBuilder(
            stream: FirebaseServices.streamPost,
            builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) => Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: width > webPageSize ? width * 0.3 : 0,
                    vertical: width > webPageSize ? 15 : 0,
                  ),
                  child: SinglePostCardWidget(
                    snapshot: snapshot.data!.docs[index].data(),
                  ),
                ),
              );
            }),
      );
    } catch (e) {
      return Text(e.toString());
    }
  }
}
