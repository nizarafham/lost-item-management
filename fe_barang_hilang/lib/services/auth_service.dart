import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi untuk melakukan login dengan email dan password
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result;
    } catch (e) {
      developer.log(e.toString());
      return null;
    }
  }

  // Fungsi untuk melakukan registrasi dengan email dan password
  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result;
    } catch (e) {
      developer.log(e.toString());
      return null;
    }
  }

  // Fungsi untuk melakukan logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Fungsi untuk mendapatkan user yang sedang login
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Fungsi untuk melakukan reset password
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}