import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/appwrite/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_chat_app/appwrite/bloc/chat_bloc/chat_bloc.dart';
import 'package:flutter_chat_app/appwrite/repo/auth_repo.dart';
import 'package:flutter_chat_app/appwrite/repo/db_repo.dart';
import 'package:flutter_chat_app/appwrite/repo/realtime.dart';
import 'package:flutter_chat_app/appwrite/view/chat_view.dart';
import 'package:flutter_chat_app/appwrite/view/login_and_register_page.dart';

class AppWriteMain extends StatelessWidget {
  const AppWriteMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => RealRepo(),
        ),
        RepositoryProvider(
          create: (context) => AuthRepo(),
        ),
        RepositoryProvider(
          create: (context) => DbRepo(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepo>(),
              realTimeRepository: context.read<RealRepo>(),
            )..add(const AppUserChanged()),
          ),
        ],
        child: const SplashPage(),
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return const ChatPage();
        } else if (state.status == AuthStatus.unauthenticated) {
          return const LoginAndRegisterPage();
        } else {
          return const Scaffold(
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Loading...'),
                CircularProgressIndicator(),
              ],
            )),
          );
        }
      },
    );
  }
}
