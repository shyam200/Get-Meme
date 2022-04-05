import 'package:flutter/material.dart';
import 'package:get_meme/presentation_layer/random_meme_detail_page.dart';

class RandomMemeGeneratorPage extends StatefulWidget {
  const RandomMemeGeneratorPage({Key? key}) : super(key: key);

  @override
  State<RandomMemeGeneratorPage> createState() =>
      _RandomMemeGeneratorPageState();
}

class _RandomMemeGeneratorPageState extends State<RandomMemeGeneratorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
        ),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              return InkWell(
                child: Placeholder(),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const RandomMemeDetailPage()));
                },
              );
            }),
      ),
    );
  }
}
