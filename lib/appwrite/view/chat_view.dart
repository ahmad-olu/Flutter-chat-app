import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/appwrite/bloc/chat_bloc/chat_bloc.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return const Scaffold(
          body: Center(child: Text('Chat View')),
        );
      },
    );
  }
}
