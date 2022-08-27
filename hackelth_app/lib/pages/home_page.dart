// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:hackelth_app/pages/front_page.dart';
import 'package:hackelth_app/utils/constants.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  int index = 0;

   List pages = [
    FrontPage(),
    Scaffold(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      bottomNavigationBar: BottomNavigationBar(
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
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: ""),
        ],
      ),
      body: pages[index],
    );
  }
}


