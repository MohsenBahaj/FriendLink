import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker({super.key, required this.onPickedImage});
  void Function(File file) onPickedImage;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;
  void _pickedImage() async {
    final XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 150, imageQuality: 50);
    if (image == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(image.path);
      widget.onPickedImage(_pickedImageFile!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage:
              _pickedImageFile == null ? null : FileImage(_pickedImageFile!),
          radius: 40,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        ),
        SizedBox(
          height: 10,
        ),
        TextButton.icon(
          onPressed: () {
            _pickedImage();
          },
          label: Text('Add Image'),
          icon: Icon(Icons.image),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
