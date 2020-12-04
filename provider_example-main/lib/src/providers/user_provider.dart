import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

// enum UserState { loading, loaded, error }

abstract class UserState {}

class Loading extends UserState {}

class Loaded extends UserState {}

class Error extends UserState {}

class UserProvider extends ChangeNotifier {
  UserState _userState;
  List<UserModel> _userModel;

  get userState => _userState;
  get userModel => _userModel;

  Future fetchUsers() async {
    // _userState = UserState.loading;
    _userState = Loading();
    final response =
        await http.get('https://jsonplaceholder.typicode.com/users');
    if (response.statusCode != 200) {
      // _userState = UserState.error;
      _userState = Error();
      notifyListeners();
    } else {
      _userModel = userModelFromJson(response.body);
      // _userState = UserState.loaded;
      _userState = Loaded();
      notifyListeners();
    }
  }
}
