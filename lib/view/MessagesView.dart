import 'package:flutter/material.dart';
import 'shared/BottomNavView.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

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
      bottomNavigationBar: const BottomNavView(index: 3),
    );
  }
}



