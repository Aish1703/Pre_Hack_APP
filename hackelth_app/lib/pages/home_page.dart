// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:hackelth_app/model/message_model.dart';
import 'package:hackelth_app/pages/chat_page.dart';
import 'package:hackelth_app/pages/front_page.dart';
import 'package:hackelth_app/pages/heart_rate_page.dart';
import 'package:hackelth_app/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  int index = 0;

  List<Widget> pages = [
    FrontPage(),
    HeartRatePage(),
    ChatPage(model: MessageModel(text: "Hello what's your name?"))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      backgroundColor: Colors.white.withOpacity(0.95),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: GEHackTheme.geStyle(size: 12, weight: FontWeight.bold, color: GEHackTheme.redColor),
        elevation: 3.0,
        unselectedItemColor: GEHackTheme.shadowColor,
        selectedItemColor: GEHackTheme.redColor,
        backgroundColor: Colors.white,
        currentIndex: index,
        onTap: ((value) => setState(() {
              index = value;
            })),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.monitor_heart,
                size: 30,
              ),
              label: "BPM"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.support_agent,
                size: 30,
              ),
              label: "Chat Bot"),
        ],
      ),
      body: pages[index],
    );
  }
}
