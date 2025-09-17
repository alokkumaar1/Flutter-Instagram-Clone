import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone_flutter/Models/user_models.dart' as models;
import 'package:instagram_clone_flutter/Services/storage_service.dart';

abstract class AuthService {
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String username,
    required File photoURL,
    required String password,
    required String bio,
  });
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<models.UserModel> getUserDetails();
}

class AuthServiceImpl implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        throw FirebaseAuthException;
      }
    } catch (e) {
      FirebaseAuthException;
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String username,
    required File photoURL,
    required String password,
    required String bio,
  }) async {
    try {
      if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
        final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final uid = credential.user!.uid;
        final photoUrl = await StorageServiceImpl()
            .saveUserProfile(photoURL, 'profile Picature');

        models.UserModel userModel = models.UserModel(
          uid: uid,
          email: email,
          username: username,
          bio: bio,
          photoURL: photoUrl,
          following: [],
          followers: [],
          posts: [],
        );
        await _firebaseFirestore
            .collection('Users')
            .doc(uid)
            .set(userModel.toJson());
      }
    } catch (e) {
      FirebaseAuthException;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<models.UserModel> getUserDetails() async {
    User user = _firebaseAuth.currentUser!;
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('Users').doc(user.uid).get();

    return models.UserModel.fromSnap(snapshot);
  }
}
