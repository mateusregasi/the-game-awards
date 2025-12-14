import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thegameawards/pages/home.dart';
import 'package:thegameawards/pages/categoriemoderator.dart';
import 'package:thegameawards/pages/gamesmoderator.dart';
import 'package:thegameawards/pages/votes_dashboard.dart';

class InterfaceModerator extends StatefulWidget {
  const InterfaceModerator({super.key});

  @override
  State<InterfaceModerator> createState() => _InterfaceModeratorState();
}

class _InterfaceModeratorState extends State<InterfaceModerator> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const CategorieModerator(),
    const GamesModerator(), // Jogos (CRUD) limpo
    const VotesDashboard(), // Nova tela de Votos
  ];

  // Títulos dinâmicos para a AppBar
  final List<String> _titles = [
    "GERIR CATEGORIAS",
    "GERIR JOGOS",
    "RELATÓRIO DE VOTOS"
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Home()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.amber[800]),
        titleTextStyle: TextStyle(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout, color: Colors.redAccent),
            tooltip: "Sair",
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E003E), Colors.black],
          ),
        ),
        child: SafeArea(
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xFF1E1E1E),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.white38,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: "Categorias",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.gamepad),
              label: "Jogos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), 
              label: "Votos",
            ),
          ],
        ),
      ),
    );
  }
}