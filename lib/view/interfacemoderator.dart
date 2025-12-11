import 'package:flutter/material.dart';
import 'package:thegameawards/pages/categoriemoderator.dart';
import 'package:thegameawards/pages/categories.dart';
import 'package:thegameawards/pages/gamesmoderator.dart';
import 'package:thegameawards/utils/conf.dart';

class InterfaceModerator extends StatefulWidget {
  String title;
  InterfaceModerator({super.key, required this.title});

  @override
  State<InterfaceModerator> createState() => _InterfaceModeratorState();
}

class _InterfaceModeratorState extends State<InterfaceModerator> {
  int _page = 0;
  List<Widget> _pages = [
    Categories(),
    GamesModerator(),
    CategorieModerator(),
  ];

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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote_outlined),
            label: "Votação",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: "Jogos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Categorias",
          ),
        ],
        currentIndex: _page,
        onTap: (value){
          setState(() {
            _page = value;
          });
        },
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: _pages[_page],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}