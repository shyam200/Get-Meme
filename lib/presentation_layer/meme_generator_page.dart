import 'package:flutter/material.dart';

class MemeGeneratorPage extends StatefulWidget {
  const MemeGeneratorPage({Key? key}) : super(key: key);

  @override
  State<MemeGeneratorPage> createState() => _MemeGeneratorPageState();
}

class _MemeGeneratorPageState extends State<MemeGeneratorPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is a meme generator page!'),
    );
  }
}
