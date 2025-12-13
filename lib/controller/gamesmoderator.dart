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
  // Variável para forçar recarregamento da lista
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
        title: Text("Tem certeza?"),
        content: Text("Esta ação não pode ser desfeita."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Excluir", style: TextStyle(color: Colors.red))),
        ],
      )
    ) ?? false;

    if (confirm) {
      await _gameController.deleteGame(id);
      _refreshList();
    }
  }

  void _editGame(Game game) async {
    // Navega para o form e espera retorno (true se salvou)
    bool? saved = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => GameForm(game: game))
    );
    if (saved == true) _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.add, color: Colors.black),
              label: Text("NOVO JOGO", style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[800]),
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
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              if (snapshot.data!.isEmpty) return Center(child: Text("Nenhum jogo cadastrado."));

              List<Game> games = snapshot.data!;
              return ListView.builder(
                itemCount: games.length,
                itemBuilder: (context, index) {
                  Game game = games[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(game.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(game.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _editGame(game), 
                            icon: Icon(Icons.edit, color: Colors.blue)
                          ),
                          IconButton(
                            onPressed: () => _deleteGame(game.id!), 
                            icon: Icon(Icons.delete, color: Colors.red)
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