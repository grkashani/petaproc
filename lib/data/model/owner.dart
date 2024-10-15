import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String username;
  final String email;
  final String uid;
  final String bio;

  const MyUser({
    required this.username,
    required this.email,
    required this.uid,
    required this.bio,
  });

  static MyUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return MyUser(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      bio: snapshot["bio"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
    "email": email,
    "bio": bio,
      };
}
