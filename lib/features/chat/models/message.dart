import 'dart:io';

class Message {
  final String text;
  final bool isUser;
  final File? image;

  const Message({required this.text, required this.isUser, this.image});
}
