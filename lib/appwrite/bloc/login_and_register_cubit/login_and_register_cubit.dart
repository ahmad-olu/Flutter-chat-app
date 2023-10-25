import 'package:appwrite/appwrite.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_app/appwrite/repo/auth_repo.dart';

part 'login_and_register_state.dart';

class LoginAndRegisterCubit extends Cubit<LoginAndRegisterState> {
  LoginAndRegisterCubit({required this.authRepository})
      : super(LoginAndRegisterState.initial());
  final AuthRepo authRepository;

  void setName(String value) {
    emit(state.copyWith(name: value));
  }

  void setEmail(String value) {
    emit(state.copyWith(email: value));
  }

  void setPassword(String value) {
    emit(state.copyWith(password: value));
  }

  void login() async {
    emit(state.copyWith(status: LoginAndRegisterStatus.submitting));
    try {
      await authRepository.login(email: state.email, password: state.password);
      emit(state.copyWith(status: LoginAndRegisterStatus.submitted));
    } on AppwriteException catch (e, _) {
      emit(state.copyWith(
        status: LoginAndRegisterStatus.error,
        exception: "status code:${e.code} \n message:${e.message}",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoginAndRegisterStatus.error,
        exception: null,
      ));
    }
  }

  void register() async {
    emit(state.copyWith(status: LoginAndRegisterStatus.submitting));
    try {
      await authRepository.signUp(
          name: state.name, email: state.email, password: state.password);
      emit(state.copyWith(status: LoginAndRegisterStatus.submitted));
    } on AppwriteException catch (e, _) {
      emit(state.copyWith(
        status: LoginAndRegisterStatus.error,
        exception: "status code:${e.code} \n message:${e.message}",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoginAndRegisterStatus.error,
        exception: null,
      ));
    }
  }

  void initialState() {
    emit(LoginAndRegisterState.initial());
  }
}
