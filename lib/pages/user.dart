import 'package:flutter/material.dart';
import 'categories.dart';
import "../view/interface.dart";
import '../utils/conf.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Interface(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Categories(),
        ),
      ),
      title: "Categorias",
    );
  }
}