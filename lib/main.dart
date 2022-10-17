import 'dart:io';

import 'package:flutter/material.dart';

import 'http_override_ssl_certificate.dart';
import 'injection/injection_container.dart' as di;
import 'presentation_layer/intro_page.dart';
import 'resources/hive_db/hive_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await HiveInit.init();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meme',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF00afc1),
          secondary: const Color(0xFF0093AB),
        ),

        //setting light theme mode
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: IntroPage(
        function: () {
          setState(() {
            isDarkTheme = !isDarkTheme;
          });
        },
      ),
    );
  }
}
