part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class GetAllChat extends ChatEvent {
  final List<Chat> chats;

  GetAllChat({required this.chats});
}

final class AddChat extends ChatEvent {
  final Chat chat;

  AddChat({required this.chat});
}

final class DeleteChat extends ChatEvent {
  final Chat chat;

  DeleteChat({required this.chat});
}
