import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_final/services/fcm_token_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FCMTokenService _fcmTokenService = FCMTokenService();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

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

      await userCredential.user?.updateDisplayName(username);

      // Obtener el token FCM
      String? fcmToken = await _fcmTokenService.getToken();

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'profilePicture': null,
        'profilePictureType': null,
        'fcmToken': fcmToken,
        'tokenUpdatedAt': fcmToken != null ? FieldValue.serverTimestamp() : null,
      });

      // Configurar listener para actualizaciones del token
      if (userCredential.user?.uid != null) {
        _fcmTokenService.setupTokenRefreshListener(userCredential.user!.uid);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error al registrar usuario: $e';
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Actualizar token FCM al iniciar sesión
      if (userCredential.user?.uid != null) {
        await _fcmTokenService.saveTokenToFirestore(userCredential.user!.uid);
        _fcmTokenService.setupTokenRefreshListener(userCredential.user!.uid);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error al iniciar sesión: $e';
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
  try {

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn()
      .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw 'Time is over. Try again.';
        },
      );

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await _auth.signInWithCredential(credential);

    // Obtener token FCM
    String? fcmToken = await _fcmTokenService.getToken();

    if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': userCredential.user?.displayName ?? 'Usuario',
        'email': userCredential.user?.email,
        'createdAt': FieldValue.serverTimestamp(),
        'profilePicture': userCredential.user?.photoURL,
        'fcmToken': fcmToken,
        'tokenUpdatedAt': fcmToken != null ? FieldValue.serverTimestamp() : null,
      });
    } else {
      // Para usuario existente actualizar token
      if (userCredential.user?.uid != null) {
        await _fcmTokenService.saveTokenToFirestore(userCredential.user!.uid);
      }
    }

    // Configurar listener para actualizaciones del token
    if (userCredential.user?.uid != null) {
      _fcmTokenService.setupTokenRefreshListener(userCredential.user!.uid);
    }

    return userCredential;
  } catch (e) {
    throw 'Error with Google sign in: $e';
  }
}

  Future<void> signOut() async {
    try {
      // Eliminar token FCM antes de cerrar sesión
      if (_auth.currentUser?.uid != null) {
        await _fcmTokenService.deleteTokenFromFirestore(_auth.currentUser!.uid);
      }

      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw 'Error closing your session: $e';
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error sending retreeving email: $e';
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw 'Error obtaining user data: $e';
    }
  }

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
        
        if (username != null) {
          await _auth.currentUser?.updateDisplayName(username);
        }
      }
    } catch (e) {
      throw 'Error updating profile: $e';
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Weak password. Must have at least 6 characters.';
      case 'email-already-in-use':
        return 'You are trying to use a registered email.';
      case 'invalid-email':
        return 'Invalid email.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'user-disabled':
        return 'This account have no permissions anymore.';
      case 'user-not-found':
        return 'Thee is no account with this email adress.';
      case 'wrong-password':
        return 'Incorrect Password.';
      case 'invalid-credential':
        return 'Invalid credentials.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}