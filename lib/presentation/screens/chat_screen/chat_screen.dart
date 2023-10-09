// ignore_for_file: avoid_print

import 'package:chat_app/config/config.dart';
import 'package:chat_app/presentation/providers/providers.dart';
import 'package:chat_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends ConsumerState<ChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController textInputController =
      TextEditingController(text: '');

  final FocusNode focusNode = FocusNode();

  bool _isWriting = false;

  final List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    final themeChangerProvider = ref.watch(themeNotifierProvider);

    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.5,
          title: Column(
            children: [
              CircleAvatar(
                maxRadius: 18,
                child: Text(
                  'An',
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsRegular,
                    fontSize: size.width * .04,
                  ),
                ),
              ),
              Text(
                'Andrés Bohorquez',
                style: TextStyle(
                  fontFamily: AppTheme.poppinsRegular,
                  fontSize: size.width * .03,
                ),
              )
            ],
          ),
        ),
        body: SizedBox(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (_, i) => _messages[i],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * .03,
                  vertical: size.height * .02,
                ),
                child: SizedBox(
                  child: SafeArea(
                    child: SizedBox(
                      width: size.width * .9,
                      child: CustomTextFormField(
                        controller: textInputController,
                        focusNode: focusNode,
                        keyboardType: TextInputType.text,
                        hint: 'Escribe un mensaje...',
                        hintStyle: TextStyle(
                          fontFamily: AppTheme.poppinsMedium,
                          fontSize: size.width * .0321,
                          color: themeChangerProvider.isDarkMode
                              ? Colors.indigo[500]
                              : Colors.grey,
                        ),
                        onFieldSubmitted: (value) {
                          _handleSubmit(value);
                        },
                        onChanged: (text) {
                          setState(() {
                            if (text.trim().isNotEmpty) {
                              _isWriting = true;
                            } else {
                              _isWriting = false;
                            }
                          });
                        },
                        suffixIcon: IconButton(
                          onPressed: _isWriting
                              ? () => _handleSubmit(textInputController.text)
                              : null,
                          icon: Icon(
                            Icons.send_outlined,
                            color: themeChangerProvider.isDarkMode
                                ? Colors.indigo[800]
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.isEmpty) return;
    print(text);
    textInputController.clear();
    focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: '123',
      text: text,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;
    });
  }

  @override
  void dispose() {
    // todo: off del socket

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
