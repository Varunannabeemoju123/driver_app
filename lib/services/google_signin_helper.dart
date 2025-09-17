// services/google_signin_helper.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class GoogleSignInHelper {
  static Future<User?> signInWithGoogle({required bool isDriver}) async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      final userRef = FirebaseDatabase.instance
          .ref('users/${isDriver ? 'drivers' : 'admin'}/${user.uid}');

      await userRef.set({
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
      });
    }

    return user;
  }
}
