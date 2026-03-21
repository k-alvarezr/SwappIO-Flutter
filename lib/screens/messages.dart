import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mensajes")),
      body: ListView(
        children: const [
          ListTile(title: Text("Camila"), subtitle: Text("Hola")),
          ListTile(title: Text("Diego"), subtitle: Text("Oferta")),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(index: 3),
    );
  }
}
