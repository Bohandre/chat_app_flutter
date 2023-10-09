import 'package:chat_app/config/config.dart';
import 'package:chat_app/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessage extends ConsumerWidget {
  final String text;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    super.key,
    required this.text,
    required this.uid,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
        child: Container(
          child: uid == '123'
              ? MyMessage(
                  message: text,
                  uid: uid,
                )
              : IncomingMessage(
                  message: text,
                  uid: uid,
                ),
        ),
      ),
    );
  }
}

class MyMessage extends ConsumerWidget {
  final String message;
  final String uid;

  const MyMessage({super.key, required this.message, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final themeChanger = ref.watch(themeNotifierProvider);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(size.width * .03),
        margin: EdgeInsets.only(
          bottom: size.height * .005,
          left: size.width * .2,
          right: size.width * .02,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          color:
              themeChanger.isDarkMode ? Colors.indigo[800] : Colors.indigo[200],
        ),
        child: Text(
          message,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: AppTheme.poppinsRegular,
            fontSize: size.width * .03,
          ),
        ),
      ),
    );
  }
}

class IncomingMessage extends ConsumerWidget {
  final String message;
  final String uid;

  const IncomingMessage({super.key, required this.message, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeChanger = ref.watch(themeNotifierProvider);
    final size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(size.width * .03),
        margin: EdgeInsets.only(
          bottom: size.height * .005,
          left: size.width * .02,
          right: size.width * .2,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          color: themeChanger.isDarkMode ? Colors.grey[800] : Colors.grey[400],
        ),
        child: Text(
          message,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: AppTheme.poppinsRegular,
            fontSize: size.width * .03,
          ),
        ),
      ),
    );
  }
}
