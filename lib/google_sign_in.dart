import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<void> googleLogin() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    _user = null;
    notifyListeners();
  }
}
