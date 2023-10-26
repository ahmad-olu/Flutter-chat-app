import 'package:appwrite/appwrite.dart';
import 'package:flutter_chat_app/appwrite/const/appwrite_const.dart';

class AppWrite {
  static final AppWrite instance = AppWrite._internal();

  late final Client client;

  factory AppWrite._() {
    return instance;
  }

  AppWrite._internal() {
    client = Client()
            .setEndpoint(AppwriteConst.endpoint)
            .setProject(AppwriteConst.projectId)
        //.setSelfSigned(status: AppwriteConst.selfSignedIn)
        ;
  }
}
