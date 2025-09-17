import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String uid;
  final String profilePicture;
  final String username;
  final String commentMessage;
  final String commentId;
  final DateTime commentTime;
  final List likes;
  CommentModel({
    required this.uid,
    required this.profilePicture,
    required this.username,
    required this.commentMessage,
    required this.commentId,
    required this.commentTime,
    required this.likes,
  });

  static CommentModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CommentModel(
      profilePicture: snapshot['profilePicture'],
      username: snapshot['username'],
      commentMessage: snapshot['commentMessage'],
      commentId: snapshot['commentId'],
      commentTime: snapshot['commentTime'],
      likes: snapshot['likes'],
      uid: snapshot['uid'],
    );
  }

  Map<String, dynamic> toJson() => {
        "profilePicture": profilePicture,
        "username": username,
        "commentMessage": commentMessage,
        "commentId": commentId,
        "commentTime": commentTime,
        "likes": likes,
        "uid": uid,
      };
}
