// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class SelectImage extends StatefulWidget {
  Function onImageSelected;
  String initialImageUrl;
  SelectImage(this.onImageSelected, this.initialImageUrl);
  @override
  State<SelectImage> createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  File? image;

  Future<void> _pickImage() async {
    var picker = ImagePicker();
    XFile? recipeImage = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 50,
      maxWidth: 150,
      maxHeight: 150,
    );
    setState(() {
      image = File(recipeImage!.path);
    });

    widget.onImageSelected(image);
  }

  @override
  Widget build(BuildContext context) {
    var initialImage = Image.network(
      widget.initialImageUrl,
      fit: BoxFit.cover,
      height: 90,
      width: 210,
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(130, 50),
                  ),
                ),
            onPressed: _pickImage,
            label: const Text('Pick an image'),
            icon: const Icon(Icons.camera),
          ),
          const SizedBox(
            width: 5,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.purple,
                width: 3,
              ),
            ),
            height: 90,
            width: 200,
            child: image == null && widget.initialImageUrl != ''
                ? initialImage
                : Center(
                    child: image == null
                        ? const Text(
                            'No image yet',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
                        : Image.file(
                            image!,
                            fit: BoxFit.cover,
                            height: 90,
                            width: 210,
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
