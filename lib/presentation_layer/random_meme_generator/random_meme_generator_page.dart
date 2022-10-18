import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_layer/bloc/random_meme_bloc/random_meme_bloc.dart';
import '../../business_layer/bloc/random_meme_bloc/random_meme_event.dart';
import '../../business_layer/bloc/random_meme_bloc/random_meme_state.dart';
import '../../data_layer/models/random_meme_generator_model/random_meme_items_model.dart';
import '../../injection/injection_container.dart';
import 'random_meme_detail_page.dart';

class RandomMemeGeneratorPage extends StatefulWidget {
  const RandomMemeGeneratorPage({Key? key}) : super(key: key);

  @override
  State<RandomMemeGeneratorPage> createState() =>
      _RandomMemeGeneratorPageState();
}

class _RandomMemeGeneratorPageState extends State<RandomMemeGeneratorPage> {
  late RandomMemeBloc _randomMemeBloc;
  List<RandomMemeItemModel> _memeItem = [];

  @override
  void initState() {
    super.initState();
    _randomMemeBloc = di<RandomMemeBloc>();
    _randomMemeBloc.add(GetRandomMemeListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RandomMemeBloc, RandomMemeState>(
      bloc: _randomMemeBloc,
      listener: (context, state) {
        if (state is RandomMemeListLoadedState) {
          _memeItem = state.memeDataItem.memeData.memeItemsList;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: state is RandomMemeLoadingState
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _memeItem.length,
                      itemBuilder: (context, index) {
                        return isValidImageUrl(_memeItem[index].imageUrl)
                            ? _buildImage(context, index)
                            : Container();
                      })),
        );
      },
    );
  }

  InkWell _buildImage(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => RandomMemeDetailPage(
                  randomMemeItemModel: _memeItem[index],
                )));
      },
      child: Container(
        height: 400,
        width: 400,
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Image.network(
          _memeItem[index].imageUrl,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  ///Method to return [valid ImageUrl]
  bool isValidImageUrl(String url) {
    return url.isNotEmpty && url.contains('jpg') ||
        url.contains('png') ||
        url.contains('gif');
  }
}
