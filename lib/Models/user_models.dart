import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String bio;
  final String photoURL;
  final List following;
  final List followers;
  final List posts;
  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.bio,
    required this.photoURL,
    required this.following,
    required this.followers,
    required this.posts,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoURL,
        "bio": bio,
        "followers": followers,
        "following": following,
        "posts": posts,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      email: snapshot['email'],
      username: snapshot['username'],
      bio: snapshot['bio'],
      photoURL: snapshot['photoUrl'],
      following: snapshot['following'],
      followers: snapshot['followers'],
      posts: snapshot['posts'],
      uid: snapshot['uid'],
    );
  }
}
