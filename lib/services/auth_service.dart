
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recipes_app/screens/widgets/home.dart';

class AuthService {
  final String? email;
  final String? password;
  final BuildContext context;

  AuthService({
    this.email,
    this.password,
    required this.context,
  });

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<bool> checkIfEmailExists(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      await FirebaseAuth.instance.currentUser?.delete();
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return true;
      }
      return false;
    }
  }

  bool _validateEmail(String email) {
    // Basic email validation
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> logIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!.trim(),
        password: password!.trim(),
      );
      //FILL IN
      // Navigate to Expenses page
      Navigator.pushReplacementNamed(context, HomePage.id);
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Login failed";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password";
      }
      _showToast(errorMessage);
    } catch (e) {
      _showToast("An unexpected error occurred: ${e.toString()}");
    }
  }

  Future<void> signUp(String confirmPassword) async {
    // Validate email
    if (email == null || email!.trim().isEmpty) {
      _showToast("Email cannot be empty");
      return;
    }

    if (!_validateEmail(email!)) {
      _showToast("Invalid email format");
      return;
    }

    // Validate password
    if (password == null || password!.trim().isEmpty) {
      _showToast("Password cannot be empty");
      return;
    }

    if (password!.length < 6) {
      _showToast("Password must be at least 6 characters");
      return;
    }

    // Check password match
    if (password != confirmPassword) {
      _showToast("Passwords do not match");
      return;
    }

    try {
      // Check if user already exists
      // var user = FirebaseAuth
      // var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email!.trim());
      bool emailExists = await checkIfEmailExists(email!, password!);
      if (emailExists) {
        _showToast("Email already in use");
        return;
      }

      // Create user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!.trim(),
        password: password!.trim(),
      );
      //FILL IN
      // Navigate to login screen or home
      Navigator.pushReplacementNamed(context, HomePage.id);
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Sign up failed";
      if (e.code == 'weak-password') {
        errorMessage = "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "Email already in use";
      }
      _showToast(errorMessage);
    } catch (e) {
      _showToast("An unexpected error occurred: ${e.toString()}");
    }
  }
}
