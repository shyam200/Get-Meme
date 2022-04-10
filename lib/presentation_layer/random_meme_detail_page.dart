import 'package:flutter/material.dart';

class RandomMemeDetailPage extends StatefulWidget {
  final String title;
  final String imageUrl;
  const RandomMemeDetailPage(
      {required this.title, required this.imageUrl, Key? key})
      : super(key: key);

  @override
  State<RandomMemeDetailPage> createState() => _RandomMemeDetailPageState();
}

class _RandomMemeDetailPageState extends State<RandomMemeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Page')),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Image.network(widget.imageUrl),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Icon(
              Icons.favorite_outline_outlined,
              color: Colors.white,
            ),
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary),
          ),
          TextButton(
            onPressed: () {},
            child: const Icon(
              Icons.share,
              color: Colors.white,
            ),
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary),
          )
        ]),
      ),
    );
  }
}
