import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

dynamic pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  final XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
}

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
