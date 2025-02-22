import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:mivro/presentation/auth/provider/user_details_provider.dart';
import 'package:mivro/presentation/chat/model/message.dart';
import 'package:mivro/presentation/chat/provider/chat_history_provider.dart';
import 'package:mivro/presentation/chat/provider/chat_provider.dart';
import 'package:mivro/presentation/chat/view/widgets/chat_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mivro/utils/hexcolor.dart';
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

  // Speech-to-text instance
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    Future.microtask(() => extractUsername());
  }

  // Start listening to speech and convert it to text
  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(
        onResult: (val) => setState(() {
          _recognizedText = val.recognizedWords;
          _userMessage.text =
              _recognizedText; // Set recognized text to the input field
        }),
      );
    }
  }

  Future<void> extractUsername() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email') ?? 'areeb@gmail.com';
    log('email: $email');
    String? password = prefs.getString('password')?? 'test@1';
    log('password: $password');

    ref.read(authProvider.notifier).updateCredentials(email, password);
    String username = email?.split("@").first ?? "User";
    log('after extracting username: $username');
    ref.read(chatHistoryProvider(username).notifier);
  }

  // Stop listening to speech
  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  void sendPromptAndGetResponse() async {
    FocusScope.of(context).unfocus();
    AuthState user = ref.watch(authProvider);
    String username = user.email?.split("@").first ?? "User";
    log('username rishi: $username');
    var userPrompt = _userMessage.text;
    _userMessage.clear();
    log('in send prompt');

    if (_selectedImage == null) {
      setState(() {
        ref
            .read(chatHistoryProvider(username).notifier)
            .addMessage(Message(text: userPrompt, isUser: true));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      });
      log(userPrompt);
      setState(() {
        isFetching = true;
      });
      var responseMessage =
          await ref.read(chatsProvider.notifier).getResponse(userPrompt);

      log(responseMessage!.text);
      setState(() {
        isFetching = false;
        ref.read(chatHistoryProvider(username).notifier).addMessage(responseMessage);
      });
    } else {
      setState(() {
        ref.read(chatHistoryProvider(username).notifier).addMessage(
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
      log(userPrompt);
      var responseMessage = await ref
          .read(chatsProvider.notifier)
          .getResponseHavingImage(userPrompt, _selectedImage!);
      log(responseMessage!.text);
      setState(() {
        _selectedImage = null;
        ref.read(chatHistoryProvider(username).notifier).addMessage(responseMessage);
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
    final isLoading = ref.watch(chatsProvider.notifier).isLoading;

    AuthState user = ref.watch(authProvider);
    String username = user.email?.split("@").first ?? "User";
    log('after extracting username: $username');

    List<Message> messages = ref.watch(chatHistoryProvider(username));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
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
                    itemCount: messages.length),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16)
                  .copyWith(bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
                color: myColorFromHex('#EEF1FF'),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _selectedImage != null
                      ? Padding(
                          // alignment: Alignment.centerLeft,
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
                              border: InputBorder.none),
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
                        onPressed:
                            _isListening ? _stopListening : _startListening,
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
            )
          ],
        ),
      ),
    );
  }
}
