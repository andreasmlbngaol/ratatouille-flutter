import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moprog/core/model/token_manager.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  final TokenManager tokenManager;

  AuthService({required this.tokenManager});

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return null;
      }

      final googleSignInAuthentication = await googleSignInAccount.authentication;

      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
      );

      print("Sign In with Google");
      return await firebaseAuth.signInWithCredential(authCredential);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Future<UserCredential?> signInWithGoogle() async {
  //   try {
  //     final googleProvider = GoogleAuthProvider();
  //
  //     // Opsional: tambahkan scope jika perlu akses Google APIs tertentu
  //     // googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  //
  //     // Opsional: set custom parameters
  //     // googleProvider.setCustomParameters({'prompt': 'select_account'});
  //
  //     final userCredential =
  //     await FirebaseAuth.instance.signInWithProvider(googleProvider);
  //
  //     return userCredential;
  //   } catch (e) {
  //     debugPrint('Google sign-in error: $e');
  //     return null;
  //   }
  // }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    await tokenManager.clearTokens();
  }

  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateName(String newUsername) async {
    await currentUser!.updateDisplayName(newUsername);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    final credential = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email
  }) async {
    final credential = EmailAuthProvider.credential(email: email, password: currentPassword);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }
}