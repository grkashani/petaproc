import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePostModel {
  String description;
  String tags;
  List likes;

  CreatePostModel({
    required this.description,
    required this.tags,
    required this.likes,
  });

  // تبدیل DocumentSnapshot به PostModel
  static CreatePostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CreatePostModel(
      description: snapshot["description"] ?? '',
      tags: snapshot["tags"] ?? '',
      likes: snapshot["likes"] ?? [],
    );
  }

  // تبدیل PostModel به Map برای ذخیره در Firebase
  Map<String, dynamic> toJson() => {
    "description": description,
    "tags": tags,
    "likes": likes,
  };
}

// class ViewPostModel {
//   final String? uid;
//   final String? profileImageUrl;
//   final String? username;
//   final String? userBio;
//
//   String? postImageUrl;
//   String? description;
//   String? tags;
//   // List<String>? tags;
//   final DateTime? timeCreated;
//   final num? totalReacts;
//   final num? totalComments;
//   final num? totalReposts;
//
//
//   ViewPostModel({
//     this.postImageUrl,
//     this.description,
//     this.tags,
//   });
//
//   // تبدیل DocumentSnapshot به PostModel
//   static ViewPostModel fromSnap(DocumentSnapshot snap) {
//     var snapshot = snap.data() as Map<String, dynamic>;
//
//     return ViewPostModel(
//       postImageUrl: snapshot["postImageUrl"] ?? '',
//       description: snapshot["description"] ?? '',
//       tags: snapshot["tags"] ?? '',
//     );
//   }
//
//   // تبدیل PostModel به Map برای ذخیره در Firebase
//   Map<String, dynamic> toJson() => {
//     "postImageUrl": postImageUrl,
//     "description": description,
//     "tags": tags,
//   };
// }
