import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/donate.dart';
import 'screens/list_item.dart';
import 'screens/messages.dart';
import 'screens/profile.dart';
import 'screens/purchase_history.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swappio',
      theme: ThemeData(
        fontFamily: 'Plus Jakarta Sans',
        scaffoldBackgroundColor: const Color(0xFFF5F8F8),
      ),
      routes: {
        '/': (_) => const HomeScreen(),
        '/donate': (_) => const DonateScreen(),
        '/sell': (_) => const ListItemScreen(),
        '/messages': (_) => const MessagesScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/purchases': (_) => const PurchaseHistoryScreen(),
      },
    );
  }
}
