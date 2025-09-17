import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String uid;
  final String username;
  final String photoURL;
  final String postDescription;
  final DateTime datePublished;
  final String postId;
  final String postURL;
  final List likes;
  PostModel({
    required this.uid,
    required this.username,
    required this.photoURL,
    required this.postDescription,
    required this.datePublished,
    required this.postId,
    required this.postURL,
    required this.likes,
  });

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      uid: snapshot['uid'],
      username: snapshot['username'],
      photoURL: snapshot['photoURL'],
      postDescription: snapshot['postDescription'],
      datePublished: snapshot['datePublished'],
      postId: snapshot['postId'],
      postURL: snapshot['postURL'],
      likes: snapshot['likes'],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "photoURL": photoURL,
        "postDescription": postDescription,
        "datePublished": datePublished,
        "postId": postId,
        "postURL": postURL,
        "likes": likes,
      };
}
