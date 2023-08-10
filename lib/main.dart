import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:pluck_mobile/app.dart';
import 'package:pluck_mobile/notifiers/auth.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final client = Client().setEndpoint(Appwrite.endpoint).setProject(
        Appwrite.project,
      );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (_) => Auth(client)),
      ],
      child: const App(),
    ),
  );
}
