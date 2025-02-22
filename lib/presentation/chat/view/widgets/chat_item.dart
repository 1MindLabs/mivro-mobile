import 'dart:developer';

import 'package:mivro/presentation/auth/provider/user_details_provider.dart';
import 'package:mivro/presentation/chat/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mivro/utils/hexcolor.dart';

class ChatItem extends ConsumerWidget {
  final Message message;
  const ChatItem({super.key, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = MediaQuery.of(context).size.width;
    AuthState user = ref.watch(authProvider);
    String username = user.email?.split("@").first ?? "User";
    log(username);

    return Container(
      padding: const EdgeInsets.all(8),
      child: message.isUser
          ? Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/icons/user.png'),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: myColorFromHex('#95D2B3'),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      border: Border.all(
                          color: myColorFromHex('#0D7377'), width: 2),
                    ),
                    alignment: Alignment.topRight,
                    constraints: BoxConstraints(
                      maxWidth: width * 2 / 3,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (message.image != null)
                            Image.file(message.image!, width: 100, height: 100),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              message.text,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : message.text == 'Hello @$username! How can I help you?'
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    alignment: Alignment.topLeft,
                    constraints: BoxConstraints(
                      maxWidth: width * 2 / 3,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              message.text,
                              style: const TextStyle(
                                  fontSize: 32, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/icons/bot.png'),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: myColorFromHex('#EEF1FF'),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          border: Border.all(
                              color: myColorFromHex('#0D7377'), width: 2),
                        ),
                        alignment: Alignment.topLeft,
                        constraints: BoxConstraints(
                          maxWidth: width * 4 / 5,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  message.text,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
