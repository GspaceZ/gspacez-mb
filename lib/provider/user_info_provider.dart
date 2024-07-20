
import 'package:flutter/material.dart';

class UserInfoProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _phone = '';
  String _address = '';
  String _urlAvatar = '';

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get address => _address;
  String get urlAvatar => _urlAvatar;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void setUrlAvatar(String urlAvatar) {
    _urlAvatar = urlAvatar;
    notifyListeners();
  }
}