import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// TODO Remove Repository logic ? Let's see after firestore implmentation.
class AuthRepository {
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  Future<UserCredential> signInWithApple() async {
    try {
      AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      OAuthProvider oAuthProvider = OAuthProvider("apple.com");
      OAuthCredential oAuthCredential = oAuthProvider.credential(
        idToken: appleCredential.identityToken!,
        accessToken: appleCredential.authorizationCode,
      );

      UserCredential user = await _firebase.signInWithCredential(oAuthCredential);
      return user;
    } on FirebaseAuthException catch (_) {
      rethrow;

      /// TODO Manage Firebase error with a class (tester avec un email déjà pris / voir les code d'erreur)
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleCredential = await account!.authentication;

      final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleCredential.accessToken!,
        idToken: googleCredential.idToken,
      );

      UserCredential user = await _firebase.signInWithCredential(oAuthCredential);
      return user;
    } on FirebaseAuthException catch (_) {
      rethrow;

      /// TODO Manage Firebase error with a class
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebase.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (_) {
      rethrow;

      /// TODO Manage Firebase error with a class
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _firebase.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (_) {
      rethrow;

      /// TODO Manage Firebase error with a class
    }
  }

  Future<void> signOut() async {
    await _firebase.signOut();
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _firebase.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (_) {
      rethrow;

      /// TODO Manage Firebase error with a class
    }
  }
}
