// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable, depend_on_referenced_packages, unused_field, prefer_final_fields, unused_element, avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:hackelth_app/model/message_model.dart';
import 'package:hackelth_app/service/api.dart';
import 'package:hackelth_app/utils/constants.dart';
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

  @override
  void initState() {
    getReply(widget.model.text);
    super.initState();
  }

  getReply(String text) {
    service.getMessages(text).then((value) {
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

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );
    _addMessage(textMessage);
    getReply(message.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        theme: const DefaultChatTheme(),
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }
}
