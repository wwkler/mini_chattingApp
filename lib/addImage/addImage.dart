import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  // 이미지 
  File? imageFile;

  // 하위 Widget에서 데이터를 가지고 상위 Widget으로...
  Function(File imageFile) sendImageFile;

  AddImage({
    required this.imageFile,
    required this.sendImageFile,
    Key? key,
  }) : super(key: key);

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  // 이미지를 가져오는 method
  void getImageSource() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? imageSource =
        await imagePicker.pickImage(source: ImageSource.camera);

    if (imageSource != null) {
      setState(() {
        widget.imageFile = File(imageSource.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // User Image
          CircleAvatar(
            radius: 40.0,
            backgroundColor: Colors.red[100],
            backgroundImage: widget.imageFile == null ? null : FileImage(widget.imageFile!),
            child: widget.imageFile == null
                ? Icon(
                    Icons.add,
                    color: Colors.white,
                  )
                : null,
          ),
          // Add Image
          TextButton.icon(
            onPressed: () {
              // async method
              getImageSource();
            },
            icon: Icon(Icons.add),
            label: Text('Add Image'),
          ),
          // Close Dialog
          TextButton.icon(
            onPressed: () {
              if (widget.imageFile != null) {
                widget.sendImageFile(widget.imageFile!);
              }
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
            label: Text('close'),
          ),
        ],
      ),
    );
  }
}
