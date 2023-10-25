part of 'login_and_register_cubit.dart';

enum LoginAndRegisterStatus { initial, submitting, submitted, error }

class LoginAndRegisterState extends Equatable {
  const LoginAndRegisterState({
    this.name,
    required this.email,
    required this.password,
    required this.status,
    this.exceptionMessage,
  });
  final String? name;
  final String email;
  final String password;
  final LoginAndRegisterStatus status;
  final String? exceptionMessage;

  @override
  List<Object> get props => [email, password, status];

  // const AuthState.unauthenticated()
  //     : this._(status: AuthStatus.unauthenticated);
  factory LoginAndRegisterState.initial() => const LoginAndRegisterState(
        email: '',
        password: '',
        status: LoginAndRegisterStatus.initial,
      );

  LoginAndRegisterState copyWith({
    String? name,
    String? email,
    String? password,
    LoginAndRegisterStatus? status,
    String? exception,
  }) {
    return LoginAndRegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      exceptionMessage: exceptionMessage ?? exceptionMessage,
    );
  }

  @override
  String toString() {
    return 'LoginAndRegisterState(name: $name, email: $email, password: $password, status: $status, exceptionMessage: $exceptionMessage)';
  }
}
