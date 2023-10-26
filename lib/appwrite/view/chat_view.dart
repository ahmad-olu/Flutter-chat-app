import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/appwrite/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_chat_app/appwrite/bloc/chat_bloc/chat_bloc.dart';
import 'package:flutter_chat_app/appwrite/model/chat.dart';
import 'package:flutter_chat_app/appwrite/repo/db_repo.dart';
import 'package:flutter_chat_app/appwrite/repo/realtime.dart';
import 'package:flutter_chat_app/appwrite/view/login_and_register_page.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chatUi;

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        context.read<DbRepo>(),
        context.read<RealRepo>(),
      )..add(GetAllChat()),
      child: const ChatView(),
    );
  }
}

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const LoginAndRegisterPage(),
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 3),
                content: Text('Logged Out...'),
              ),
            );
        }
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          final currentUser = context.watch<AuthBloc>().state.user;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Chat Page'),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () => context
                        .read<AuthBloc>()
                        .add(const AppLogoutRequested()),
                    icon: const Icon(Icons.exit_to_app_sharp))
              ],
            ),
            //body: const Center(child: Text('Chat View')),
            body: chatUi.Chat(
              messages: state.chats
                  .map((chat) => types.TextMessage(
                        author: types.User(
                          id: chat.userId,
                          firstName: chat.name,
                        ),
                        //createdAt: int.parse(chat.createdAt!.day.toString()),
                        id: chat.id!,
                        text: chat.message,
                      ))
                  .toList(),
              user: types.User(id: currentUser!.$id),
              onSendPressed: (p0) {
                final chat = Chat(
                  userId: currentUser.$id,
                  name: currentUser.name,
                  message: p0.text,
                );
                context.read<ChatBloc>().add(AddChat(chat: chat));
              },
              showUserNames: true,
              //dateHeaderBuilder: (p0) => Text(p0.text),
              showUserAvatars: true,

              theme: chatUi.DefaultChatTheme(
                backgroundColor: theme.scaffoldBackgroundColor,
                primaryColor: theme.colorScheme.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}
