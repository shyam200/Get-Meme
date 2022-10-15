import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_meme/data_layer/models/wishlist_model/wishlist_items_model.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../business_layer/bloc/meme_generator_bloc/meme_generator_bloc.dart';
import '../../business_layer/bloc/meme_generator_bloc/meme_generator_event.dart';
import '../../business_layer/bloc/meme_generator_bloc/meme_generator_state.dart';
import '../../core/external/meme_common_dialog.dart';
import '../../resources/styles/text_styles.dart';

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
  final headerImageKey = GlobalKey();
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
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      textFieldHeight = _textFieldKey.currentContext?.size?.height;
      widget.bloc.add(FetchDbDataListEvent());
    });
    headlineOffset = Offset(dx, dy);
    descriptionOffset = Offset(dx + 10, dy + 10);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MemeGeneratorBloc, MemeGeneratorState>(
      bloc: widget.bloc, //_bloc,
      listener: (context, state) async {
        if (state is DbDataReceivedState) {
          await _isMemeAlreadyAdded(state.itemsList);
        } else if (state is PermissionTemporarilyDenied) {
          //Show the response to user with dialog that image is saved successfully!
        } else if (state is PermissionPermanentlyDenied ||
            state is PermissionTemporarilyDenied) {
          //let the user know that he has denied the permission and he/she needs to give the aceess
          _showPermissionAccessDialog();
        } else if (state is PermissionGrantedState) {
          final _clippedImage = await _takeHeaderImageScreenShot();
          //save the image to gallery
          widget.bloc.add(PermissionGrantedEvent(image: _clippedImage));
        } else if (state is MemeGeneratorImageSavedSucessState) {
          _showSuccessDialog('Saved Successfully!');
        } else if (state is TechnicalErrorState) {
          _showTechnicalErrorDialog();
        } else if (state is WishlistItemRemovedState) {
          _showSuccessDialog('Item Removed Successfully');
        } else if (state is ItemAddedToWishlistState) {
          _showSuccessDialog('Item Added Successfully!');
        }
      },
      // height: MediaQuery.of(context).size.height -
      //     2 * (textFieldHeight as num) -
      //     20,
      builder: (context, state) {
        print('detailKey ${widget.key}');
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create meme'),
            actions: [
              IconButton(
                  onPressed: _addToFavourite,
                  icon: Icon(
                      !_isFavourite ? Icons.favorite_border : Icons.favorite)),
              IconButton(onPressed: _onMemeSave, icon: const Icon(Icons.save)),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
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
              state is MemeGeneratorLoadingState
                  ? Container(
                      color: Colors.white70,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : Container()
            ],
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

  _buildHeaderImage() => RepaintBoundary(
        key: headerImageKey,
        child: SizedBox(
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
            )),
      );

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

  ///Method to take screenShot of the image from till the boundary
  Future<ui.Image> _takeHeaderImageScreenShot() async {
    RenderRepaintBoundary boundary = headerImageKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary;
    ui.Image headerImage = await boundary.toImage();
    return headerImage;
  }

  ///show [permission] access error dialog
  _showPermissionAccessDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return MemeDialog(
            title: 'Error',
            content: Column(
              children: [
                Platform.isAndroid
                    ? const Text(
                        'Please allow storage permission from settings',
                        style: TextStyles.memeDialogText,
                      )
                    : const Text(
                        'Please allow photos permission from settings',
                        style: TextStyles.memeDialogText,
                      ),
              ],
            ),
            positiveButtonContent: 'Ok',
            positiveFuntion: () {
              openAppSettings();
            },
          );
        });
  }

  ///show meme saved [confirmation] dialog
  _showSuccessDialog(String text) {
    showDialog(
      context: context,
      builder: (_) {
        return MemeDialog(
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              style: TextStyles.memeDialogText,
            ),
          ),
          negativeButtonContent: 'Ok',
        );
      },
    );
  }

  ///show [technical error] dialog
  _showTechnicalErrorDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return const MemeDialog(
            content: Text(
              'A technical error has occured please try again later.',
              style: TextStyles.memeDialogText,
            ),
            title: 'Technical Error',
            negativeButtonContent: 'Ok',
          );
        });
  }

  ///show instruction note dialog to let user know about how to use
  _showInstructionGuideDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return const MemeDialog(
            title: 'Wanna know how to use?',
            content: Text(
                '\u2022 Enter some text on either label 1 or 2 or\n  both.\n\u2022 Drag and drop text on the image.',
                style: TextStyles.memeDialogSmallText,
                textAlign: TextAlign.left),
            // Text('\n \u2022 Drag and drop text on the image')
          );
        });
  }

//Method to add image to favourite
  _addToFavourite() async {
    if (!_isFavourite) {
//setting icon
      setState(() {
        _isFavourite = !_isFavourite;
      });
      //adding to favourite
      widget.bloc.add(AddImageToFavouriteEvent(
          image: await _takeHeaderImageScreenShot(),
          key: widget.key.toString()));
    } else {
      //Removing from bloc
      setState(() {
        _isFavourite = false;
      });
      widget.bloc.add(RemoveFavouriteMemeEvent(key: widget.key.toString()));
    }
  }

  //To check if item is already present in wishlist
  Future? _isMemeAlreadyAdded(List<WishlistItemModel> items) {
    for (var element in items) {
      if (element.key == widget.key.toString()) {
        _isFavourite = true;
      }
    }
    return null;
  }
}
