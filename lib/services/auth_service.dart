import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Sign In
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Rethrow FirebaseAuthException to be handled in the LoginScreen
      throw e;
    } catch (e) {
      // Handle other exceptions if needed
      print("Error signing in: $e");
      throw Exception("An unexpected error occurred.");
    }
  }

  //Sign Up
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Rethrow FirebaseAuthException to be handled in SignupScreen
      throw e;
    } catch (e) {
      // Handle other exceptions if needed
      print("Error during sign-up: $e");
      throw Exception("An unexpected error occurred.");
    }
  }

  //Sign Out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  signInWithEmailAndPasswordPlaceholder(String text, String text2) {}
}
