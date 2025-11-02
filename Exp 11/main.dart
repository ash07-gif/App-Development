import 'package:flutter/material.dart';
import 'food_list_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food API Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const FoodListScreen(),
    );
  }
}
