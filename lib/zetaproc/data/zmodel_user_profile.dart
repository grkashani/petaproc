import 'package:cloud_firestore/cloud_firestore.dart';

class ZUserProfileModel {
  final String email;
  final String userName;
  final String profileImageMetadata;
  final String profileImageUrl;
  final String uid;

  const ZUserProfileModel({
    this.email = '',
    this.userName = '',
    this.profileImageMetadata = '',
    this.profileImageUrl = '',
    this.uid = '',
  });

  static ZUserProfileModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ZUserProfileModel(
      email: snapshot["email"],
      userName: snapshot["username"],
      profileImageMetadata: snapshot["profile image metadata"] ?? '',
      profileImageUrl: snapshot["profile image url"] ?? '',
      uid: snapshot["uid"],
    );
  }

  Map<String, dynamic> toJson() => {
    "email": email,
    "username": userName,
    "profileImageMetadata": profileImageMetadata,
    "profileImageUrl": profileImageUrl,
    "uid": uid,
  };
}
