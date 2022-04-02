import 'package:flutter/material.dart';

class RandomMemeGeneratorPage extends StatefulWidget {
  const RandomMemeGeneratorPage({Key? key}) : super(key: key);

  @override
  State<RandomMemeGeneratorPage> createState() =>
      _RandomMemeGeneratorPageState();
}

class _RandomMemeGeneratorPageState extends State<RandomMemeGeneratorPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is a random meme generator page!'),
    );
  }
}
