import 'package:flutter/material.dart';
import '../Constant/pallete.dart';

class CustomCommentTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final String profileURL;
  final String userName;
  const CustomCommentTextField(
      {super.key,
      required this.controller,
      required this.onSubmit,
      required this.profileURL,
      required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      height: 61,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Pallete.textFieldFillColor,
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: CircleAvatar(
                      backgroundColor: Pallete.textFieldFillColor,
                      backgroundImage: NetworkImage(profileURL),
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        color: Pallete.textColor,
                      ),
                      controller: controller,
                      autocorrect: false,
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: "Comment as $userName",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
                color: Pallete.buttonColor, shape: BoxShape.circle),
            child: InkWell(
              onTap: onSubmit,
              child: const Icon(
                Icons.send,
                color: Pallete.textColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
