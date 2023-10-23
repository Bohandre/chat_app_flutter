import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat_app/presentation/providers/providers.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socketProvider = ref.watch(socketServiceProvider);

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
              socketProvider.connect();
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
