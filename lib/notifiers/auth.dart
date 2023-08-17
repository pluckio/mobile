import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
  final Account _account;
  User? _user;

  Auth(Client client) : _account = Account(client);

  User? get user => _user;

  Future<void> init() async {
    try {
      _user = await _account.get();
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _account.createEmailSession(
        email: email,
        password: password,
      );
      await init();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> signUp(
      {required String email,
      required String username,
      required String password}) async {
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        name: username,
        password: password,
      );
      await signIn(email: email, password: password);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      _user = null;
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
