import 'package:cloud_firestore/cloud_firestore.dart';

class ZMyUser {
  final String username;
  final String email;
  final String photoUrl;
  final String uid;

  const ZMyUser({
    required this.username,
    required this.email,
    required this.photoUrl,
    required this.uid,
  });

  static ZMyUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ZMyUser(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
      };
}
