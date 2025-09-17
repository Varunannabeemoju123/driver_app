import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<UserCredential?> signInWithGoogle(String role) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Push to Firebase Realtime Database
      await _db.child('users/${userCredential.user!.uid}').set({
        'name': userCredential.user!.displayName,
        'email': userCredential.user!.email,
        'role': role,
        'uid': userCredential.user!.uid,
      });

      return userCredential;
    } catch (e) {
      print('SignIn Error: $e');
      return null;
    }
  }
}
