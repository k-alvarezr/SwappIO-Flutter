import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int index;

  const CustomBottomNav({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "Sell"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Inbox"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}