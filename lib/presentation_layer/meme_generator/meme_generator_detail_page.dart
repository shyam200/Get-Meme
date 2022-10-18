import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_meme/resources/string_keys.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../business_layer/bloc/meme_generator_bloc/meme_generator_bloc.dart';
import '../../business_layer/bloc/meme_generator_bloc/meme_generator_event.dart';
import '../../business_layer/bloc/meme_generator_bloc/meme_generator_state.dart';
import '../../core/external/meme_common_dialog.dart';
import '../../data_layer/models/wishlist_model/wishlist_items_model.dart';
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

class _MemeGeneratorDetailPageState extends State<MemeGeneratorDetailPage>
    with MemeCommonDialog {
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
          showSuccessDialog(
              text: StringKeys.savedConfirmationText, context: context);
        } else if (state is TechnicalErrorState) {
          _showTechnicalErrorDialog();
        } else if (state is WishlistItemRemovedState) {
          showSuccessDialog(
              text: StringKeys.removedConfirmationText, context: context);
        } else if (state is ItemAddedToWishlistState) {
          showSuccessDialog(
              text: StringKeys.memeAddedConfirmationText, context: context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              StringKeys.memeGeneratorDetailPageTitle,
              style: TextStyles.appTitleText,
            ),
            actions: [
              IconButton(
                  onPressed: _addToFavourite,
                  icon: Icon(
                      !_isFavourite ? Icons.favorite_border : Icons.favorite)),
              IconButton(
                  onPressed: () {
                    _showInstructionGuideDialog();
                  },
                  icon: const Icon(Icons.info_outline)),
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

                        _buildColorChangeRow(),
                        const SizedBox(height: 20),
                        Material(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                          elevation: 10,
                          child: SizedBox(
                            height: 40,
                            child: InkWell(
                                // splashColor: Colors.white,
                                onTap: _onMemeSave,
                                child: const Icon(
                                  Icons.save,
                                  color: Colors.white,
                                )),
                          ),
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

  Row _buildColorChangeRow() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Text(StringKeys.colorChangeText),
        ),
        const Spacer(),
        _buildColorToggle(),
      ],
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
              onWillAccept: (data) =>
                  data == StringKeys.label1 || data == StringKeys.label2,
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
            child: SizedBox(
              width: 365,
              child: Text(
                _isTextDropped
                    ? _textFieldOneController.text.isNotEmpty
                        ? _textFieldOneController.text
                        : ''
                    : '',
                softWrap: true,
                maxLines: 3,
                style: GoogleFonts.unna(
                  color: _isBlackColor ? Colors.black : Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  // overflow: TextOverflow.ellipsis,
                ).copyWith(overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildLabelTwo() {
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
        child: SizedBox(
          width: 365,
          child: Text(
            _textFieldTwoController.text,
            style: GoogleFonts.unna(
              color: _isBlackColor ? Colors.black : Colors.white,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              // fontFamily: 'Pacifico'
            ),
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
                label: Text(StringKeys.label1),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ))),
          ),
          data: StringKeys.label1,
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
                label: Text(StringKeys.label2),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ))),
          ),
          data: StringKeys.label2,
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
            title: StringKeys.error,
            content: Column(
              children: [
                Platform.isAndroid
                    ? const Text(
                        StringKeys.storagePermissionText,
                        style: TextStyles.memeDialogText,
                      )
                    : const Text(
                        StringKeys.photosPermissionText,
                        style: TextStyles.memeDialogText,
                      ),
              ],
            ),
            positiveButtonContent: StringKeys.ok,
            positiveFuntion: () {
              openAppSettings();
            },
          );
        });
  }

  ///show [technical error] dialog
  _showTechnicalErrorDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return const MemeDialog(
            content: Text(
              StringKeys.technicalErrorText,
              style: TextStyles.memeDialogText,
            ),
            title: StringKeys.technicalError,
            negativeButtonContent: StringKeys.ok,
          );
        });
  }

  ///show instruction note dialog to let user know about how to use
  _showInstructionGuideDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return const MemeDialog(
            title: StringKeys.infoDialogTitle,
            content: Text(StringKeys.infoDialogText,
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
      widget.bloc.add(AddImageToWishlistEvent(
          image: await _takeHeaderImageScreenShot(),
          key: widget.key.toString()));
    } else {
      //Removing from bloc
      setState(() {
        _isFavourite = false;
      });
      widget.bloc.add(RemoveItemFromWishlistEvent(key: widget.key.toString()));
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
