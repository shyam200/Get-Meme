import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/hive/hive_local_data_source.dart';
import '../../../data_layer/models/share_image_model.dart';
import '../../../data_layer/models/wishlist_model/wishlist_items_model.dart';
import '../../../data_layer/repositories/random_meme_repository.dart';
import '../../../resources/hive_db/box_keys.dart';
import 'random_meme_event.dart';
import 'random_meme_state.dart';

class RandomMemeBloc extends Bloc<RandomMemeEvent, RandomMemeState> {
  final RandomMememRepository randomMememRepository;
  final String _shareImageName = "memeImage.png";
  final HiveDbLocalDataSource localDb;

  RandomMemeBloc({required this.randomMememRepository, required this.localDb})
      : super(RandomMemeLoadingState());

  @override
  Stream<RandomMemeState> mapEventToState(RandomMemeEvent event) async* {
    if (event is RandomMemeLoadingEvent) {
      yield RandomMemeLoadingState();
    } else if (event is GetRandomMemeListEvent) {
      yield* getRandomMemeList();
    } else if (event is ShareRandomMemeEvent) {
      saveAndShareMeme(event.imgUrl);
    } else if (event is AddToWishlistMemeEvent) {
      yield* addToFavouriteMeme(event.id, event.image);
    } else if (event is FetchDbDataEvent) {
      yield RandomMemeLoadingState();
      List<WishlistItemModel> items = await localDb
          .getDataFromHiveDb<WishlistItemModel>(BoxKeys.memeSaveImageBoxKey);
      yield DbDataReceivedState(items);
    } else if (event is RemoveItemFromWishlistEvent) {
      yield* _removeItemFromWishlist(event.key);
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

//Add to favourite list
  Stream<RandomMemeState> addToFavouriteMeme(String id, Image image) async* {
    try {
      WishlistItemModel item =
          WishlistItemModel(memeSaveImage: await _getPngBytes(image), key: id);
      localDb.addDataToLocalHiveDb<WishlistItemModel>(
          item, BoxKeys.memeSaveImageBoxKey, id);
    } catch (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
    }
    yield ItemAddedToWishlistState();
  }

  ///Method to convert image to pngBytes
  Future<Uint8List> _getPngBytes(Image image) async {
    final bytedata = await image.toByteData(format: ImageByteFormat.png);
    return bytedata!.buffer.asUint8List();
  }

  Stream<RandomMemeState> _removeItemFromWishlist(String key) async* {
    yield RandomMemeLoadingState();
    await localDb.removeDataFromLocalHiveDb(BoxKeys.memeSaveImageBoxKey, key);
    yield WishlistItemRemovedState();
  }
}
