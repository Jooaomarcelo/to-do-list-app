import 'dart:io';

import 'package:to_do_list/core/models/user_data.dart';
import 'package:to_do_list/core/services/auth/auth_firebase_service.dart';

abstract class AuthService {
  UserData? get currentUser;

  Stream<UserData?> get userChanges;

  Future<void> signup(String name, String email, String password, File? image);

  Future<void> login(String email, String password);

  Future<void> logout();

  factory AuthService() {
    return AuthFirebaseService();
  }
}
