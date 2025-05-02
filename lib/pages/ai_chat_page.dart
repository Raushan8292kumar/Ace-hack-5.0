import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';

class AiChatPage extends StatefulWidget {
  final String title;
  const AiChatPage({super.key, required this.title});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final Gemini indianGov = Gemini.instance;
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText speechToText = stt.SpeechToText();
  final translator = GoogleTranslator();

  final ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  final ChatUser aiUser = ChatUser(
    id: "1",
    firstName: "Sarkar AI",
    profileImage: "assets/images/image-06.jpg",
  );

  List<ChatMessage> messages = [];
  ChatMessage? typingIndicator;
  bool isListening = false;

 List<Map<String, String>> availableLanguages = [
  {'code': 'hi-IN', 'name': 'Hindi (India)'},
  {'code': 'en-IN', 'name': 'English (India)'},
  {'code': 'ta-IN', 'name': 'Tamil (India)'},
  {'code': 'te-IN', 'name': 'Telugu (India)'},
  {'code': 'kn-IN', 'name': 'Kannada (India)'},
  {'code': 'pa-IN', 'name': 'Punjabi (India)'},
  {'code': 'bho-IN', 'name': 'Bhojpuri (India)'},
  {'code': 'mr-IN', 'name': 'Marathi (India)'},
  {'code': 'gu-IN', 'name': 'Gujarati (India)'},
  {'code': 'ml-IN', 'name': 'Malayalam (India)'},
  {'code': 'bn-IN', 'name': 'Bengali (India)'},
  {'code': 'as-IN', 'name': 'Assamese (India)'},
  {'code': 'or-IN', 'name': 'Odia (India)'},
  {'code': 'ks-IN', 'name': 'Kashmiri (India)'},
  {'code': 'sa-IN', 'name': 'Sanskrit (India)'},
  {'code': 'mwr-IN', 'name': 'Marwari (India)'},
];

  String selectedLanguageCode = 'hi-IN';

  @override
  void initState() {
    super.initState();
    _initTts();
    _initSpeech();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage(selectedLanguageCode);
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _initSpeech() async {
    await speechToText.initialize();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Sarkar AI - ${widget.title}",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              currentUser: currentUser,
              onSend: _sendMessage,
              messages: messages,
              messageOptions: MessageOptions(
                currentUserContainerColor: Colors.teal.shade700,
                containerColor: Colors.grey.shade600,
                textColor: Colors.white,
                borderRadius: 12,
                showOtherUsersName: true,
                showTime: true,
              ),
              inputOptions: InputOptions(
                inputDecoration: InputDecoration(
                  hintText: "Type your message...",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                alwaysShowSend: true,
                trailing: [
                  IconButton(
                    icon: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: isListening ? Colors.red : Colors.teal,
                    ),
                    tooltip: "Voice Input",
                    onPressed: _listenToVoice,
                  ),
                  IconButton(
                    icon: Icon(Icons.volume_up, color: Colors.blue),
                    tooltip: "Speak AI Response",
                    onPressed: _speakLastAIResponse,
                  ),
                  IconButton(
                    icon: Icon(Icons.language, color: Colors.deepPurple),
                    tooltip: "Change Language",
                    onPressed: _showLanguageDialog,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _listenToVoice() async {
    if (!isListening) {
      bool available = await speechToText.initialize();
      if (available) {
        setState(() => isListening = true);
        speechToText.listen(
          onResult: (result) {
            if (result.finalResult) {
              setState(() => isListening = false);
              final spokenText = result.recognizedWords;
              _sendMessage(ChatMessage(
                user: currentUser,
                createdAt: DateTime.now(),
                text: spokenText,
              ));
            }
          },
        );
      }
    } else {
      speechToText.stop();
      setState(() => isListening = false);
    }
  }

  void _speakLastAIResponse() async {
    if (messages.isNotEmpty) {
      final lastAIResponse = messages.firstWhere(
        (message) => message.user.id == aiUser.id,
        orElse: () => ChatMessage(user: aiUser, createdAt: DateTime.now(), text: ''),
      );

      if (lastAIResponse.text.isNotEmpty) {
        await flutterTts.setLanguage(selectedLanguageCode);
        await flutterTts.speak(lastAIResponse.text);
      }
    }
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages.insert(0, chatMessage);
      typingIndicator = ChatMessage(
        user: aiUser,
        createdAt: DateTime.now(),
        text: "Typing...",
      );
      messages.insert(0, typingIndicator!);
    });

    indianGov.streamGenerateContent(chatMessage.text).listen(
      (event) async {
        final responseText = event.content?.parts
                ?.whereType<TextPart>()
                .map((part) => part.text)
                .join(" ") ??
            "";

        final translated = await _translateToSelectedLanguage(responseText);

        final aiMessage = ChatMessage(
          user: aiUser,
          createdAt: DateTime.now(),
          text: translated,
        );

        setState(() {
          messages.remove(typingIndicator);
          messages.insert(0, aiMessage);
        });

        await flutterTts.setLanguage(selectedLanguageCode);
        await flutterTts.speak(aiMessage.text);
      },
      onError: (error) {
        _handleError(error.toString());
      },
    );
  }

  Future<String> _translateToSelectedLanguage(String text) async {
    final lines = text.trim().split('\n').where((line) => line.trim().isNotEmpty);
    final translatedLines = <String>[];

    final langCode = selectedLanguageCode.split('-').first;

    for (final line in lines) {
      try {
        final translation = await translator.translate(line.trim(), to: langCode);
        translatedLines.add(translation.text);
      } catch (e) {
        translatedLines.add(line);
      }
    }

    return translatedLines.join('\n');
  }

  void _handleError(String errorMessage) {
    print("Error: $errorMessage");
    setState(() {
      messages.remove(typingIndicator);
    });
    _showError("कुछ गलत हो गया। कृपया पुनः प्रयास करें।");
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('टीटीएस भाषा चुनें'),
          content: SingleChildScrollView(
            child: Column(
              children: availableLanguages.map((lang) {
                final isSelected = selectedLanguageCode == lang['code'];
                return ListTile(
                  title: Text(lang['name']!),
                  trailing: isSelected ? Icon(Icons.check, color: Colors.green) : null,
                  onTap: () {
                    setState(() {
                      selectedLanguageCode = lang['code']!;
                      flutterTts.setLanguage(selectedLanguageCode);
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
