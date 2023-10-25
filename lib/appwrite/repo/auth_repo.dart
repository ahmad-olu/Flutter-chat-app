import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_chat_app/appwrite/repo/appwrite.dart';

class AuthRepo {
  final Account _account = Account(AppWrite.instance.client);

  Future<User> get currentUser async {
    try {
      return await _account.get();
    } on AppwriteException catch (e, _) {
      log(e.toString());
      throw AppwriteException(e.message, e.code);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<User> signUp(
      {String? name, required String email, required String password}) async {
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      return await login(email: email, password: password);
    } on AppwriteException catch (e, _) {
      throw AppwriteException(e.message, e.code);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<User> login({required String email, required String password}) async {
    try {
      await _account.createEmailSession(
        email: email,
        password: password,
      );

      return _account.get();
    } on AppwriteException catch (e, _) {
      throw AppwriteException(e.message, e.code);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updatePassword({required newPassword}) async {
    try {
      await _account.updatePassword(
        password: '',
      );
    } on AppwriteException catch (e, _) {
      throw AppwriteException(e.message, e.code);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> logout() {
    try {
      return _account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e, _) {
      throw AppwriteException(e.message, e.code);
    } catch (e) {
      throw Exception(e);
    }
  }
}
