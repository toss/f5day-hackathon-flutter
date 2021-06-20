import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final _imagePicker = ImagePicker();
  File _pickFile;

  Future _getImage() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      log("_pickFile != null ${pickedFile != null}");
      if (pickedFile != null) {
        _pickFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: TextButton(onPressed: () {}, child: Text("Next")),
      body: Container(
        child: Center(
          child: Column(
            children: [
              _previewWidget(context, _pickFile, () {
                _getImage();
              })
            ],
          ),
        ),
      ),
    );
  }
}

Widget _previewWidget(
    BuildContext context, File pickImage, GestureTapCallback tapCallback) {
  final size = MediaQuery.of(context).size.width / 3.0;

  Image preview;
  if (pickImage == null) {
    preview = Image.asset("images/icon_plus_mono.png");
  } else {
    preview = Image.file(pickImage, width: size, height: size);
  }

  return InkWell(
      onTap: tapCallback,
      child: Container(
        color: Color(0xfff2f4f5),
        width: size,
        height: size,
        child: preview,
      ));
}
