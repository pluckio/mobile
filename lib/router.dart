import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pluck_mobile/routes/sign_in.dart';
import 'package:pluck_mobile/routes/sign_up.dart';
import 'package:pluck_mobile/routes/home.dart';
import 'package:provider/provider.dart';

import 'notifiers/auth.dart';

// GoRouter configuration
final router = GoRouter(
  redirect: (BuildContext context, GoRouterState state) {
    final auth = context.read<Auth>();
    if (auth.user == null) {
      return '/signIn';
    } else {
      return null;
    }
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: '/signIn',
      builder: (context, state) => const SignIn(),
    ),
    GoRoute(
      path: '/signUp',
      builder: (context, state) => const SignUp(),
    ),
  ],
);
