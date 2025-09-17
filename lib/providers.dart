import 'package:flutter/foundation.dart';
import 'package:instagram_clone_flutter/Models/user_models.dart';
import 'package:instagram_clone_flutter/Services/auth_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthServiceImpl _authMethods = AuthServiceImpl();

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
