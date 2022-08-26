import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class GEHackTheme {
  static const Color bgColor = Color.fromARGB(158, 239, 243, 248);
  static const Color redColor = Color(0xffF84242);
  static const Color shadowColor = Color(0xffAAABB7);
  static TextStyle geStyle(
      {required double size,
      required FontWeight weight,
      required Color color}) {
    return GoogleFonts.poppins(
        color: color, fontSize: size, fontWeight: weight);
  }
}
