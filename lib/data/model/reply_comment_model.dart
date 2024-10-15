import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyCommentModel {
  String commentId;
  String userName;

  ReplyCommentModel({
    required this.commentId,
    required this.userName,
  });

  // تبدیل DocumentSnapshot به PostModel
  static ReplyCommentModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ReplyCommentModel(
      commentId: snapshot["commentId"] ?? '',
      userName: snapshot["userName"] ?? '',
    );
  }

  // تبدیل PostModel به Map برای ذخیره در Firebase
  Map<String, dynamic> toJson() => {
    "commentId": commentId,
    "userName": userName,
  };
}
