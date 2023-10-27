import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_app/appwrite/const/appwrite_const.dart';
import 'package:flutter_chat_app/appwrite/model/chat.dart';
import 'package:flutter_chat_app/appwrite/repo/db_repo.dart';
import 'package:flutter_chat_app/appwrite/repo/realtime.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final DbRepo _dbRepo;
  final RealRepo _realRepo;
  //late final StreamSubscription<RealtimeMessage> _chatSubscription;
  ChatBloc(this._dbRepo, this._realRepo) : super(ChatState.initial()) {
    on<AddChat>(_onAddChat);
    on<DeleteChat>(_onDeleteChat);
    on<GetAllChat>(_onGetAllChat);
  }

  _onAddChat(AddChat event, Emitter<ChatState> emit) async {
    emit(state.copyWith(formStatus: ChatFormStatus.loading));
    try {
      await _dbRepo.createChat(chat: event.chat);
      emit(state.copyWith(formStatus: ChatFormStatus.loaded));
    } on AppwriteException catch (e, _) {
      emit(state.copyWith(
          formStatus: ChatFormStatus.error,
          errorMessage:
              'Error with status code:${e.code} & message: ${e.message}'));
    } catch (e) {
      emit(
          state.copyWith(formStatus: ChatFormStatus.error, errorMessage: null));
    }
  }

  _onDeleteChat(DeleteChat event, Emitter<ChatState> emit) async {
    emit(state.copyWith(formStatus: ChatFormStatus.loading));
    try {
      await _dbRepo.deleteChat(id: event.chatId);
      emit(state.copyWith(formStatus: ChatFormStatus.loaded));
    } on AppwriteException catch (e, _) {
      emit(state.copyWith(
          formStatus: ChatFormStatus.error,
          errorMessage:
              'Error with status code:${e.code} & message: ${e.message}'));
    } catch (e) {
      emit(
          state.copyWith(formStatus: ChatFormStatus.error, errorMessage: null));
    }
  }

  _onGetAllChat(GetAllChat event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      final chats = await _dbRepo.getChatsFuture();
      emit(state.copyWith(status: ChatStatus.loaded, chats: chats));

      await emit.forEach(
        _realRepo.getChat().stream,
        onData: (data) {
          if (data.events.contains(
            'databases.*.collections.${AppwriteConst.chatCollectionId}.documents.*.create',
          )) {
            final chat = Chat.fromMap(data.payload);

            return state.copyWith(chats: [chat, ...state.chats]);
          }
          return state;
        },
      );
    } on AppwriteException catch (e, _) {
      log(': ${e.message}');
      emit(state.copyWith(
          status: ChatStatus.error,
          errorMessage:
              'Error with status code:${e.code} & message: ${e.message}'));
    } catch (e) {
      log(': -> ${e.toString()}');
      emit(state.copyWith(status: ChatStatus.error, errorMessage: null));
    }
  }
}
