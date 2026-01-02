import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:mivro/features/auth/providers/user_details_provider.dart';
import 'package:mivro/features/chat/models/message.dart';
import 'package:mivro/features/chat/providers/chat_history_provider.dart';
import 'package:mivro/features/chat/providers/chat_provider.dart';
import 'package:mivro/features/chat/widgets/chat_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mivro/core/hex_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final _userMessage = TextEditingController();
  final _scrollController = ScrollController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool isFetching = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    Future.microtask(() => extractUsername());
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {},
      onError: (error) {},
    );
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(
        onResult: (val) => setState(() {
          _recognizedText = val.recognizedWords;
          _userMessage.text = _recognizedText;
        }),
      );
    }
  }

  Future<void> extractUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email') ?? '';
    String? password = prefs.getString('password') ?? '';

    ref.read(authProvider.notifier).updateCredentials(email, password);
    String username = email.split("@").first;
    ref.read(chatHistoriesProvider.notifier).getHistory(username);
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  void sendPromptAndGetResponse() async {
    FocusScope.of(context).unfocus();
    AuthState user = ref.watch(authProvider);
    String username = user.email.split("@").first;
    var userPrompt = _userMessage.text;
    _userMessage.clear();

    if (_selectedImage == null) {
      setState(() {
        ref
            .read(chatHistoriesProvider.notifier)
            .addMessage(username, Message(text: userPrompt, isUser: true));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      });
      setState(() {
        isFetching = true;
      });
      var responseMessage = await ref
          .read(chatsProvider.notifier)
          .getResponse(userPrompt);

      setState(() {
        isFetching = false;
        if (responseMessage != null) {
          ref
              .read(chatHistoriesProvider.notifier)
              .addMessage(username, responseMessage);
        }
      });
    } else {
      setState(() {
        ref
            .read(chatHistoriesProvider.notifier)
            .addMessage(
              username,
              Message(text: userPrompt, isUser: true, image: _selectedImage),
            );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      });
      var responseMessage = await ref
          .read(chatsProvider.notifier)
          .getResponseHavingImage(userPrompt, _selectedImage!);
      setState(() {
        _selectedImage = null;
        if (responseMessage != null) {
          ref
              .read(chatHistoriesProvider.notifier)
              .addMessage(username, responseMessage);
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> pickImage({required ImageSource source}) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthState user = ref.watch(authProvider);
    String username = user.email.split("@").first;

    List<Message> messages = ref.watch(chatHistoryProvider(username));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, idx) {
                  if (idx < messages.length) {
                    return ChatItem(message: messages[idx]);
                  } else if (isFetching) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const SizedBox.shrink();
                  }
                },
                separatorBuilder: (context, idx) =>
                    const Padding(padding: EdgeInsets.only(top: 10)),
                itemCount: messages.length,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ).copyWith(bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
                color: myColorFromHex('#EEF1FF'),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _selectedImage != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Image.file(
                                _selectedImage!,
                                width: 100,
                                height: 100,
                              ),
                              Positioned(
                                left: 60,
                                top: 0,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedImage = null;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    shadows: [Shadow(color: Colors.black)],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Message...',
                            labelStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: myColorFromHex('#EEF1FF'),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.text,
                          controller: _userMessage,
                        ),
                      ),
                      PopupMenuButton(
                        icon: const Icon(Icons.attach_file_outlined),
                        onSelected: (ImageSource source) {
                          pickImage(source: source);
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: ImageSource.gallery,
                            child: Text('Select from Gallery'),
                          ),
                          const PopupMenuItem(
                            value: ImageSource.camera,
                            child: Text('Take a Photo'),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: _isListening
                            ? _stopListening
                            : _startListening,
                        icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                      ),
                      IconButton(
                        onPressed: sendPromptAndGetResponse,
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
