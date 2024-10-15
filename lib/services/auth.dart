import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  // instance of Firebase authentication which communicate with Firebase and
  // the code
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current user
  User? get currentUser => _auth.currentUser;

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // sign in anonymoulsy
  Future signInAnon() async {
    try {
      await _auth.signInAnonymously();
      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // sign in with email & password
  Future signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register with email & password
  Future register(
    String email,
    String password,
    String firstName,
    String lastName,
    int age,
  ) async {
    try {
      // create user
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // add users details before return user
      addUserDetails(_auth.currentUser!.uid, firstName, lastName, email, age);
      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // add users details
  Future addUserDetails(String id, String? firstName, String? lastName,
      String? email, int? age) async {
    await FirebaseFirestore.instance.collection('users').doc(email).set({
      'id': id,
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'age': age,
    });
  }

  // reset password of email & password authentification method
  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // sign in with Google
  Future signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // if user cancel the sign in process
    if (gUser == null) {
      return 'Sign in process cancelled';
    }

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // create a new credentiel for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // finally, let's sign in
    try {
      await _auth.signInWithCredential(credential);
      // First name and last name
      List<String>? displayName = currentUser?.displayName?.split(' ');
      String? firstName = displayName?.first;
      String? lastName = displayName?.last;
      String? email = currentUser?.email;
      addUserDetails(currentUser!.uid, firstName, lastName, email, null);
      print(currentUser);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign in with Apple
  Future signInWithApple() async {
    // final credential = await SignInWithApple.getAppleIDCredential(
    //   webAuthenticationOptions: WebAuthenticationOptions(
    //     clientId: '',
    //     redirectUri: Uri.parse(
    //       'https://go-muscu-531ea.firebaseapp.com/__/auth/handler',
    //     ),
    //   ),
    //   scopes: [
    //     AppleIDAuthorizationScopes.email,
    //     AppleIDAuthorizationScopes.fullName,
    //   ],
    // );
    // print(credential);
  }

  // sign out
  Future signOut() async {
    await _auth.signOut();
    _auth.authStateChanges();
  }
}
