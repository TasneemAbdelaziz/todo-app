import 'package:flutter/cupertino.dart';
import 'package:todolist/data_class/my_user.dart';

class AuthProvider extends ChangeNotifier{
  myUser? currentUser;

  void updateUser(myUser newUser){
    currentUser = newUser;
    notifyListeners();
  }
}