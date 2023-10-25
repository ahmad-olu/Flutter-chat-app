import 'package:appwrite/appwrite.dart';
import 'package:flutter_chat_app/appwrite/const/appwrite_const.dart';
import 'package:flutter_chat_app/appwrite/model/chat.dart';
import 'package:flutter_chat_app/appwrite/repo/appwrite.dart';

class DbRepo {
  final Databases _database = Databases(AppWrite.instance.client);

  Future<void> getChatsFuture({required Chat chat}) async {
    try {
      await _database.listDocuments(
        databaseId: AppwriteConst.chatDataBaseId,
        collectionId: AppwriteConst.chatCollectionId,
      );
    } on AppwriteException catch (e, _) {
      throw AppwriteException(e.message, e.code);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> createChat({required Chat chat}) async {
    try {
      await _database.createDocument(
        databaseId: AppwriteConst.chatDataBaseId,
        collectionId: AppwriteConst.chatCollectionId,
        documentId: ID.unique(),
        data: chat.toMap(),
      );
    } on AppwriteException catch (e, _) {
      throw AppwriteException(e.message, e.code);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteChat({required String id}) async {
    try {
      await _database.deleteDocument(
        databaseId: AppwriteConst.chatDataBaseId,
        collectionId: AppwriteConst.chatCollectionId,
        documentId: id,
      );
    } on AppwriteException catch (e, _) {
      throw AppwriteException(e.message, e.code);
    } catch (e) {
      throw Exception(e);
    }
  }
}
