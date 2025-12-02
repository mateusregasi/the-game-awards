import 'package:flutter/material.dart';
import '../utils/conf.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.white, 
          child: Text("The Game Awards"),
        ),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30
        ),
        backgroundColor: Conf.primaryColor,
        foregroundColor: Colors.white, 
      ),
    );
  }
}