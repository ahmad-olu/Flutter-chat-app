import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/appwrite/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_chat_app/appwrite/bloc/login_and_register_cubit/login_and_register_cubit.dart';
import 'package:flutter_chat_app/appwrite/repo/auth_repo.dart';
import 'package:flutter_chat_app/appwrite/repo/realtime.dart';
import 'package:flutter_chat_app/appwrite/view/chat_view.dart';

class LoginAndRegisterPage extends StatelessWidget {
  const LoginAndRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<AuthBloc>(context),
        ),
        BlocProvider(
          create: (context) =>
              LoginAndRegisterCubit(authRepository: context.read<AuthRepo>()),
        ),
      ],
      child: const LoginAndRegisterForm(),
    );
  }
}

class LoginAndRegisterForm extends StatelessWidget {
  const LoginAndRegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginAndRegisterCubit, LoginAndRegisterState>(
      listener: (context, state) {
        if (state.status == LoginAndRegisterStatus.submitted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const ChatPage(),
              ),
              (route) => false);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 3),
                content: Text('Welcome...'),
              ),
            );
        }
        if (state.status == LoginAndRegisterStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.exceptionMessage ?? "Error Occurred"),
              ),
            );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Form(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  TextField(
                    enabled: state.status != LoginAndRegisterStatus.submitting,
                    decoration: const InputDecoration(
                      labelText: 'name',
                    ),
                    onChanged: (value) =>
                        context.read<LoginAndRegisterCubit>().setName(value),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    enabled: state.status != LoginAndRegisterStatus.submitting,
                    decoration: const InputDecoration(
                      labelText: 'email',
                    ),
                    onChanged: (value) =>
                        context.read<LoginAndRegisterCubit>().setEmail(value),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    enabled: state.status != LoginAndRegisterStatus.submitting,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'password',
                    ),
                    onChanged: (value) => context
                        .read<LoginAndRegisterCubit>()
                        .setPassword(value),
                  ),
                  const SizedBox(height: 8),
                  state.status == LoginAndRegisterStatus.submitting
                      ? const CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () => context
                                    .read<LoginAndRegisterCubit>()
                                    .login(),
                                child: const Text('Sign In')),
                            ElevatedButton(
                                onPressed: () => context
                                    .read<LoginAndRegisterCubit>()
                                    .register(),
                                child: const Text('Register')),
                          ],
                        ),
                ],
              ),
            )),
          ),
        );
      },
    );
  }
}
