import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data_layer/models/share_image_model.dart';
import '../../../data_layer/repositories/random_meme_repository.dart';
import 'random_meme_event.dart';
import 'random_meme_state.dart';

class RandomMemeBloc extends Bloc<RandomMemeEvent, RandomMemeState> {
  final RandomMememRepository randomMememRepository;
  final String _shareImageName = "memeImage.png";

  RandomMemeBloc({required this.randomMememRepository})
      : super(RandomMemeLoadingState());

  @override
  Stream<RandomMemeState> mapEventToState(RandomMemeEvent event) async* {
    if (event is RandomMemeLoadingEvent) {
      yield RandomMemeLoadingState();
    } else if (event is GetRandomMemeListEvent) {
      yield* getRandomMemeList();
    } else if (event is ShareRandomMemeEvent) {
      saveAndShareMeme(event.imgUrl);
    } else if (event is AddToFavouriteMemeEvent) {
      addToFavouriteMeme();
    }
  }

  Stream<RandomMemeState> getRandomMemeList() async* {
    yield RandomMemeLoadingState();
    try {
      final result = await randomMememRepository.getRandomMemeList();
      yield RandomMemeListLoadedState(memeDataItem: result);
    } catch (e) {
      log('error fetching data:- $e');
    }
  }

//To share image
//Steps that needs to perform:-
//call api to get the image through image url
//save image to temp storage in bytes
//then pass the file path of created temp storage in shareFIle
  saveAndShareMeme(String imageUrl) async {
    final ShareImageModel result =
        await randomMememRepository.getMemeImage(imageUrl);
    File file = await saveTemporaryImage(result.shareImage);

    await Share.shareFiles([file.path]);
  }

  Future<File> saveTemporaryImage(result) async {
    var dir = await getTemporaryDirectory();
    var targetPath = dir.absolute.path + "/$_shareImageName";
    var myImageFile = _createFile(targetPath);
    return myImageFile.writeAsBytes(result);
  }

  File _createFile(String path) {
    final file = File(path);
    file.createSync();
    return file;
  }

  addToFavouriteMeme() {
    log('Adding to favourite..........');
    // print('Adding to favourite..........');
  }
}
