import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/Constant/pallete.dart';
import 'package:instagram_clone_flutter/Services/auth_service.dart';
import 'package:instagram_clone_flutter/Services/post_service.dart';
import 'package:instagram_clone_flutter/Widgets/custom_elevated_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isfollwing = false;
  var userData = {};

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    try {
      // Fetching the post length
      final postSnap = await FirebaseFirestore.instance
          .collection('Posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      // Fetching the user data
      final userSnap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .get();

      if (userSnap.exists) {
        userData = userSnap.data()!;
        postLength = postSnap.docs.length;
        followers = userData['followers'].length;
        following = userData['following'].length;
        isfollwing = userData['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid);

        setState(() {});

        print('User data fetched successfully');
        print('isFollowing: $isfollwing');
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Failed to fetch user data: $e');
    }
  }

  followUser() async {
    try {
      await PostServiceImpl().followUser(
        uid: FirebaseAuth.instance.currentUser!.uid,
        targetUserId: userData['uid'],
      );
      setState(() {
        isfollwing = true;
        followers++;
      });

      print('User followed successfully');
    } catch (e) {
      print('Failed to follow user: $e');
    }
  }

  unfollowUser() async {
    try {
      await PostServiceImpl().unFollowUser(
        uid: FirebaseAuth.instance.currentUser!.uid,
        targetUserId: userData['uid'],
      );
      setState(() {
        isfollwing = false;
        followers--;
      });

      print('User unfollowed successfully');
    } catch (e) {
      print('Failed to unfollow user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userData['username'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Pallete.textColor,
          ),
        ),
        centerTitle: false,
        actions: [
          FirebaseAuth.instance.currentUser!.uid == widget.uid
              ? Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        size: 30,
                      ),
                      color: Pallete.textColor,
                      onPressed: () async {
                        await AuthServiceImpl().signOut();
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.menu,
                        size: 30,
                      ),
                      color: Pallete.textColor,
                      onPressed: () {},
                    ),
                  ],
                )
              : IconButton(
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                  ),
                  color: Pallete.textColor,
                  onPressed: () {},
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Pallete.textFieldFillColor,
                  backgroundImage: NetworkImage(
                    userData['photoUrl'],
                  ),
                  radius: 40,
                ),
                Column(
                  children: [
                    Text(
                      postLength.toString(),
                      style: const TextStyle(
                        color: Pallete.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'posts',
                      style: TextStyle(
                        color: Pallete.textColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      followers.toString(),
                      style: const TextStyle(
                        color: Pallete.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'followers',
                      style: TextStyle(
                        color: Pallete.textColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      following.toString(),
                      style: const TextStyle(
                        color: Pallete.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'following',
                      style: TextStyle(
                        color: Pallete.textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              userData['username'],
              style: const TextStyle(
                color: Pallete.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              userData['bio'],
              maxLines: 5,
              style: const TextStyle(
                color: Pallete.textColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FirebaseAuth.instance.currentUser!.uid == widget.uid
                ? Row(
                    children: [
                      SizedBox(
                        width: 185,
                        child: CustomElevatedButton(
                          text: 'Edit Profile',
                          onPressed: () {},
                          buttonColor: Pallete.textFieldFillColor,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 185,
                        child: CustomElevatedButton(
                          text: 'Share Profile',
                          onPressed: () {},
                          buttonColor: Pallete.textFieldFillColor,
                        ),
                      )
                    ],
                  )
                : isfollwing
                    ? Row(
                        children: [
                          SizedBox(
                            width: 185,
                            child: CustomElevatedButton(
                                text: 'Unfollow',
                                onPressed: () async {
                                  await unfollowUser();
                                },
                                buttonColor: Pallete.textFieldFillColor),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 185,
                            child: CustomElevatedButton(
                              text: 'Message',
                              onPressed: () {},
                              buttonColor: Pallete.textFieldFillColor,
                            ),
                          )
                        ],
                      )
                    : Row(
                        children: [
                          SizedBox(
                            width: 185,
                            child: CustomElevatedButton(
                                text: 'Follow',
                                onPressed: () async {
                                  await followUser();
                                },
                                buttonColor: Pallete.followButtonColor),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 185,
                            child: CustomElevatedButton(
                              text: 'Message',
                              onPressed: () {},
                              buttonColor: Pallete.textFieldFillColor,
                            ),
                          ),
                        ],
                      ),
            const Divider(),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Posts')
                  .where('uid', isEqualTo: widget.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                  color: Colors.black,
                  child: GridView.builder(
                    controller: ScrollController(),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                    itemBuilder: (_, index) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              snapshot.data!.docs[index]['postURL'],
                            ),
                            fit: BoxFit.cover),
                      ),
                    ),
                    itemCount: snapshot.data!.docs.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
