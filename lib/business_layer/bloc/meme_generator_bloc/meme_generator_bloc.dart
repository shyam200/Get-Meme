import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/access_permissions/access_permissions_wrapper.dart';
import '../../../core/hive/hive_local_data_source.dart';
import '../../../data_layer/models/wishlist_model/wishlist_items_model.dart';
import '../../../data_layer/repositories/random_meme_repository.dart';
import '../../../resources/hive_db/box_keys.dart';
import 'meme_generator_event.dart';
import 'meme_generator_state.dart';

class MemeGeneratorBloc extends Bloc<MemeGeneratorEvent, MemeGeneratorState> {
  final RandomMememRepository repository;
  final AccessPermissionsWrapper accessPermissionsWrapper;
  final HiveDbLocalDataSource hiveDbLocalDataSource;

  MemeGeneratorBloc(
      {required this.repository,
      required this.accessPermissionsWrapper,
      required this.hiveDbLocalDataSource})
      : super(MemeGeneratorLoadingState());
  @override
  Stream<MemeGeneratorState> mapEventToState(event) async* {
    if (event is MemeGeneratorLoadingEvent) {
      yield MemeGeneratorLoadingState();
    } else if (event is MemeGeneratorGetImageListEvent) {
      yield* _getImageDataList();
    } else if (event is MemeGeneratorSaveImageEvent) {
      yield* _getGalleryPermission();
    } else if (event is PermissionGrantedEvent) {
      yield* _saveImageToGallary(event.image);
    } else if (event is AddImageToWishlistEvent) {
      //Adding image to favourite list
      addImageToFavourite(event.image, event.key);
      yield ItemAddedToWishlistState();
    } else if (event is FetchDbDataListEvent) {
      yield MemeGeneratorLoadingState();
      final List<WishlistItemModel> items = await hiveDbLocalDataSource
          .getDataFromHiveDb<WishlistItemModel>(BoxKeys.memeSaveImageBoxKey);
      yield DbDataReceivedState(itemsList: items);
    } else if (event is RemoveItemFromWishlistEvent) {
      yield* _removeItemFromWishlist(event.key);
    }
  }
  //   on<MemeGeneratorEvent>((event, emit) async {
  //     if (event is MemeGeneratorLoadingEvent) {
  //       MemeGeneratorLoadingState();
  //     } else if (event is MemeGeneratorGetImageListEvent) {
  //       _getImageDataList();
  //     }
  //   });
  // }

  Stream<MemeGeneratorState> _getImageDataList() async* {
    yield MemeGeneratorLoadingState();
    try {
      final imageList = await repository.getMemeGeneratorImageList();
      yield MemeGeneratorListLoadedState(imageList: imageList);
    } catch (e) {
      dev.log('unable to fetch data:- $e');
    }
  }

  Stream<MemeGeneratorState> _saveImageToGallary(Image image) async* {
    try {
      yield MemeGeneratorLoadingState();

      //retreive application directory
      final directoryPath = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = await getPngBytes(image);
      //create a new file
      File imageFile =
          File('$directoryPath/screenshot${Random().nextInt(200)}.png');
      //write png bytes into the file
      imageFile.writeAsBytes(pngBytes);
      // save file to gallery
      await ImageGallerySaver.saveImage(pngBytes,
          name: "screenshot${Random().nextInt(200)}.png}");
      yield MemeGeneratorImageSavedSucessState();
    } catch (exception, stackTrace) {
      dev.log('$exception', stackTrace: stackTrace);
      yield TechnicalErrorState();
    }
  }

  //Method to return the png bytes of the given Image
  Future<Uint8List> getPngBytes(Image? image) async {
    ByteData? byteData = await image?.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  ///Method to add given image to favourite
  addImageToFavourite(Image? image, String key) async {
    Uint8List? pngBytes = await getPngBytes(image);
    WishlistItemModel item =
        WishlistItemModel(memeSaveImage: pngBytes, key: key);
    hiveDbLocalDataSource.addDataToLocalHiveDb<WishlistItemModel>(
        item, BoxKeys.memeSaveImageBoxKey, key);
  }

  Stream<MemeGeneratorState> _getGalleryPermission() async* {
    yield MemeGeneratorLoadingState();
    final isPermissionAllowed =
        await accessPermissionsWrapper.isGalleryPermissionAllowed();
    if (isPermissionAllowed) {
      yield PermissionGrantedState();
      return;
    }

    final PermissionStatus permissionStatus =
        await accessPermissionsWrapper.requestGalleryPermision();

    if (permissionStatus.isDenied) {
      yield PermissionTemporarilyDenied();
    } else if (permissionStatus.isPermanentlyDenied ||
        permissionStatus.isRestricted) {
      yield PermissionPermanentlyDenied();
    } else if (permissionStatus.isGranted || permissionStatus.isLimited) {
      yield PermissionGrantedState();
    }
  }

  ///[Remove] item from [wishlist]
  Stream<MemeGeneratorState> _removeItemFromWishlist(String key) async* {
    yield MemeGeneratorLoadingState();
    await hiveDbLocalDataSource.removeDataFromLocalHiveDb(
        BoxKeys.memeSaveImageBoxKey, key);
    yield WishlistItemRemovedState();
  }
}
