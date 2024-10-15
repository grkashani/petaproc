import 'package:cloud_firestore/cloud_firestore.dart';

class WorkSamplet {
  final String description;
  final String uid;
  final String username;
  final List<dynamic> likes;
  final List<dynamic> favourites;
  final String workSampleId;
  final DateTime datePublished;
  final String workSampleUrl;
  final String profImage;

  const WorkSamplet({
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.favourites,
    required this.workSampleId,
    required this.datePublished,
    required this.workSampleUrl,
    required this.profImage,
  });

  static WorkSamplet fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return WorkSamplet(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        favourites: snapshot["favourites"],
        workSampleId: snapshot["workSampleId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        workSampleUrl: snapshot['workSampleUrl'],
        profImage: snapshot['profImage']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "favourites": favourites,
        "username": username,
        "workSampleId": workSampleId,
        "datePublished": datePublished,
        'workSampleUrl': workSampleUrl,
        'profImage': profImage
      };
}
