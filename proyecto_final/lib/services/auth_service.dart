import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Registro con email y contraseña
  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Actualizar el displayName del usuario
      await userCredential.user?.updateDisplayName(username);

      // Guardar información adicional en Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'profilePicture': null,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error al registrar usuario: $e';
    }
  }

  // Login con email y contraseña
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error al iniciar sesión: $e';
    }
  }

  // Login con Google
  Future<UserCredential?> signInWithGoogle() async {
  try {
    print('📱 Iniciando Google Sign In...');
    
    // Trigger the authentication flow con timeout
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn()
      .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw 'Tiempo de espera agotado. Intenta nuevamente.';
        },
      );

    if (googleUser == null) {
      print('❌ Usuario canceló el login');
      return null;
    }

    print('✅ Google user obtenido: ${googleUser.email}');

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    print('✅ Google auth obtenido');

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    print('🔥 Iniciando sesión en Firebase...');
    UserCredential userCredential = await _auth.signInWithCredential(credential);
    print('✅ Firebase login exitoso: ${userCredential.user?.email}');

    // Verificar si es un nuevo usuario y crear documento en Firestore
    if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      print('📝 Creando documento en Firestore...');
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': userCredential.user?.displayName ?? 'Usuario',
        'email': userCredential.user?.email,
        'createdAt': FieldValue.serverTimestamp(),
        'profilePicture': userCredential.user?.photoURL,
      });
      print('✅ Documento creado en Firestore');
    }

    return userCredential;
  } catch (e) {
    print('🔴 ERROR en signInWithGoogle: $e');
    throw 'Error al iniciar sesión con Google: $e';
  }
}

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw 'Error al cerrar sesión: $e';
    }
  }

  // Restablecer contraseña
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error al enviar email de recuperación: $e';
    }
  }

  // Obtener datos del usuario desde Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw 'Error al obtener datos del usuario: $e';
    }
  }

  // Actualizar perfil del usuario
  Future<void> updateUserProfile({
    required String uid,
    String? username,
    String? profilePicture,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      
      if (username != null) updates['username'] = username;
      if (profilePicture != null) updates['profilePicture'] = profilePicture;
      
      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(updates);
        
        // Actualizar también el displayName en Firebase Auth
        if (username != null) {
          await _auth.currentUser?.updateDisplayName(username);
        }
      }
    } catch (e) {
      throw 'Error al actualizar perfil: $e';
    }
  }

  // Manejar excepciones de Firebase Auth
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'La contraseña es demasiado débil. Debe tener al menos 6 caracteres.';
      case 'email-already-in-use':
        return 'Este correo electrónico ya está registrado.';
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'operation-not-allowed':
        return 'Operación no permitida.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'user-not-found':
        return 'No existe una cuenta con este correo electrónico.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'invalid-credential':
        return 'Las credenciales son inválidas.';
      case 'too-many-requests':
        return 'Demasiados intentos. Por favor, intenta más tarde.';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
}