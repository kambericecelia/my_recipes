import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<File?> showImagePickerDialog(BuildContext context) async {
    return showModalBottomSheet<File>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Photo library"),
                onTap: () async {
                  Navigator.of(context)
                      .pop(await _pickImage(ImageSource.gallery));
                },
              ),
              ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("Camera"),
                  onTap: () async {
                    Navigator.of(context)
                        .pop(await _pickImage(ImageSource.camera));
                  })
            ],
          ));
        });
  }

  static Future<File?> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
