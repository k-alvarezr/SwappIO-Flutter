import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String price;

  const ProductCard(this.title, this.price, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(child: Container(color: Colors.grey[300])),
          Text(title),
          Text(price),
        ],
      ),
    );
  }
}