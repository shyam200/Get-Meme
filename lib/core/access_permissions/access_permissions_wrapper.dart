import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

///This class is a [wrapper] over methos to [get] and [request permission].
///Decouple the libraries implementation to the bloc logic using this class
class AccessPermissionsWrapper {
  ///Method to check if gallery permision is already allowed
  Future<bool> isGalleryPermissionAllowed() async {
    return false;
  }

  ///Method to [request] gallery permission
  Future<PermissionStatus> requestGalleryPermision() async {
    if (Platform.isIOS) {
      return Permission.photos.request();
    } else if (Platform.isAndroid) {
      return Permission.storage.request();
    } else {
      return PermissionStatus.denied;
    }
  }
}
