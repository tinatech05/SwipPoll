import 'package:flutter/widgets.dart';




class BaseModel extends ChangeNotifier {
 
 // User get currentUser => _authenticationService.currentUser;
  
 bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
