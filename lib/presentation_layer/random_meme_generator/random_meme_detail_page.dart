import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_layer/bloc/random_meme_bloc/random_meme_bloc.dart';
import '../../business_layer/bloc/random_meme_bloc/random_meme_event.dart';
import '../../business_layer/bloc/random_meme_bloc/random_meme_state.dart';
import '../../injection/injection_container.dart';

class RandomMemeDetailPage extends StatefulWidget {
  final String title;
  final String imageUrl;
  const RandomMemeDetailPage(
      {required this.title, required this.imageUrl, Key? key})
      : super(key: key);

  @override
  State<RandomMemeDetailPage> createState() => _RandomMemeDetailPageState();
}

class _RandomMemeDetailPageState extends State<RandomMemeDetailPage> {
  late RandomMemeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = di<RandomMemeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RandomMemeBloc, RandomMemeState>(
      bloc: _bloc,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Detail Page')),
          body: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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

  _buildHeaderImage() => Image.network(widget.imageUrl);

  _buildButtons() => [
        TextButton(
          onPressed: _onAddToFavouriteButtonPressed,
          child: const Icon(
            Icons.favorite_outline_outlined,
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
    _bloc.add(ShareRandomMemeEvent(imgUrl: widget.imageUrl));
  }

  _onAddToFavouriteButtonPressed() {
    _bloc.add(AddToFavouriteMemeEvent());
  }
}
