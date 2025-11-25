import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ProfilePictureService {
  static const String _localProfilePictureKey = 'local_profile_picture_path';
  static const String _presetProfilePictureKey = 'preset_profile_picture';
  final ImagePicker _picker = ImagePicker();

  // Lista de imágenes preestablecidas
  static const List<String> presetImages = [
    'assets/images/profile_pic/l1.png',
    'assets/images/profile_pic/m1.png',
    'assets/images/profile_pic/m2.png',
    'assets/images/profile_pic/m3.png',
    'assets/images/profile_pic/m4.png',
    'assets/images/profile_pic/m5.png',
    'assets/images/profile_pic/m6.png',
    'assets/images/profile_pic/m7.png',
    'assets/images/profile_pic/m8.png',
  ];

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
      // Limpiar imagen preestablecida si existe
      await prefs.remove('$_presetProfilePictureKey\_$userId');

      return savedImage.path;
    } catch (e) {
      throw 'Error saving image: $e';
    }
  }

  // Guardar una imagen preestablecida seleccionada
  Future<String?> savePresetProfilePicture(String assetPath, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_presetProfilePictureKey\_$userId', assetPath);
      // Limpiar imagen local si existe
      await deleteLocalProfilePicture(userId);

      return assetPath;
    } catch (e) {
      throw 'Error saving preset image: $e';
    }
  }

  // Obtener la ruta de la imagen de perfil (local o preestablecida)
  Future<Map<String, String?>> getProfilePicturePath(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Primero verificar si hay una imagen preestablecida
      final presetPath = prefs.getString('$_presetProfilePictureKey\_$userId');
      if (presetPath != null) {
        return {
          'type': 'preset',
          'path': presetPath,
        };
      }

      // Si no, verificar imagen local
      final localPath = prefs.getString('$_localProfilePictureKey\_$userId');
      if (localPath != null) {
        final file = File(localPath);
        if (await file.exists()) {
          return {
            'type': 'local',
            'path': localPath,
          };
        } else {
          await prefs.remove('$_localProfilePictureKey\_$userId');
        }
      }

      return {'type': null, 'path': null};
    } catch (e) {
      return {'type': null, 'path': null};
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

  // Obtener la imagen preestablecida actual
  Future<String?> getCurrentPresetImage(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('$_presetProfilePictureKey\_$userId');
    } catch (e) {
      return null;
    }
  }
}