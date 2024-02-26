import 'package:cloud_firestore/cloud_firestore.dart';

class User {
// todo once DB changes
  final String username;
  final String profileImage;
  final following;

  const User({
    required this.username,
    required this.profileImage,
    required this.following,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      following: snapshot['following'],
      username: snapshot['username'],
      profileImage: snapshot['profileImage'],
    );
  }

  Map<String, dynamic> toJson() => {
        "following": following,
        "username": username,
        "profileImage": profileImage,
      };
}
