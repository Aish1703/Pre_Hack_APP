import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Storare {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, String fileName) async {
    var downloadURL = "";
    try {
      await storage.ref('Images/$fileName').putFile(file);
      print("1\n2\n3\nHelp");
      downloadURL = await storage.ref('Images/$fileName').getDownloadURL();
    } catch (e) {
      print(e);
    }
    return downloadURL;
  }
}
