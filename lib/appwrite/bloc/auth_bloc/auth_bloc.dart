import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_app/appwrite/repo/auth_repo.dart';
import 'package:flutter_chat_app/appwrite/repo/realtime.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository, required this.realTimeRepository})
      : super(const AuthState.unauthenticated()) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
  }

  final RealRepo realTimeRepository;
  final AuthRepo authRepository;

  void _onUserChanged(AppUserChanged event, Emitter<AuthState> emit) async {
    try {
      final user = await authRepository.currentUser;
      emit(AuthState.authenticated(user));

      // if (state.status == AuthStatus.authenticated) {
      //   await emit.forEach(
      //     realTimeRepository.getUser().stream,
      //     onData: (data) {
      //       if (data.events.contains('users.*.sessions.*')) {
      //         log('channels : ${data.channels}');
      //         log('payload : ${data.payload}');
      //         log('events : ${data.events}');
      //       }
      //       return state;
      //     },
      //   );
      // }
    } on AppwriteException catch (e, _) {
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(const AuthState.unauthenticated());
    }
  }

  void _onLogoutRequested(
      AppLogoutRequested event, Emitter<AuthState> emit) async {
    await authRepository.logout();
    emit(const AuthState.unauthenticated());
  }
}
