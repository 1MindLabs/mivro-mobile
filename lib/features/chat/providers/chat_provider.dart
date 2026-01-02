import 'dart:convert';
import 'dart:io';

import 'package:mivro/features/chat/models/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mivro/core/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatsNotifier extends Notifier<List<dynamic>> {
  @override
  List<dynamic> build() => [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Message?> getResponse(String prompt) async {
    try {
      _isLoading = true;
      state = [...state];

      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';
      final password = prefs.getString('password') ?? '';

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/ai/savora'),
        headers: {
          'Mivro-Email': email,
          'Mivro-Password': password,
          'Content-Type': 'application/json',
        },
        body: json.encode({"type": "text", "message": prompt}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final chat = Message(text: data['response'], isUser: false);

        _isLoading = false;
        state = [...state, chat];
        return chat;
      }

      return null;
    } catch (e) {
      _isLoading = false;
      return null;
    }
  }

  Future<Message?> getResponseHavingImage(String prompt, File file) async {
    try {
      _isLoading = true;
      state = [...state];

      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';
      final password = prefs.getString('password') ?? '';

      final request =
          http.MultipartRequest(
              'POST',
              Uri.parse('${ApiConstants.baseUrl}/ai/savora'),
            )
            ..headers.addAll({
              'Mivro-Email': email,
              'Mivro-Password': password,
              'Content-Type': 'multipart/form-data',
            })
            ..fields['message'] = prompt
            ..fields['type'] = 'media'
            ..files.add(await http.MultipartFile.fromPath('media', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final data = json.decode(await response.stream.bytesToString());
        final chat = Message(text: data['response'], isUser: false);

        _isLoading = false;
        state = [...state, chat];
        return chat;
      }

      return null;
    } catch (e) {
      _isLoading = false;
      return null;
    }
  }
}

final chatsProvider = NotifierProvider<ChatsNotifier, List<dynamic>>(
  ChatsNotifier.new,
);
