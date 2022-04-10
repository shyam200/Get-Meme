import 'package:flutter/material.dart';
import 'package:get_meme/injection/injection_container.dart' as di;
import 'package:get_meme/presentation_layer/intro_page.dart';

void main() async {
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meme',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFF00afc1),
        secondary: const Color(0xFF0093AB),
      )
          // accentColor:
          ),
      home: const IntroPage(),
    );
  }
}
