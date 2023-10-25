import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_app/appwrite/model/chat.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState.initial()) {
    on<AddChat>(_onAddChat);
    on<DeleteChat>(_onDeleteChat);
    on<GetAllChat>(_onGetAllChat);
  }

  _onAddChat(AddChat event, Emitter<ChatState> emit) {}
  _onDeleteChat(DeleteChat event, Emitter<ChatState> emit) {}
  _onGetAllChat(GetAllChat event, Emitter<ChatState> emit) {}
}
