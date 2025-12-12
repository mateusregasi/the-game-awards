import 'package:flutter/material.dart';
import 'package:thegameawards/pages/categoriemoderator.dart';
import 'package:thegameawards/pages/categories.dart';
import 'package:thegameawards/pages/gamesmoderator.dart';
// import 'package:thegameawards/utils/conf.dart'; // Não precisa mais

class InterfaceModerator extends StatefulWidget {
  final String title;
  const InterfaceModerator({super.key, required this.title});

  @override
  State<InterfaceModerator> createState() => _InterfaceModeratorState();
}

class _InterfaceModeratorState extends State<InterfaceModerator> {
  int _page = 0;
  
  
  final List<Widget> _pages = [
    Categories(),       
    GamesModerator(),   
    CategorieModerator(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
     
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E1E1E), Colors.black],
          ),
        ),
        child: _pages[_page],
      ),
      
    
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10, width: 1))
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black, 
          selectedItemColor: Colors.amber[800], 
          unselectedItemColor: Colors.grey[600], 
          currentIndex: _page,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed, 
          onTap: (value) {
            setState(() {
              _page = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.how_to_vote_outlined),
              activeIcon: Icon(Icons.how_to_vote),
              label: "Votação",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.gamepad_outlined),
              activeIcon: Icon(Icons.gamepad),
              label: "Gerenciar Jogos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: "Gerenciar Cat.",
            ),
          ],
        ),
      ),
    );
  }
}