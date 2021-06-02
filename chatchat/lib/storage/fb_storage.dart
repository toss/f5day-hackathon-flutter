// ignore: avoid_web_libraries_in_flutter
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class UploadFileTaskManager extends StatefulWidget {
  @override
  _UploadFileTaskManager createState() {
    return _UploadFileTaskManager("flutter_sound_example.aac");
  }
}

class _UploadFileTaskManager extends State<UploadFileTaskManager> {
  List<firebase_storage.UploadTask> _uploadTasks = [];

  Future<firebase_storage.UploadTask> uploadFile(File file) async {
    Log.d("file.path ${file.path}");
    if (file == null) {
      return null;
    }

    final ref = firebase_storage.FirebaseStorage.instanceFor()
        .ref()
        .child("playground")
        .child("/record1");

    final metadata = firebase_storage.SettableMetadata(contentType: 'audio/*');
    firebase_storage.UploadTask uploadTask = ref.putFile(file, metadata);

    return Future.value(uploadTask);
  }

  final String _uri;

  _UploadFileTaskManager(this._uri);

  @override
  Widget build(BuildContext context) {
    _upload(_uri);
    return Scaffold(
      body: Text("Task Upload"),
    );
  }

  Future<void> _upload(String uri) async {
    final file = File.fromUri(Uri.file(uri));

    await uploadFile(file);
  }
}
