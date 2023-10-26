part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, loaded, error }

enum ChatFormStatus { initial, loading, loaded, error }

@immutable
class ChatState extends Equatable {
  final List<Chat> chats;
  final ChatStatus status;
  final ChatFormStatus formStatus;
  final String? errorMessage;

  const ChatState({
    this.errorMessage,
    required this.chats,
    required this.status,
    required this.formStatus,
  });

  factory ChatState.initial() => const ChatState(
        chats: [],
        status: ChatStatus.initial,
        formStatus: ChatFormStatus.initial,
        errorMessage: null,
      );

  @override
  List<Object?> get props => [chats, status, formStatus];

  ChatState copyWith({
    List<Chat>? chats,
    ChatStatus? status,
    ChatFormStatus? formStatus,
    String? errorMessage,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      status: status ?? this.status,
      formStatus: formStatus ?? this.formStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
