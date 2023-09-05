import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'constants.dart';
import 'notifiers/auth.dart';
import 'notifiers/photos.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final client = Client().setEndpoint(Appwrite.endpoint).setProject(
        Appwrite.project,
      );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (context) => Auth(client)),
        ChangeNotifierProvider<Photos>(create: (context) {
          final auth = context.read<Auth>();
          return Photos(client: client, auth: auth);
        }),
      ],
      child: const App(),
    ),
  );
}
