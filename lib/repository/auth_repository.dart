import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// TODO Should not return firebase auth object.
class AuthRepository {
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  Future<UserCredential> signInWithApple() async {
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
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? account = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleCredential = await account!.authentication;

    final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleCredential.accessToken!,
      idToken: googleCredential.idToken,
    );

    UserCredential user = await _firebase.signInWithCredential(oAuthCredential);
    return user;
  }

  Future<UserCredential> signIn(String email, String password) async {
    UserCredential userCredential = await _firebase.signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  Future<void> signUp(String email, String password) async {
    await _firebase.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebase.signOut();
  }

  Future<void> forgotPassword(String email) async {
    await _firebase.sendPasswordResetEmail(email: email);
  }
}
