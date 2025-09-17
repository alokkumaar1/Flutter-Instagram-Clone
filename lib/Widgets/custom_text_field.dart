import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/Constant/pallete.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Pallete.textColor,
      style: const TextStyle(
        color: Pallete.textColor,
      ),
      obscureText: obscureText,
      autocorrect: false,
      autofocus: false,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(9),
          ),
          borderSide: BorderSide(
            color: Color(0XFF4D4D4D),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(
            color: Color(0XFF4D4D4D),
          ),
        ),
        filled: true,
        fillColor: Pallete.textFieldFillColor,
      ),
    );
  }
}
