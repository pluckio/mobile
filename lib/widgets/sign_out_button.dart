import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../notifiers/auth.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final auth = context.read<Auth>();
        final router = GoRouter.of(context);
        await auth.signOut();

        while (router.canPop()) {
          router.pop();
        }
      },
      icon: const Icon(Icons.logout),
    );
  }
}
