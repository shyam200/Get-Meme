import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_meme/resources/styles/text_styles.dart';

import '../../business_layer/bloc/more_menu_bloc/more_menu_bloc.dart';
import '../../business_layer/bloc/more_menu_bloc/more_menu_event.dart';
import '../../business_layer/bloc/more_menu_bloc/more_menu_state.dart';
import '../../data_layer/models/wishlist_model/wishlist_items_model.dart';
import '../../injection/injection_container.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
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
                      ? ListView.builder(
                          itemCount: wishtlistItems.length,
                          itemBuilder: (context, index) {
                            return Container(
                                height: 400,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Image.memory(
                                  wishtlistItems[index].memeSaveImage,
                                  fit: BoxFit.cover,
                                ));
                          })
                      : Center(
                          child: Text(
                            'Not added any item yet :)',
                            style: TextStyles.memeDialogHeadline
                                .copyWith(color: Colors.white),
                          ),
                        )),
        );
      },
    );
  }
}
