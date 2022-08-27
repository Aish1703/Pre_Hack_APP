// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:hackelth_app/utils/constants.dart';

class ChatVoicePage extends StatefulWidget {
  ChatVoicePage({Key? key}) : super(key: key);

  @override
  State<ChatVoicePage> createState() => _ChatVoicePageState();
}

class _ChatVoicePageState extends State<ChatVoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            width: double.infinity,
            height: 50,
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: "Type Something...",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: GEHackTheme.shadowColor),
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            )),
      ),
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
      body: Container(),
    );
  }
}
