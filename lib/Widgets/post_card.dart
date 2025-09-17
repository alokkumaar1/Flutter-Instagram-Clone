import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/Constant/pallete.dart';
import 'package:instagram_clone_flutter/Widgets/comment_screen.dart';
import 'package:readmore/readmore.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String postDecription;
  final String photoURL;
  final String postURL;
  final VoidCallback likePost;
  final String likeCount;
  final String commentPostId;
  final bool isLiked;

  const PostCard({
    super.key,
    required this.isLiked,
    required this.username,
    required this.postDecription,
    required this.photoURL,
    required this.postURL,
    required this.likePost,
    required this.likeCount,
    required this.commentPostId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 20, // Adjust the radius as needed
                backgroundImage: NetworkImage(
                  photoURL,
                ),
                backgroundColor: Pallete.textFieldFillColor,
              ),
              const SizedBox(width: 10),
              Text(
                username,
                style: const TextStyle(
                  color: Pallete.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              const IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Pallete.textColor,
                  ),
                  onPressed: null),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            color: Pallete.textFieldFillColor,
            height: 470,
            width: double.infinity,
            child: Image(
              fit: BoxFit.cover,
              image: NetworkImage(postURL),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              IconButton(
                onPressed: likePost,
                icon: isLiked
                    ? const Icon(
                        Icons.favorite_outlined,
                        color: Colors.red,
                        size: 30,
                      )
                    : const Icon(
                        Icons.favorite_border,
                        color: Pallete.textColor,
                        size: 30,
                      ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentScreen(
                          postId: commentPostId,
                        ),
                      ));
                },
                icon: Image.asset(
                  'Assets/Images/comment.png',
                  color: Pallete.textColor,
                  scale: 20,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  'Assets/Images/share.png',
                  color: Pallete.textColor,
                  scale: 20,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  'Assets/Images/bookmark.png',
                  color: Pallete.textColor,
                  scale: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            likeCount,
            style: const TextStyle(
              color: Pallete.textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          ReadMoreText(
            postDecription,
            trimMode: TrimMode.Line,
            trimLines: 2,
            colorClickableText: Colors.grey,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            annotations: [
              Annotation(
                regExp: RegExp(r'#([a-zA-Z0-9_]+)'),
                spanBuilder: ({required String text, TextStyle? textStyle}) =>
                    TextSpan(
                  text: text,
                  style: textStyle?.copyWith(color: Colors.blue),
                ),
              ),
            ],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Pallete.textColor,
            ),
            moreStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          const Text(
            'View all the Comments',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
