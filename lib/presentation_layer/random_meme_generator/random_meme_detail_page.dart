import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_layer/bloc/random_meme_bloc/random_meme_bloc.dart';
import '../../business_layer/bloc/random_meme_bloc/random_meme_event.dart';
import '../../business_layer/bloc/random_meme_bloc/random_meme_state.dart';
import '../../core/external/meme_common_dialog.dart';
import '../../data_layer/models/random_meme_generator_model/random_meme_items_model.dart';
import '../../data_layer/models/wishlist_model/wishlist_items_model.dart';
import '../../injection/injection_container.dart';
import '../../resources/string_keys.dart';
import '../../resources/styles/text_styles.dart';

class RandomMemeDetailPage extends StatefulWidget {
  final RandomMemeItemModel randomMemeItemModel;
  const RandomMemeDetailPage({required this.randomMemeItemModel, Key? key})
      : super(key: key);

  @override
  State<RandomMemeDetailPage> createState() => _RandomMemeDetailPageState();
}

class _RandomMemeDetailPageState extends State<RandomMemeDetailPage>
    with MemeCommonDialog {
  late RandomMemeBloc _bloc;
  GlobalKey headerImageKey = GlobalKey();
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    _bloc = di<RandomMemeBloc>();

    _bloc.add(FetchDbDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RandomMemeBloc, RandomMemeState>(
      bloc: _bloc,
      listener: (context, state) async {
        if (state is DbDataReceivedState) {
          await _isAlreadyAddedToFav(state.wishlistItems);
        } else if (state is WishlistItemRemovedState) {
          _isFavourite = false;
          showSuccessDialog(
              text: StringKeys.removedConfirmationText, context: context);
        } else if (state is ItemAddedToWishlistState) {
          _isFavourite = true;
          showSuccessDialog(
              text: StringKeys.memeAddedConfirmationText, context: context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text(
                StringKeys.randomMemeDetailPageTitle,
                style: TextStyles.appTitleText,
              )),
          body: state is RandomMemeLoadingState
              ? const CircularProgressIndicator(
                  color: Colors.cyan,
                )
              : Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: _buildBody(),
                ),
        );
      },
    );
  }

  _buildBody() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _buildHeaderImage(),
      const Spacer(),
      ..._buildButtons(),
    ]);
  }

  _buildHeaderImage() => SingleChildScrollView(
          child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: const Color.fromARGB(255, 0, 79, 118))),
        child: RepaintBoundary(
            key: headerImageKey,
            child: SizedBox(
                height: 400,
                child: Image.network(widget.randomMemeItemModel.imageUrl))),
      ));

  _buildButtons() => [
        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 10),
          // padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: TextButton(
            onPressed: _onAddToFavouriteButtonPressed,
            child: Icon(
              _isFavourite ? Icons.favorite : Icons.favorite_outline_outlined,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          height: 50,
          margin: const EdgeInsets.only(top: 5, bottom: 20),
          // padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: TextButton(
            onPressed: _onShareButtonPressed,
            child: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
        )
      ];

  _onShareButtonPressed() {
    _bloc
        .add(ShareRandomMemeEvent(imgUrl: widget.randomMemeItemModel.imageUrl));
  }

  _onAddToFavouriteButtonPressed() async {
    if (_isFavourite) {
      //if already a favourite then remove
      _bloc.add(RemoveItemFromWishlistEvent(widget.randomMemeItemModel.id));
    } else {
      //add item
      _bloc.add(AddToWishlistMemeEvent(
          id: widget.randomMemeItemModel.id, image: await _takeScreenShot()));
    }
  }

  ///Method to [take screenShot] of the header Image
  Future<ui.Image> _takeScreenShot() async {
    final RenderRepaintBoundary image = headerImageKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary;

    final ui.Image headerImage = await image.toImage();
    return headerImage;
  }

  //Check if item is already added to favourite list
  Future? _isAlreadyAddedToFav(List<WishlistItemModel> wishlistItem) {
    for (var item in wishlistItem) {
      if (item.key == widget.randomMemeItemModel.id) {
        _isFavourite = true;
        break;
      }
    }
    return null;
  }
}
