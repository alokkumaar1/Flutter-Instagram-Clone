import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/Constant/pallete.dart';
import 'package:instagram_clone_flutter/Models/user_models.dart';
import 'package:instagram_clone_flutter/Services/post_service.dart';
import 'package:instagram_clone_flutter/Utils/snackbar.dart';
import 'package:instagram_clone_flutter/Widgets/post_card.dart';
import 'package:instagram_clone_flutter/providers.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'Assets/Images/Instagram Logo (1).png',
          scale: 1.5,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_outline_rounded,
              color: Pallete.textColor,
              size: 25,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              color: Pallete.textColor,
              scale: 22,
              'Assets/Images/chat (2).png',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Posts').snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  print('There is an Error');
                  return showSnackBar(context, 'Please try again later!');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return ListView.separated(
                  itemBuilder: (context, index) {
                    final snap = snapshot.data!.docs[index];
                    final bool isLiked =
                        (snap['likes'] as List<dynamic>).contains(user.uid);
                    return PostCard(
                      username: snap['username'],
                      postDecription:
                          '${snap['username']} ${snap['postDescription']}',
                      photoURL: snap['photoURL'],
                      postURL: snap['postURL'],
                      likePost: () {
                        PostServiceImpl().likePost(
                          uid: user.uid,
                          postId: snap['postId'],
                          likes: snap['likes'],
                        );
                      },
                      likeCount:
                          '${(snap['likes'] as List<dynamic>).length.toString()} likes',
                      commentPostId: snap['postId'],
                      isLiked: isLiked,
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemCount: snapshot.data!.docs.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
