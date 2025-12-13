import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thegameawards/controller/game_controller.dart';
import 'package:thegameawards/model/category.dart';
import 'package:thegameawards/model/game.dart';
import 'package:thegameawards/model/user.dart';

class Games extends StatefulWidget {
  final Category category; 
  const Games({super.key, required this.category});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  final GameController _controller = GameController();
  int _selectedGameId = -1;
  User? _currentUser;

  // LISTA ESTÁTICA COM DESCRIÇÕES EM PORTUGUÊS
  final List<Game> _staticGames = [
    Game(
      userId: 0, 
      name: "Grand Theft Auto VI", 
      description: "Retorne a Vice City na maior e mais imersiva evolução da série Grand Theft Auto até hoje.", 
      releaseDate: "2025"
    ),
    Game(
      userId: 0, 
      name: "Death Stranding 2: On The Beach", 
      description: "Sam Bridges embarca em uma nova jornada para salvar a humanidade da extinção.", 
      releaseDate: "2025"
    ),
    Game(
      userId: 0, 
      name: "Monster Hunter Wilds", 
      description: "A próxima geração da caça a monstros com ecossistemas vivos e dinâmicos.", 
      releaseDate: "2025"
    ),
    Game(
      userId: 0, 
      name: "Ghost of Yōtei", 
      description: "Uma nova lenda samurai começa nas terras do norte do Japão feudal.", 
      releaseDate: "2025"
    ),
    Game(
      userId: 0, 
      name: "Metroid Prime 4: Beyond", 
      description: "Samus Aran retorna para uma nova missão galáctica em primeira pessoa.", 
      releaseDate: "2025"
    ),
     Game(
      userId: 0, 
      name: "DOOM: The Dark Ages", 
      description: "Testemunhe a origem da fúria do Slayer em uma guerra medieval contra o Inferno.", 
      releaseDate: "2025"
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    int? uid = prefs.getInt("user_id");
    if (uid != null) {
      _currentUser = User(id: uid, name: "", password: "", email: "", role: 0);
    }
  }

  Future<List<Game>> _loadGames() async {
    // 1. Tenta buscar do banco para esta categoria
    List<Game> dbGames = await _controller.getAllByCategoryId(widget.category.id!);
    
    // 2. Se o banco estiver vazio, retorna a lista estática
    if (dbGames.isEmpty) {
      return _staticGames;
    }
    
    return dbGames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.title.toUpperCase(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ), 
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: FutureBuilder<List<Game>>(
          future: _loadGames(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.amber));
            }

            List<Game> gamesList = snapshot.data ?? _staticGames;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: gamesList.length,
                    itemBuilder: (context, index) {
                      Game game = gamesList[index];
                      // Se o jogo é estático (sem ID), usa o index negativo para diferenciar
                      int currentGameId = game.id ?? (index * -1) - 1;
                      bool isSelected = _selectedGameId == currentGameId;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGameId = currentGameId;
                          });
                          // Só vota se for jogo do banco
                          if (game.id != null && _currentUser != null) {
                             _controller.vote(_currentUser!, widget.category, game);
                          }
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      game.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.black : Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      game.description,
                                      style: TextStyle(
                                        fontSize: 13,
                                        height: 1.3, // Espaçamento entre linhas para melhor leitura
                                        color: isSelected ? Colors.black87 : Colors.grey[400],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Icon(Icons.check_circle, color: Colors.black),
                                )
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ),
                
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.white10))
                  ),
                  child: Text(
                    _selectedGameId == -1 
                        ? "Escolha seu favorito para votar" 
                        : "Voto Registrado!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedGameId == -1 ? Colors.grey : Colors.amber,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}