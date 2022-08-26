// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:hackelth_app/model/message_model.dart';
import 'package:hackelth_app/pages/chat_page.dart';
import 'package:hackelth_app/utils/constants.dart';
import 'package:hackelth_app/widgets/message_blob.dart';

class FrontPage extends StatefulWidget {
  FrontPage({Key? key}) : super(key: key);

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  List<MessageModel> models = [
    MessageModel(text: "I have Cough"),
    MessageModel(text: "I have Skin disease"),
    MessageModel(text: "I'm feeling anxious"),
    MessageModel(text: "I'm so lonely"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      resizeToAvoidBottomInset: true,
      extendBody: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 80, left: 40, right: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Emergency help\nneeded?",
                textAlign: TextAlign.center,
                style: GEHackTheme.geStyle(
                    size: 30, weight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Just hold the button to call",
                style: GEHackTheme.geStyle(
                    size: 15, weight: FontWeight.w600, color: Colors.grey),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                height: MediaQuery.of(context).size.width * 0.6,
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: GEHackTheme.shadowColor.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0.6, 4),
                          spreadRadius: 2,
                          blurRadius: 8),
                      BoxShadow(
                          color: Colors.white.withOpacity(0.4),
                          offset: const Offset(-3, -4),
                          spreadRadius: -20,
                          blurRadius: 30),
                    ],
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.6 / 2,
                    )),
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        elevation: 40,
                        padding: EdgeInsets.zero,
                        backgroundColor: GEHackTheme.redColor,
                        shape: const CircleBorder()),
                    child: Icon(
                      Icons.call,
                      size: MediaQuery.of(context).size.width * 0.15,
                    )),
              ),
              const SizedBox(
                height: 35,
              ),
              Text(
                "Not sure what to do?",
                style: GEHackTheme.geStyle(
                    size: 20, weight: FontWeight.w600, color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Pick the subject to chat",
                style: GEHackTheme.geStyle(
                    size: 13, weight: FontWeight.w600, color: Colors.grey),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: models.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return ChatPage(
                                model: models[index],
                              );
                            }));
                          },
                          child: MessageBlob(model: models[index]));
                    })),
              )
            ],
          ),
        ),
      ),
    );
  }
}
