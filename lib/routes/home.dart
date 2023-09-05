import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pluck_mobile/notifiers/auth.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () async {
              final auth = context.read<Auth>();
              final router = GoRouter.of(context);
              await auth.signOut();

              // print('canPop?: ${router.canPop()}');
              // while (router.canPop()) {
              //   print('popping');
              //   router.pop();
              // }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Placeholder(),
    );
  }
}
