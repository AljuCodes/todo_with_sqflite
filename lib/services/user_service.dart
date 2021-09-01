import 'package:flutter/material.dart';
import 'package:sqlite_provider_starter/database/todo_database.dart';
import 'package:sqlite_provider_starter/models/user.dart';

class UserService with ChangeNotifier {
  late User _currentUser;
  bool _busyCreate = false;
  bool _userExists = false;

  User get currentUser => _currentUser;
  bool get bussyCreate => _busyCreate;
  bool get userExists => _userExists;

  set userExists(bool value) {
    _userExists = value;
    notifyListeners();
  }

  Future<String> getUser(String username) async {
    String result = 'ok';
    try {
      _currentUser = await TodoDatabase.instance.getUser(username);
      notifyListeners();
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }

  Future<String> chechIfUserExists(String username) async {
    String result = 'ok';
    try {
      await TodoDatabase.instance.getUser(username);
      notifyListeners();
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }

  Future<String> updateCurrentUser(String name) async {
    String result = 'ok';
    _currentUser.name = name;
    notifyListeners();
    try {
      await TodoDatabase.instance.updateUser(_currentUser);
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }

  Future<String> createUser(User user) async {
    String result = 'ok';
    _busyCreate = true;
    notifyListeners();
    try {
      await TodoDatabase.instance.createUSer(user);
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }
}

String getHumanReadableError(String message) {
  if (message.contains('UNIQUE constraint failed')) {
    return 'This user already exists in the database. Please choose a new one.';
  }
  if (message.contains('not found in the database')) {
    return 'The user does not exist in the database. Please register first.';
  }
  return message;
}
