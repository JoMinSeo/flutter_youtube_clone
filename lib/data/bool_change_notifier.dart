import 'package:flutter/cupertino.dart';

class BoolNotifier extends ChangeNotifier {
  bool _value = false;

  set value(bool newBool) {
    _value = newBool;
    notifyListeners();
  }

  bool get value => _value;
}