import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String email;
  final String userName;
  final String profileImageUrl;
  final String uid;
  final String bio;

  const UserProfileModel({
    this.email = '',
    this.userName = '',
    this.profileImageUrl = '',
    this.uid = '',
    this.bio = '',
  });

  static UserProfileModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserProfileModel(
      email: snapshot["email"],
      userName: snapshot["username"],
      profileImageUrl: snapshot["profileImageUrl"] ?? '',
      uid: snapshot["uid"],
      bio: snapshot["bio"],
    );
  }

  Map<String, dynamic> toJson() => {
    "email": email,
    "username": userName,
    "profileImageUrl": profileImageUrl,
    "uid": uid,
    "bio": bio,
  };
}
