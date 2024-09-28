import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:mivro/presentation/chat/model/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ChatsNotifier extends StateNotifier<List<dynamic>> {
  ChatsNotifier() : super([]);
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Message?> getResponse(String prompt) async {
    try {
      log('in get response');
      _isLoading = true;
      state = [...state];
      String url = 'http://10.1.6.186:5000/api/v1/ai/savora';

      Map<String, String> body = {
        "type": "text",
        "message": prompt,
      };

      const header = <String, String>{
        'Mivro-Email': 'admin@mivro.org',
        'Mivro-Password': 'admin@123',
        'Content-Type': 'application/json',
      };

      final response = await http.post(Uri.parse(url),
          body: json.encode(body), headers: header);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        final result = data['response'];
        log(result);

        final chat = Message(text: result, isUser: false);

        state = [...state, chat];
        _isLoading = false;
        state = [...state];
        return chat;
      } else {
        log(response.body);
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<Message?> getResponseHavingImage(String prompt, File file) async {
    try {
      _isLoading = true;
      state = [...state];
      String url = 'http://10.1.6.186:5000/api/v1/ai/savora';

      const header = <String, String>{
        'Mivro-Email': 'admin@mivro.org',
        'Mivro-Password': 'admin@123',
        'Content-Type': 'multipart/form-data',
      };

      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll(header)
        ..fields['message'] = prompt
        ..fields['type'] = 'media'
        ..files.add(await http.MultipartFile.fromPath('media', file.path));

      var response = await request.send();
      log('got response');

      if (response.statusCode == 200) {
        var data = json.decode(await response.stream.bytesToString());
        final result = data['response'];
        log(result);

        final chat = Message(text: result, isUser: false);

        state = [...state, chat];
        _isLoading = false;
        state = [...state];
        return chat;
      } else {
        var data = json.decode(await response.stream.bytesToString());
        final result = data['response'];
        log(result);
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}

final chatsProvider = StateNotifierProvider<ChatsNotifier, List<dynamic>>(
    (ref) => ChatsNotifier());
