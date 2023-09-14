import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../notifiers/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isLoading = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _checkAuth() async {
    final auth = context.read<Auth>();
    final router = GoRouter.of(context);

    final futures = <Future>[];

    futures.add(auth.init().catchError((error, stackTrace) => null));

    await Future.wait(futures);

    if (auth.user != null) {
      await router.push('/');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAuth());
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final screenSize = MediaQuery.of(context).size;
    const gap = SizedBox(height: 16);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height / 4,
          horizontal: 32.0,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Sign In',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
            gap,
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email address',
              ),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            gap,
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
              controller: _passwordController,
            ),
            gap,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    debugPrint(
                        '${_emailController.value.text}//${_passwordController.value.text}');
                  },
                  child: const Text('No account? Register!'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final auth = context.read<Auth>();
                    final messenger = ScaffoldMessenger.of(context);
                    final router = GoRouter.of(context);
                    String error = '';

                    try {
                      await auth.signIn(
                        email: _emailController.value.text,
                        password: _passwordController.value.text,
                      );
                      router.push('/');
                    } on AppwriteException catch (e) {
                      error = e.message ?? 'Something went wrong!';
                    } catch (e) {
                      error = e.toString();
                    }

                    if (error.isNotEmpty) {
                      messenger.showSnackBar(SnackBar(
                        content: Text(error),
                      ));
                    }
                  },
                  child: const Text('Sign In'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
