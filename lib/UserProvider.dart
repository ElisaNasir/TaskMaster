import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = "Elisa Nasir";
  String _email = "elisa@example.com";
  String _profilePic = "https://i.pravatar.cc/150?img=10";

  String get name => _name;
  String get email => _email;
  String get profilePic => _profilePic;

  void setUser(String name, String email, String profilePic) {
    _name = name;
    _email = email;
    _profilePic = profilePic;
    notifyListeners();
  }
}
