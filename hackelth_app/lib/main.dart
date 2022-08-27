// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:hackelth_app/pages/home_page.dart';
import 'package:hackelth_app/pages/map_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage() 
    );
  }
}

