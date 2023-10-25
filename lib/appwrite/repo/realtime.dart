import 'package:appwrite/appwrite.dart';
import 'package:flutter_chat_app/appwrite/repo/appwrite.dart';

class RealRepo {
  final Realtime _realtime = Realtime(AppWrite.instance.client);

  // Future<void> test() async {
  //   final subscription = _realtime.subscribe(['collections.A.documents.A', 'files']);
  // }
  RealtimeSubscription getUser() {
    return _realtime.subscribe(['account']);

    // subscription.stream.listen((response) { print(response);})
  }

  RealtimeSubscription getChat() {
    return _realtime.subscribe(['databases.[ID].collections.[ID].documents']);
  }
}
