import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/appwrite/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_chat_app/appwrite/bloc/chat_bloc/chat_bloc.dart';
import 'package:flutter_chat_app/appwrite/repo/auth_repo.dart';
import 'package:flutter_chat_app/appwrite/repo/db_repo.dart';
import 'package:flutter_chat_app/appwrite/repo/realtime.dart';

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
            ),
          ),
          BlocProvider(
            create: (context) => ChatBloc(),
          ),
        ],
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            log('------> $state');
          },
          child: const Scaffold(
            body: Center(child: Text('Appwrite')),
          ),
        ),
      ),
    );
  }
}
