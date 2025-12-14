import 'package:flutter/material.dart';
import 'package:thegameawards/controller/game_controller.dart';
import 'package:thegameawards/model/game.dart';
import 'package:thegameawards/pages/game_form.dart'; 

class GamesModerator extends StatefulWidget {
  const GamesModerator({super.key});

  @override
  State<GamesModerator> createState() => _GamesModeratorState();
}

class _GamesModeratorState extends State<GamesModerator> {
  GameController _gameController = GameController();
  late Future<List<Game>> _gamesFuture;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _gamesFuture = _gameController.getAllGames();
    });
  }

  void _deleteGame(int id) async {
    bool confirm = await showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF2C2C2C),
        title: Text("Excluir Jogo?", style: TextStyle(color: Colors.white)),
        content: Text("Esta ação não pode ser desfeita.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancelar", style: TextStyle(color: Colors.grey))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Excluir", style: TextStyle(color: Colors.redAccent))),
        ],
      )
    ) ?? false;

    if (confirm) {
      await _gameController.deleteGame(id);
      _refreshList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              icon: Icon(Icons.add, color: Colors.black),
              label: Text("ADICIONAR NOVO JOGO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[800],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
              onPressed: () async {
                bool? saved = await Navigator.push(context, MaterialPageRoute(builder: (context) => GameForm()));
                if (saved == true) _refreshList();
              },
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Game>>(
            future: _gamesFuture, 
            builder: (context, snapshot){
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator(color: Colors.amber));
              if (snapshot.data!.isEmpty) return Center(child: Text("Nenhum jogo encontrado.", style: TextStyle(color: Colors.white54)));

              List<Game> games = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  Game game = games[index];
                  return Card(
                    color: Color(0xFF1E1E1E), // Fundo escuro do card
                    margin: EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white10),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(
                      title: Text(game.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        game.description, 
                        style: TextStyle(color: Colors.grey), 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              bool? saved = await Navigator.push(context, MaterialPageRoute(builder: (context) => GameForm(game: game)));
                              if (saved == true) _refreshList();
                            }, 
                            icon: Icon(Icons.edit, color: Colors.blueAccent)
                          ),
                          IconButton(
                            onPressed: () => _deleteGame(game.id!), 
                            icon: Icon(Icons.delete, color: Colors.redAccent)
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          )
        )
      ],
    );
  }
}