import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_layer/bloc/meme_generator_bloc/meme_generator_bloc.dart';
import '../../business_layer/bloc/meme_generator_bloc/meme_generator_event.dart';
import '../../business_layer/bloc/meme_generator_bloc/meme_generator_state.dart';

class MemeGeneratorDetailPage extends StatefulWidget {
  final String imgUrl;
  final MemeGeneratorBloc bloc;
  const MemeGeneratorDetailPage(
      {Key? key, required this.imgUrl, required this.bloc})
      : super(key: key);

  @override
  State<MemeGeneratorDetailPage> createState() =>
      _MemeGeneratorDetailPageState();
}

class _MemeGeneratorDetailPageState extends State<MemeGeneratorDetailPage> {
  final _textFieldKey = GlobalKey();
  double? textFieldHeight = 0.0;
  bool _isTextDropped = false;
  final TextEditingController _textFieldOneController = TextEditingController();
  final TextEditingController _textFieldTwoController = TextEditingController();
  // final double _baseFactor = 0.5;
  // double _scaleFactor = 0.5;
  // final double _positionX = 30.0;
  double dx = 20.0;
  double dy = 20.0;
  final _bottomContainer = GlobalKey();
  late Offset headlineOffset; // = Offset.zero;
  late Offset descriptionOffset;
  bool _isBlackColor = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      textFieldHeight = _textFieldKey.currentContext?.size?.height;
    });

    headlineOffset = Offset(dx, dy);
    descriptionOffset = Offset(dx + 10, dy + 10);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MemeGeneratorBloc, MemeGeneratorState>(
      bloc: widget.bloc, //_bloc,
      listener: (context, state) {
        if (state is MemeGeneratorImageSavedSucessState) {
          //Show the response to user with dialog that image is saved successfully!
        }
      },
      // height: MediaQuery.of(context).size.height -
      //     2 * (textFieldHeight as num) -
      //     20,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create meme'),
            actions: [
              IconButton(onPressed: _onMemeSave, icon: Icon(Icons.save)),
            ],
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeaderImage(),
                    // const Spacer(),
                    const SizedBox(height: 30),
                    _buildBottomTextFields(),

                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text('Wanna change text color to black ?'),
                        ),
                        const Spacer(),
                        _buildColorToggle(),
                      ],
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }

  _buildColorToggle() {
    return Switch.adaptive(value: _isBlackColor, onChanged: _onColorChange);
  }

  _onColorChange(value) {
    setState(() {
      _isBlackColor = value;
    });
  }

  _buildHeaderImage() => SizedBox(
      height: 400,
      child: DragTarget(
        onWillAccept: (data) => data == 'Label 1' || data == 'Label 2',
        onAccept: (data) {
          setState(() {
            _isTextDropped = true;
          });
        },
        builder: (context, accepted, rejected) =>
            Stack(fit: StackFit.expand, children: [
          _buildImage(),
          _buildLabelTwo(),
          _buildLabelOne(),
        ]),
      ));

  Image _buildImage() {
    return Image.network(
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
    );
  }

  Positioned _buildLabelOne() {
    return Positioned(
      left: headlineOffset.dx,
      top: headlineOffset.dy,
      child: Column(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                headlineOffset = Offset(headlineOffset.dx + details.delta.dx,
                    headlineOffset.dy + details.delta.dy);
              });
            },
            // onScaleUpdate: (scaleOffset) {
            //   setState(() {
            //     headlineOffset = Offset(
            //         scaleOffset.focalPoint.dx, scaleOffset.focalPoint.dy);
            //     _scaleFactor = scaleOffset.scale;
            //   });
            //  },
            child: Text(
              _isTextDropped
                  ? _textFieldOneController.text.isNotEmpty
                      ? _textFieldOneController.text
                      : ''
                  : '',
              softWrap: true,
              style: TextStyle(
                color: _isBlackColor ? Colors.black : Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Positioned _buildLabelTwo() {
    return Positioned(
      left: descriptionOffset.dx,
      top: descriptionOffset.dy,
      child: GestureDetector(
        onPanUpdate: ((details) {
          setState(() {
            descriptionOffset = Offset(descriptionOffset.dx + details.delta.dx,
                descriptionOffset.dy + details.delta.dy);
          });
        }),
        child: Text(
          _textFieldTwoController.text,
          style: TextStyle(
            color: _isBlackColor ? Colors.black : Colors.white,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            // fontFamily: 'Pacifico'
          ),
        ),
      ),
    );
  }

  _buildBottomTextFields() {
    return Padding(
      key: _bottomContainer,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(children: [
        Draggable(
          child: TextField(
            key: _textFieldKey,
            controller: _textFieldOneController,
            decoration: const InputDecoration(
                label: Text('Label 1'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ))),
          ),
          data: 'Label 1',
          feedback: Text(
            _textFieldOneController.text,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          childWhenDragging: Container(),
        ),
        const SizedBox(
          height: 30.0,
        ),
        Draggable(
          child: TextField(
            controller: _textFieldTwoController,
            decoration: const InputDecoration(
                label: Text('Label 2'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ))),
          ),
          data: 'Label 2',
          feedback: Text(
            _textFieldTwoController.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ]),
    );
  }

  _onMemeSave() {
    widget.bloc.add(MemeGeneratorSaveImageEvent());
  }
}
