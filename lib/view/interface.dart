import 'package:flutter/material.dart';
import "../utils/conf.dart";

class Interface extends StatefulWidget {
  final Widget body;
  String title;
  Interface({super.key, required this.body, required this.title});

  @override
  State<Interface> createState() => _InterfaceState();
}

class _InterfaceState extends State<Interface> {

  @override
  Widget build(BuildContext context) {
    print(widget.title);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Title(
            color: Colors.white, 
            child: Text(widget.title),
          ),
        ),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
        backgroundColor: Conf.primaryColor,
        foregroundColor: Colors.white, 
      ),
      body: widget.body,
      bottomNavigationBar: BottomAppBar(
        color: Conf.primaryColor,
        height: 40,
      ),
    );
  }
}