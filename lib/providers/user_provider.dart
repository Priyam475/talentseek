import 'package:flutter/foundation.dart';

class AppUser {
  final String uid;
  final String? email;

  AppUser({required this.uid, this.email});
}

class UserProvider with ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;

  void setUser(AppUser? user) {
    _user = user;
    notifyListeners();
  }
}
