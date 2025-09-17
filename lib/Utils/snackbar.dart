import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text) {
  if (!context.mounted) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
