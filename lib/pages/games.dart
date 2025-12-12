import 'package:flutter/material.dart';

class Games extends StatefulWidget {
  final String categorie;
  const Games({super.key, required this.categorie});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  int _selectedGameIndex = -1; 

  
  final List<String> _games = [
  
    "Death Stranding 2: On The Beach",
    "DOOM: The Dark Ages",

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categorie.toUpperCase()),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E1E1E), Colors.black],
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _games.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedGameIndex == index;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGameIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.only(bottom: 15),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.amber[800] : Color(0xFF2C2C2C),
                        borderRadius: BorderRadius.circular(15),
                        border: isSelected 
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                        boxShadow: [
                          if(isSelected)
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 2
                            )
                        ]
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _games[index],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.black : Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle, color: Colors.black)
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
            

            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                _selectedGameIndex == -1 
                    ? "Toque em um jogo para votar" 
                    : "Voto confirmado em:\n${_games[_selectedGameIndex]}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _selectedGameIndex == -1 ? Colors.grey : Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}