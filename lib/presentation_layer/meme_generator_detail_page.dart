import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../business_layer/bloc/meme_generator_bloc/meme_generator_bloc.dart';
import '../business_layer/bloc/meme_generator_bloc/meme_generator_state.dart';
import '../injection/injection_container.dart';

class MemeGeneratorDetailPage extends StatefulWidget {
  final String imgUrl;
  const MemeGeneratorDetailPage({Key? key, required this.imgUrl})
      : super(key: key);

  @override
  State<MemeGeneratorDetailPage> createState() =>
      _MemeGeneratorDetailPageState();
}

class _MemeGeneratorDetailPageState extends State<MemeGeneratorDetailPage> {
  late final MemeGeneratorBloc _bloc;
  final _textFieldKey = GlobalKey();
  double? textFieldHeight = 0.0;
  bool _isTextDropped = false;
  final TextEditingController _textFieldOneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = di<MemeGeneratorBloc>();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      textFieldHeight = _textFieldKey.currentContext?.size?.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MemeGeneratorBloc, MemeGeneratorState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is MemeGeneratorLoadingState) {
          print('loading');
        }
      },
      // height: MediaQuery.of(context).size.height -
      //     2 * (textFieldHeight as num) -
      //     20,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Create meme')),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(

                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeaderImage(),
                    // const Spacer(),
                    const SizedBox(height: 30),
                    _buildBottomTextFields(),
                  ]),
            ),
          ),
        );
      },
    );
  }

  _buildHeaderImage() => SizedBox(
      height: 400,
      child: DragTarget(
        onWillAccept: (data) => data == 'headline',
        onAccept: (data) {
          setState(() {
            _isTextDropped = true;
          });
        },
        builder: (context, accepted, rejected) => Stack(children: [
          Image.network(
            widget.imgUrl,
            fit: BoxFit.fill,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                  child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ));
            },
          ),
          Text(
            _isTextDropped
                ? _textFieldOneController.text.isNotEmpty
                    ? _textFieldOneController.text
                    : ''
                : '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          )
          // Text(_isTextDropped ? 'Dropped' : ''),
        ]),
      ));

  _buildBottomTextFields() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Draggable(
          child: TextField(
            key: _textFieldKey,
            controller: _textFieldOneController,
            decoration: const InputDecoration(
                label: Text('Headline'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ))),
          ),
          data: 'headline',
          feedback: const Text('Lets drop :)'),
          childWhenDragging: Container(),
        ),
        const SizedBox(
          height: 30.0,
        ),
        const TextField(
          decoration: InputDecoration(
              label: Text('Description'),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(10),
              ))),
        ),
      ]),
    );
  }
}
