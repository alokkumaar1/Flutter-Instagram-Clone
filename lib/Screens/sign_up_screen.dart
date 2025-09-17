import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/Constant/pallete.dart';
import 'package:instagram_clone_flutter/Screens/login_screen.dart';
import 'package:instagram_clone_flutter/Services/auth_service.dart';
import 'package:instagram_clone_flutter/Utils/image_picker.dart';
import 'package:instagram_clone_flutter/Widgets/custom_elevated_button.dart';
import 'package:instagram_clone_flutter/Widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? _pickedProfileImage;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void registerUser() async {
    await AuthServiceImpl().signUpWithEmailAndPassword(
      email: emailController.text.trim(),
      username: usernameController.text.trim(),
      photoURL: _pickedProfileImage!,
      password: passwordController.text.trim(),
      bio: bioController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Image.asset(
          'Assets/Images/Instagram Logo (1).png',
          scale: 2,
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          _pickedProfileImage == null
              ? CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 70,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 70,
                        backgroundImage:
                            AssetImage('Assets/Images/default Profile pic.png'),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            splashColor: Colors.white.withOpacity(0.3),
                            onTap: () async {
                              final image =
                                  await PhotoPicker().pickProfilePicture();
                              if (image != null) {
                                setState(() {
                                  _pickedProfileImage = File(image.path);
                                });
                              }
                            },
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.grey.withOpacity(0.5),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                child: Container(
                                  color: Colors.grey.withOpacity(0.5),
                                  child: const Icon(
                                    CupertinoIcons.camera,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 70,
                  backgroundImage: FileImage(_pickedProfileImage!),
                ),
          const SizedBox(
            height: 40,
          ),
          CustomTextField(
            controller: emailController,
            hintText: 'Enter Username or Email',
            obscureText: false,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextField(
            controller: passwordController,
            hintText: 'Password',
            obscureText: true,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextField(
            controller: usernameController,
            hintText: 'Enter your Username',
            obscureText: false,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextField(
            controller: bioController,
            hintText: 'Enter the Bio',
            obscureText: false,
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 50,
            width: 370,
            child: CustomElevatedButton(
              text: 'Sign Up',
              onPressed: registerUser,
              buttonColor: Pallete.buttonColor,
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account?',
                style: TextStyle(
                  color: Colors.grey,
                  // fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    color: Pallete.buttonColor,
                    // fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
