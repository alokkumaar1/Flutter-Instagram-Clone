import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone_flutter/Models/comment_models.dart';
import 'package:instagram_clone_flutter/Models/post_model.dart';
import 'package:instagram_clone_flutter/Services/storage_service.dart';
import 'package:uuid/uuid.dart';

abstract class PostService {
  Future<void> addPost({
    required String postDescription,
    required File postURL,
    required List likes,
    required String uid,
    required String username,
    required String photoURL,
  });
  Future<void> postComment({
    required String postId,
    required String commentMessage,
    required String uid,
    required String username,
    required List likes,
    required String profilePicture,
  });
  Future<void> likePost({
    required String uid,
    required String postId,
    required List likes,
  });
  Future<void> likeComment({
    required String uid,
    required String commentId,
    required List likes,
    required String postId,
  });
  Future<void> unFollowUser({
    required String uid,
    required String targetUserId,
  });
  Future<void> followUser({
    required String uid,
    required String targetUserId,
  });
}

class PostServiceImpl implements PostService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<void> addPost({
    required String postDescription,
    required File postURL,
    required List likes,
    required String uid,
    required String username,
    required String photoURL,
  }) async {
    try {
      final postUrl =
          await StorageServiceImpl().savePostFiles(postURL, 'Posts');
      final postId = const Uuid().v4();
      PostModel postModel = PostModel(
        uid: uid,
        username: username,
        photoURL: photoURL,
        postDescription: postDescription,
        datePublished: DateTime.now(),
        postId: postId,
        postURL: postUrl,
        likes: likes,
      );

      await _firebaseFirestore
          .collection('Posts')
          .doc(postId)
          .set(postModel.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> postComment({
    required String postId,
    required String commentMessage,
    required String uid,
    required String username,
    required List likes,
    required String profilePicture,
  }) async {
    try {
      if (commentMessage.isNotEmpty) {
        final commentId = const Uuid().v4();
        CommentModel commentModel = CommentModel(
          uid: uid,
          profilePicture: profilePicture,
          username: username,
          commentMessage: commentMessage,
          commentId: commentId,
          commentTime: DateTime.now(),
          likes: likes,
        );
        await _firebaseFirestore
            .collection('Posts')
            .doc(postId)
            .collection('Comments')
            .doc(commentId)
            .set(commentModel.toJson());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> likePost(
      {required String uid,
      required String postId,
      required List likes}) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection('Posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore.collection('Posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> likeComment(
      {required String uid,
      required String commentId,
      required String postId,
      required List likes}) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore
            .collection('Posts')
            .doc(postId)
            .collection('Comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore
            .collection('Posts')
            .doc(postId)
            .collection('Comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> unFollowUser(
      {required String uid, required String targetUserId}) async {
    try {
      DocumentSnapshot snapshot =
          await _firebaseFirestore.collection('Users').doc(uid).get();

      List following = (snapshot.data()! as dynamic)['following'];

      if (following.contains(targetUserId)) {
        await _firebaseFirestore.collection('Users').doc(targetUserId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });

        await _firebaseFirestore.collection('Users').doc(uid).update({
          'following': FieldValue.arrayRemove([targetUserId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> followUser({
    required String uid,
    required String targetUserId,
  }) async {
    try {
      DocumentSnapshot snapshot =
          await _firebaseFirestore.collection('Users').doc(uid).get();

      List following = (snapshot.data()! as dynamic)['following'];

      if (!following.contains(targetUserId)) {
        await _firebaseFirestore.collection('Users').doc(targetUserId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });

        await _firebaseFirestore.collection('Users').doc(uid).update({
          'following': FieldValue.arrayUnion([targetUserId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
