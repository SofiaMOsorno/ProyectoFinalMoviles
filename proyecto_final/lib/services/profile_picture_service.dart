import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePictureService {
  static const String _localProfilePictureKey = 'local_profile_picture_path';
  static const String _presetProfilePictureKey = 'preset_profile_picture';

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

      final presetPath = prefs.getString('$_presetProfilePictureKey\_$userId');
      if (presetPath != null) {
        return {
          'type': 'preset',
          'path': presetPath,
        };
      }
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
    }
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

  // Guardar una imagen desde galería
  Future<String?> saveGalleryProfilePicture(String filePath, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_localProfilePictureKey\_$userId', filePath);
      // Limpiar imagen preset si existe
      await prefs.remove('$_presetProfilePictureKey\_$userId');

      return filePath;
    } catch (e) {
      throw 'Error saving gallery image: $e';
    }
  }
}