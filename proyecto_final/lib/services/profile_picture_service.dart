import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ProfilePictureService {
  static const String _localProfilePictureKey = 'local_profile_picture_path';
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw 'Error selecting image: $e';
    }
  }

  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw 'Error taking photo: $e';
    }
  }

  Future<String?> saveProfilePicture(File imageFile, String userId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final profilePicturesDir = Directory('${directory.path}/profile_pictures');

      if (!await profilePicturesDir.exists()) {
        await profilePicturesDir.create(recursive: true);
      }

      final fileName = 'profile_$userId${path.extension(imageFile.path)}';
      final savedImage = await imageFile.copy('${profilePicturesDir.path}/$fileName');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_localProfilePictureKey\_$userId', savedImage.path);

      return savedImage.path;
    } catch (e) {
      throw 'Error saving image: $e';
    }
  }

  Future<String?> getLocalProfilePicturePath(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final imagePath = prefs.getString('$_localProfilePictureKey\_$userId');

      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          return imagePath;
        } else {
          await prefs.remove('$_localProfilePictureKey\_$userId');
          return null;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteLocalProfilePicture(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final imagePath = prefs.getString('$_localProfilePictureKey\_$userId');

      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
        await prefs.remove('$_localProfilePictureKey\_$userId');
      }
    } catch (e) {
      throw 'Error deleting image: $e';
    }
  }

  Future<bool> hasLocalProfilePicture(String userId) async {
    final path = await getLocalProfilePicturePath(userId);
    return path != null;
  }
}
