import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/Constant/pallete.dart';
import 'package:instagram_clone_flutter/Models/user_models.dart';
import 'package:instagram_clone_flutter/Services/post_service.dart';
import 'package:instagram_clone_flutter/Widgets/comment_field.dart';
import 'package:instagram_clone_flutter/providers.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comments',
          style: TextStyle(
            color: Pallete.textColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Pallete.textColor,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .doc(widget.postId)
            .collection('Comments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 60.0), // Space for the text field
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final comment = snapshot.data!.docs[index];
                    final bool isLiked =
                        (comment['likes'] as List<dynamic>).contains(user.uid);
                    return Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Pallete.textFieldFillColor,
                                backgroundImage:
                                    NetworkImage(comment['profilePicture']),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index]['username'],
                                      style: const TextStyle(
                                        color: Pallete.textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      comment['commentMessage'],
                                      maxLines: 5,
                                      style: const TextStyle(
                                        color: Pallete.textColor,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  PostServiceImpl().likeComment(
                                    uid: user.uid,
                                    commentId: comment['commentId'],
                                    postId: widget.postId,
                                    likes: snapshot.data!.docs[index]['likes'],
                                  );
                                },
                                icon: isLiked
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite_border,
                                        color: Colors.grey,
                                      ),
                              ),
                              Text(
                                '${(comment['likes'] as List<dynamic>).length.toString()} ',
                                style: const TextStyle(
                                  color: Pallete.textColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 20,
                  ),
                  itemCount: snapshot.data!.docs.length,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomCommentTextField(
                    onSubmit: () {
                      PostServiceImpl().postComment(
                        postId: widget.postId,
                        commentMessage: commentController.text,
                        uid: user.uid,
                        username: user.username,
                        likes: [],
                        profilePicture: user.photoURL,
                      );
                    },
                    controller: commentController,
                    profileURL: user.photoURL,
                    userName: user.username,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
