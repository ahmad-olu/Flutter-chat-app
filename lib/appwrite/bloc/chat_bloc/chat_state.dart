part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, loaded, error }

@immutable
class ChatState extends Equatable {
  final List<Chat> chats;
  final ChatStatus status;
  final String? errorMessage;

  const ChatState({
    this.errorMessage,
    required this.chats,
    required this.status,
  });

  factory ChatState.initial() => const ChatState(
        chats: [],
        status: ChatStatus.initial,
        errorMessage: null,
      );

  @override
  List<Object?> get props => [chats, status];

  ChatState copyWith({
    List<Chat>? chats,
    ChatStatus? status,
    String? errorMessage,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
