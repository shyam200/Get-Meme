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
              text: 'Item Removed successfully', context: context);
        } else if (state is ItemAddedToWishlistState) {
          _isFavourite = true;
          showSuccessDialog(text: 'Item Added Successfully', context: context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Detail Page')),
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
      child: RepaintBoundary(
          key: headerImageKey,
          child: SizedBox(
              height: 600,
              child: Image.network(widget.randomMemeItemModel.imageUrl))));

  _buildButtons() => [
        TextButton(
          onPressed: _onAddToFavouriteButtonPressed,
          child: Icon(
            _isFavourite ? Icons.favorite : Icons.favorite_outline_outlined,
            color: Colors.white,
          ),
          style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary),
        ),
        TextButton(
          onPressed: _onShareButtonPressed,
          child: const Icon(
            Icons.share,
            color: Colors.white,
          ),
          style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary),
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
