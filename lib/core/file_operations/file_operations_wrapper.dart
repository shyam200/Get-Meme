import 'package:extended_image/extended_image.dart';

///A common [wrapper] class for all different file operations
///
class FileOperaionsWrapper {
  //method to create a file with the given path
  File _createFile(String path) {
    final file = File(path);
    file.createSync();
    return file;
  }

  ///Method to save the file into gallery
  // void _saveFileToGallery(File file) {}
}
