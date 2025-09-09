// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('signInWithEmailAndPassword FirebaseAuthException: Code: ${e.code}, Message: ${e.message}');
      return null; // The UI should handle null by showing a generic error
    } catch (e) {
      debugPrint('signInWithEmailAndPassword Exception: $e');
      return null;
    }
  }

  // Updated signUp method
  Future<String> signUp({required String email, required String password, required String fullName}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Create user document in Firestore
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'fullName': fullName,
          'profilePictureUrl': '', // Default or placeholder
          'headline': '',        // Default or placeholder
          'about': '',           // Default or placeholder
          'createdAt': FieldValue.serverTimestamp(),
          // Add any other initial fields you need for a new user
        });
        return 'Success';
      }
      // This case should ideally not be reached if createUserWithEmailAndPassword succeeds
      return 'User registration failed after account creation.';
    } on FirebaseAuthException catch (e) {
      debugPrint('signUp FirebaseAuthException: Code: ${e.code}, Message: ${e.message}');
      if (e.code == 'weak-password') {
        return 'The password provided is too weak (at least 6 characters recommended).';
      } else if (e.code == 'email-already-in-use') {
        return 'The email address is already in use by another account.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is not valid.';
        // You can add more specific cases here if needed
      }
      // For other Firebase auth errors, return a more generic message or e.message
      return e.message ?? 'An authentication error occurred. Please try again.';
    } catch (e) {
      debugPrint('signUp Unexpected Exception: $e');
      // For non-FirebaseAuth errors (e.g., Firestore issues after successful auth)
      return 'An unexpected error occurred during setup. Please try again later.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Checks if a user profile document exists in Firestore.
  /// Returns true if a profile has been created.
  Future<bool> hasUserProfile(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      return doc.exists;
    } catch (e) {
      debugPrint("Error checking user profile: $e");
      return false;
    }
  }

  // The original createUserWithEmailAndPassword can be removed or kept if used elsewhere,
  // but the new signUp method above is what SignupScreen should use.
  // For clarity, I'm removing the old one as its functionality is now in signUp.
  /*
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Failed to sign up: ${e.message}');
      return null;
    }
  }
  */
}
