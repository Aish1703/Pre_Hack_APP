// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable, depend_on_referenced_packages, unused_field, prefer_final_fields, unused_element, avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:hackelth_app/model/message_model.dart';
import 'package:hackelth_app/service/api.dart';
import 'package:hackelth_app/service/storage_service.dart';
import 'package:hackelth_app/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.model}) : super(key: key);
  MessageModel model;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final _botUser = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d2f32c');
  SolutionService service = SolutionService();
  var _state = false;
  Storare storare = Storare();

  @override
  void initState() {
    getReply(widget.model.text);
    super.initState();
  }

  getReply(String text) {
    service.getMessages(text).then((value) {
      _state = value.query == '1';
      setState(() {
        final text = types.TextMessage(
          author: _botUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: randomString(),
          text: value.text,
        );
        _addMessage(text);
      });
    });
  }

  getPrediction(String url) {
    service.getSkinDisease(url).then((value) {
      setState(() {
        final text = types.TextMessage(
          author: _botUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: randomString(),
          text:
              "You have symptoms of ${value.disease}.\nNote: Users should not completely rely on information provided. Please contant your physician or other healthcare provider.",
        );
        _addMessage(text);
      });
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );
    _addMessage(textMessage);
    var list = ['yes', 'yeah', 'sure', 'ok', 'alright', 'ha', 'fine'];
    bool check = false;
    for (String s in list) {
      if (s == message.text.toLowerCase()) {
        check = true;
        break;
      }
    }
    if (_state && check) {
      String url = await _handleImageSelection();
      print(url);
      getPrediction(url);
      _state = false;
    } else {
      getReply(message.text);
    }
  }

  Future<String> _handleImageSelection() async {
    var option = ImageSource.gallery;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select image source'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                option = ImageSource.camera;
                Navigator.pop(context);
              },
              child: const Text('Camera'),
            ),
            ElevatedButton(
              onPressed: () {
                option = ImageSource.gallery;
                Navigator.pop(context);
              },
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: option,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: randomString(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }

    String downloadURL = "";
    final destination = "${DateTime.now().hashCode}";

    await FirebaseStorage.instance.ref(destination).putFile(File(result!.path));
    downloadURL =
        await FirebaseStorage.instance.ref(destination).getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        return await true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: GEHackTheme.redColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "Chatbot",
            style: GEHackTheme.geStyle(
                size: 30, weight: FontWeight.w600, color: Colors.black),
          ),
        ),
        body: Chat(
          theme: const DefaultChatTheme(
            attachmentButtonIcon: Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
          ),
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
          onAttachmentPressed: _handleImageSelection,
          showUserAvatars: true,
          avatarBuilder: (userId) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                height: 40,
                child: Image.network(
                    "https://texapi.net/wp-content/uploads/2022/05/icon.png"),
              ),
            );
          },
        ),
      ),
    );
  }
}
