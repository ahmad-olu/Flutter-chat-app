import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/appwrite/bloc/login_and_register_cubit/login_and_register_cubit.dart';
import 'package:flutter_chat_app/appwrite/repo/auth_repo.dart';

class LoginAndRegisterPage extends StatelessWidget {
  const LoginAndRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginAndRegisterCubit(authRepository: context.read<AuthRepo>()),
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
        return Form(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'name',
                ),
                onChanged: (value) =>
                    context.read<LoginAndRegisterCubit>().setName(value),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'email',
                ),
                onChanged: (value) =>
                    context.read<LoginAndRegisterCubit>().setEmail(value),
              ),
              const SizedBox(height: 8),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'password',
                ),
                onChanged: (value) =>
                    context.read<LoginAndRegisterCubit>().setPassword(value),
              ),
              const SizedBox(height: 8),
              state.status == LoginAndRegisterStatus.submitting
                  ? const CircularProgressIndicator()
                  : Row(
                      children: [
                        TextButton(
                            onPressed: () =>
                                context.read<LoginAndRegisterCubit>().login(),
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
        ));
      },
    );
  }
}
