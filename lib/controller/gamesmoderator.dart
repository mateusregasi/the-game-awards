import 'package:flutter/material.dart';
import 'package:thegameawards/controller/game_controller.dart';
import 'package:thegameawards/model/category.dart';
import 'package:thegameawards/model/game.dart';
import 'package:thegameawards/pages/game_form.dart';

class GamesModerator extends StatefulWidget {
  const GamesModerator({super.key});

  @override
  State<GamesModerator> createState() => _GamesModeratorState();
}

class _GamesModeratorState extends State<GamesModerator> {
  final GameController _gameController = GameController();

  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  // Função para recarregar tudo
  void _refresh() {
    setState(() {
      _categoriesFuture = _gameController.getAllCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator(color: Colors.amber));
        if (snapshot.data!.isEmpty)
          return Center(
            child: Text(
              "Sem categorias cadastradas.",
              style: TextStyle(color: Colors.white),
            ),
          );

        List<Category> categories = snapshot.data!;

        // DefaultTabController cria as ABAS automaticamente
        return DefaultTabController(
          length: categories.length,
          child: Column(
            children: [
              // --- 1. BARRA DE ABAS (CATEGORIAS) ---
              Container(
                color: Color(0xFF1E1E1E),
                child: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.amber[800],
                  labelColor: Colors.amber[800],
                  unselectedLabelColor: Colors.white54,
                  tabs: categories
                      .map((c) => Tab(text: c.title.toUpperCase()))
                      .toList(),
                ),
              ),

              // --- 2. CONTEÚDO DAS ABAS (LISTA DE JOGOS) ---
              Expanded(
                child: TabBarView(
                  children: categories.map((cat) {
                    return _GamesListByCategory(
                      category: cat,
                      controller: _gameController,
                      onUpdate: _refresh,
                    );
                  }).toList(),
                ),
              ),

              // --- 3. BOTÃO ADICIONAR JOGO ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add, color: Colors.black),
                    label: Text(
                      "ADICIONAR JOGO",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[800],
                    ),
                    onPressed: () async {
                      bool? saved = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameForm()),
                      );
                      if (saved == true) _refresh();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- LISTA DE JOGOS INTERNA (COM VOTOS) ---
class _GamesListByCategory extends StatefulWidget {
  final Category category;
  final GameController controller;
  final VoidCallback onUpdate;

  const _GamesListByCategory({
    required this.category,
    required this.controller,
    required this.onUpdate,
  });

  @override
  State<_GamesListByCategory> createState() => _GamesListByCategoryState();
}

class _GamesListByCategoryState extends State<_GamesListByCategory> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Game>>(
      future: widget.controller.getAllByCategoryId(widget.category.id!),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator(color: Colors.amber));

        List<Game> games = snapshot.data!;

        if (games.isEmpty) {
          return Center(
            child: Text(
              "Nenhum jogo nesta categoria",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: games.length,
          itemBuilder: (context, index) {
            Game game = games[index];
            return Card(
              color: Color(0xFF2C2C2C),
              margin: EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  game.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // --- MOSTRA OS VOTOS AQUI ---
                subtitle: FutureBuilder<int>(
                  future: widget.controller.getVoteCount(game.id!),
                  builder: (context, voteSnap) {
                    int votes = voteSnap.data ?? 0;
                    return Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Icon(Icons.poll, size: 16, color: Colors.amber[800]),
                          SizedBox(width: 5),
                          Text(
                            "$votes Votos",
                            style: TextStyle(
                              color: Colors.amber[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () async {
                        bool? saved = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameForm(game: game),
                          ),
                        );
                        if (saved == true) widget.onUpdate();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        bool confirm =
                            await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: Color(0xFF1E1E1E),
                                title: Text(
                                  "Excluir?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: Text("Não"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: Text(
                                      "Sim",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ) ??
                            false;

                        if (confirm) {
                          await widget.controller.deleteGame(game.id!);
                          widget.onUpdate();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
