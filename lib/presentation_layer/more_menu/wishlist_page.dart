import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_meme/resources/string_keys.dart';

import '../../business_layer/bloc/more_menu_bloc/more_menu_bloc.dart';
import '../../business_layer/bloc/more_menu_bloc/more_menu_event.dart';
import '../../business_layer/bloc/more_menu_bloc/more_menu_state.dart';
import '../../core/external/meme_common_dialog.dart';
import '../../data_layer/models/wishlist_model/wishlist_items_model.dart';
import '../../injection/injection_container.dart';
import '../../resources/styles/text_styles.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> with MemeCommonDialog {
  late final MoreMenuBloc _bloc;
  List<WishlistItemModel> wishtlistItems = [];
  @override
  void initState() {
    super.initState();
    _bloc = di<MoreMenuBloc>();
    _bloc.add(GetWishlistItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MoreMenuBloc, MoreMenuState>(
      bloc: _bloc,
      listener: (context, state) async {
        if (state is WishlistLoadedState) {
          wishtlistItems = state.wishlistItems ?? [];
        } else if (state is WishlistItemRemovedSate) {
          for (var item in wishtlistItems) {
            if (item.key == state.key) {
              wishtlistItems.remove(item);
              break;
            }
          }
          showSuccessDialog(
              text: StringKeys.memeAddedConfirmationText, context: context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              StringKeys.wishlistPageTitle,
              style: TextStyles.appTitleText,
            ),
          ),
          body: Container(
              // color: Colors.blueGrey[200],
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: state is MoreMenuLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.cyan,
                      ),
                    )
                  : wishtlistItems.isNotEmpty
                      ? _buildMemeContainer()
                      : _buildNoMemeContainer()),
        );
      },
    );
  }

  Container _buildMemeContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
          itemCount: wishtlistItems.length,
          itemBuilder: (context, index) {
            return Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: const Color.fromARGB(255, 0, 79, 118))),
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Stack(fit: StackFit.passthrough, children: [
                _buildImage(index),
                _buildWishlistButton(index),
              ]),
            );
          }),
    );
  }

  Image _buildImage(int index) {
    return Image.memory(
      wishtlistItems[index].memeSaveImage,
      fit: BoxFit.cover,
    );
  }

  Positioned _buildWishlistButton(int index) {
    return Positioned(
        bottom: 35,
        right: 30,
        child: InkWell(
          onTap: () {
            _bloc.add(
                RemoveSaveItemFromWishlistEvent(wishtlistItems[index].key));
          },
          child: const Icon(
            Icons.favorite_sharp,
            size: 50,
            color: Colors.white,
          ),
        ));
  }

  Center _buildNoMemeContainer() {
    return Center(
      child: Text(
        'Not added any meme yet :)',
        style: TextStyles.memeDialogHeadline.copyWith(color: Colors.white),
      ),
    );
  }
}
