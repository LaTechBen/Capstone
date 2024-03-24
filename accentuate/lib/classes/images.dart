import 'package:cloud_firestore/cloud_firestore.dart';

class Images {
  final DateTime datePublished;
  final String description;
  final likes;
  final String postID;
  final List<String> postUrl;
  final String uid;
  final String username;

  const Images(
      {required this.datePublished,
      required this.description,
      required this.likes,
      required this.postID,
      required this.postUrl,
      required this.uid,
      required this.username});

  static Images fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Images(
        datePublished: snapshot["datePublished"],
        description: snapshot["description"],
        likes: snapshot["likes"],
        postID: snapshot["postID"],
        postUrl: snapshot["postUrl"],
        uid: snapshot["uid"],
        username: snapshot["username"]);
  }

  Map<String, dynamic> toJson() => {
        "datePublished": datePublished,
        "description": description,
        "likes": likes,
        "postID": postID,
        "postUrl": postUrl,
        "uid": uid,
        "username": username
      };
}
