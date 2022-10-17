import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      listener: (context, state) {
        if (state is WishlistLoadedState) {
          wishtlistItems = state.wishlistItems ?? [];
        } else if (state is WishlistItemRemovedSate) {
          //final itemToRmove;
          for (var item in wishtlistItems) {
            if (item.key == state.key) {
              wishtlistItems.remove(item);
              break;
            }
          }
          showSuccessDialog(text: 'Item remove successfully', context: context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Favourites'),
          ),
          body: Container(
              color: Colors.blueGrey[200],
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: state is MoreMenuLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.cyan,
                      ),
                    )
                  : wishtlistItems.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ListView.builder(
                              itemCount: wishtlistItems.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 400,
                                  width: 400,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Stack(
                                      fit: StackFit.passthrough,
                                      children: [
                                        Image.memory(
                                          wishtlistItems[index].memeSaveImage,
                                          fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                            bottom: 35,
                                            right: 30,
                                            // height: 40,
                                            child: InkWell(
                                              onTap: () {
                                                _bloc.add(
                                                    RemoveSaveItemFromWishlistEvent(
                                                        wishtlistItems[index]
                                                            .key));
                                              },
                                              child: const Icon(
                                                Icons.favorite_sharp,
                                                size: 50,
                                                color: Colors.white,
                                              ),
                                            ))
                                      ]),
                                );
                              }),
                        )
                      : Center(
                          child: Text(
                            'Not added any meme yet :)',
                            style: TextStyles.memeDialogHeadline
                                .copyWith(color: Colors.white),
                          ),
                        )),
        );
      },
    );
  }

  // _removeItemFromWishlist(String key) {

  // }
}
