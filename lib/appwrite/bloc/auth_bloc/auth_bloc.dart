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
    // _userSubscription = realTimeRepository.getUser().stream.listen((event) {
    //   log('-------------> this part');
    //   log('-----------> $event');
    //   //add(AppUserChanged(event));
    // });
  }

  final RealRepo realTimeRepository;
  final AuthRepo authRepository;
  //late final StreamSubscription<RealtimeMessage> _userSubscription;

  void _onUserChanged(AppUserChanged event, Emitter<AuthState> emit) async {
    //final user = await authRepository.currentUser;
    try {
      final user = await authRepository.currentUser;
      emit(AuthState.authenticated(user));
    } on AppwriteException catch (e, _) {
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(const AuthState.unauthenticated());
    }

    // emit(
    //   event.user != null
    //       ? AuthState.authenticated(event.user!)
    //       : const AuthState.unauthenticated(),
    // );
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AuthState> emit) {
    unawaited(authRepository.logout());
    emit(const AuthState.unauthenticated());
  }

  // @override
  // Future<void> close() {
  //   _userSubscription.cancel();
  //   return super.close();
  // }
}
