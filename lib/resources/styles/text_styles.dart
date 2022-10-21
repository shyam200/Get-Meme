import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///Common class to provide text Style inside the app
abstract class TextStyles {
  static const appTitleText = TextStyle(
      fontFamily: 'RobotoSerif-Regular',
      fontSize: 20,
      fontWeight: FontWeight.bold);
  static const memeDialogText = TextStyle(fontSize: 18, color: Colors.black45);
  static const memeDialogHeadline = TextStyle(
      fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black54);
  static const memeDialogSmallText =
      TextStyle(fontSize: 16, color: Colors.black45);
  static const drawerText = TextStyle(fontSize: 16);
  static final drawerHeading = GoogleFonts.nunito(
      fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.bold);
}
