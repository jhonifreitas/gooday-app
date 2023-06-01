import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:gooday/src/app.dart';
import 'package:gooday/src/firebase_options.dart';
import 'package:gooday/src/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}
