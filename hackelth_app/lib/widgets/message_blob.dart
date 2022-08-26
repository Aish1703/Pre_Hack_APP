// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hackelth_app/model/message_model.dart';
import 'package:hackelth_app/utils/constants.dart';

class MessageBlob extends StatelessWidget {
  MessageBlob({Key? key, required this.model}) : super(key: key);

  MessageModel model;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.text,
              style: GEHackTheme.geStyle(
                  size: 15, weight: FontWeight.bold, color: Colors.black),
            ),
            const Icon(
              Icons.arrow_right_alt_rounded,
              color: GEHackTheme.redColor,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
