// ignore: avoid_web_libraries_in_flutter
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class UploadFileTaskManager extends StatefulWidget {
  final String _uploadUri;

  UploadFileTaskManager(this._uploadUri);

  @override
  _UploadFileTaskManager createState() {
    return _UploadFileTaskManager(_uploadUri);
  }
}

class _UploadFileTaskManager extends State<UploadFileTaskManager> {
  List<firebase_storage.UploadTask> _uploadTasks = [];

  Future<firebase_storage.UploadTask> uploadFile(File file) async {
    log("file.path ${file.path}");
    if (file == null) {
      return null;
    }
    final fileName = basename(file.path);

    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("playground/$fileName");

    final metadata = firebase_storage.SettableMetadata(contentType: 'audio/*');
    firebase_storage.UploadTask uploadTask = ref.putFile(file, metadata);

    return Future.value(uploadTask);
  }

  final String _uri;

  _UploadFileTaskManager(this._uri);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _upload(_uri);
    return Scaffold(
      body: Text("Task Upload $_uri"),
    );
  }

  Future<void> _upload(String uri) async {
    final file = File.fromUri(Uri.file(uri));

    await uploadFile(file);
  }
}
