import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_layer/bloc/meme_generator_bloc/meme_generator_bloc.dart';
import '../../business_layer/bloc/meme_generator_bloc/meme_generator_event.dart';
import '../../business_layer/bloc/meme_generator_bloc/meme_generator_state.dart';
import '../../data_layer/models/meme_generator_model/meme_generator_model.dart';
import '../../injection/injection_container.dart';
import 'meme_generator_detail_page.dart';

class MemeGeneratorPage extends StatefulWidget {
  const MemeGeneratorPage({Key? key}) : super(key: key);

  @override
  State<MemeGeneratorPage> createState() => _MemeGeneratorPageState();
}

class _MemeGeneratorPageState extends State<MemeGeneratorPage> {
  late MemeGeneratorBloc _bloc;
  List<MemeGeneratorModel> _imageList = [];

  @override
  void initState() {
    super.initState();
    _bloc = di<MemeGeneratorBloc>();
    _bloc.add(MemeGeneratorGetImageListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MemeGeneratorBloc, MemeGeneratorState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is MemeGeneratorListLoadedState) {
          _imageList = state.imageList.memeGeneratorImageList;
        }
      },
      builder: (context, state) {
        return state is MemeGeneratorLoadingState
            ? const Center(child: CircularProgressIndicator())
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView.builder(
                    itemCount: _imageList.length,
                    itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MemeGeneratorDetailPage(
                                            imgUrl: _imageList[index].imageUrl,
                                          )));
                            },
                            child: ExtendedImage.network(
                              _imageList[index].imageUrl,
                              fit: BoxFit.contain,
                              //  repeat: ImageRepeat.noRepeat,
                              key: Key(_imageList[index].id +
                                  UniqueKey().toString()),
                              // errorBuilder: (context, obj, stackTrace) {
                              //   print('$stackTrace');
                              //   return Text('$stackTrace');
                              // },
                            ),
                          ),
                        )),
              );
      },
    );
  }
}
