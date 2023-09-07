import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../notifiers/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  'Sign Up',
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
                hintText: 'Username',
              ),
              controller: _usernameController,
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
                    print(
                        '${_emailController.value.text}//${_passwordController.value.text}');
                  },
                  child: const Text('Have an account? Login!'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final auth = context.read<Auth>();
                    final router = GoRouter.of(context);
                    final messenger = ScaffoldMessenger.of(context);
                    String error = '';

                    try {
                      await auth.signUp(
                        email: _emailController.value.text,
                        username: _usernameController.value.text,
                        password: _passwordController.value.text,
                      );
                      print(auth.user?.email);
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
                  child: const Text('Sign Up'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
