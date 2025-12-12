import 'package:flutter/material.dart';
import 'package:thegameawards/view/interfacemoderator.dart';

class Moderator extends StatefulWidget {
  const Moderator({super.key});

  @override
  State<Moderator> createState() => _ModeratorState();
}

class _ModeratorState extends State<Moderator> {
  @override
  Widget build(BuildContext context) {
    return InterfaceModerator( 
      title: "Categorias"
    );
  }
}