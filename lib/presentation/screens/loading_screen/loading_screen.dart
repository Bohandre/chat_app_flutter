import 'package:chat_app/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: FutureBuilder(
        future: ref.read(authProvider.notifier).checkAuthStatus(),
        builder: (context, snapshot) {
          // print('${snapshot.hasData} ${snapshot.data}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Validando información...'),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => context.go('/users'));
            } else {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => context.go('/login'));
            }
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
