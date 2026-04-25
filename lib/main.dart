import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'view/AppThemeView.dart';
import 'view/shared/AppRoutesView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SwapioApp());
}

class SwapioApp extends StatelessWidget {
  const SwapioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swapio',
      theme: AppThemeView.lightTheme,
      initialRoute: AppRoutesView.initialRoute,
      onGenerateRoute: AppRoutesView.onGenerateRoute,
    );
  }
}


