import 'package:flutter/material.dart';

class MemeGeneratorPage extends StatefulWidget {
  const MemeGeneratorPage({Key? key}) : super(key: key);

  @override
  State<MemeGeneratorPage> createState() => _MemeGeneratorPageState();
}

class _MemeGeneratorPageState extends State<MemeGeneratorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(children: [
            const Text('Enjoy Creating meme!!'),

            //Image container
            const Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Placeholder()),
            ..._buildBottomTextFields()
          ]),
        ),
      ),
    );
  }

  _buildBottomTextFields() {
    return const [
      TextField(
        decoration: InputDecoration(
            label: Text('Headline'),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            ))),
      ),
      SizedBox(
        height: 10.0,
      ),
      TextField(
        decoration: InputDecoration(
            label: Text('Description'),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            ))),
      ),
    ];
  }
}
