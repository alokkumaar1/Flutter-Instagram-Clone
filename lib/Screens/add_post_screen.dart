import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/Constant/pallete.dart';
import 'package:instagram_clone_flutter/Models/user_models.dart';
import 'package:instagram_clone_flutter/Services/post_service.dart';
import 'package:instagram_clone_flutter/Utils/image_picker.dart';
import 'package:instagram_clone_flutter/Utils/snackbar.dart';
import 'package:instagram_clone_flutter/providers.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _postController = TextEditingController();
  File? _image;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  void uploadPost(String uid, String username, String photoURL) async {
    if (_postController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a post'),
        ),
      );
    }
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
        ),
      );
    }
    if (_postController.text.length > 140) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post is too long'),
        ),
      );
    }
    if (_postController.text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post is too short'),
        ),
      );
    }
    await PostServiceImpl().addPost(
      postDescription: _postController.text,
      postURL: _image!,
      likes: [],
      uid: uid,
      username: username,
      photoURL: photoURL,
    );
    showSnackBar(context, 'Posted successfully!');
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
        appBar: AppBar(
          actions: [
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Pallete.followButtonColor)),
              onPressed: () => uploadPost(
                user.uid,
                user.username,
                user.photoURL,
              ),
              child: const Text(
                'Post',
                style: TextStyle(
                  color: Pallete.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: _image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Pallete.textFieldFillColor,
                        backgroundImage: NetworkImage(user.photoURL),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        user.username,
                        style: const TextStyle(
                          color: Pallete.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    maxLines: 7,
                    autocorrect: false,
                    autofocus: false,
                    cursorColor: Pallete.textColor,
                    controller: _postController,
                    style: const TextStyle(
                      color: Pallete.textColor,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your Mind?',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.4,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          onTap: () async {
                            final img = await PhotoPicker().pickPostImage();
                            if (img != null) {
                              setState(() {
                                _image = img;
                              });
                            }
                          },
                          leading: const Icon(
                            Icons.photo,
                            color: Pallete.textColor,
                          ),
                          title: const Text(
                            'Photo',
                            style: TextStyle(color: Pallete.textColor),
                          ),
                        ),
                        const ListTile(
                          leading: Icon(
                            Icons.camera_alt_outlined,
                            color: Pallete.textColor,
                          ),
                          title: Text(
                            'Camera',
                            style: TextStyle(color: Pallete.textColor),
                          ),
                        ),
                        const ListTile(
                          leading: Icon(
                            Icons.video_call,
                            color: Pallete.textColor,
                          ),
                          title: Text(
                            'Live',
                            style: TextStyle(color: Pallete.textColor),
                          ),
                        ),
                        const ListTile(
                          leading: Icon(
                            Icons.people_outline_outlined,
                            color: Pallete.textColor,
                          ),
                          title: Text(
                            'Tag people',
                            style: TextStyle(color: Pallete.textColor),
                          ),
                        ),
                        const ListTile(
                          leading: Icon(
                            Icons.location_on_outlined,
                            color: Pallete.textColor,
                          ),
                          title: Text(
                            'Location',
                            style: TextStyle(color: Pallete.textColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Pallete.textFieldFillColor,
                          backgroundImage: NetworkImage(user.photoURL),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          user.username,
                          style: const TextStyle(
                            color: Pallete.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      maxLines: 7,
                      autocorrect: false,
                      autofocus: false,
                      cursorColor: Pallete.textColor,
                      controller: _postController,
                      style: const TextStyle(
                        color: Pallete.textColor,
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'What\'s on your Mind?',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.4,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    SizedBox(
                      height: 375,
                      child: Image(
                        fit: BoxFit.cover,
                        image: FileImage(
                          _image!,
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
