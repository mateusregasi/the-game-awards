import 'package:flutter/material.dart';
import 'package:thegameawards/controller/game_controller.dart';
import 'package:thegameawards/model/category.dart';
import 'package:thegameawards/model/game.dart';

class VotesDashboard extends StatefulWidget {
  const VotesDashboard({super.key});

  @override
  State<VotesDashboard> createState() => _VotesDashboardState();
}

class _VotesDashboardState extends State<VotesDashboard> {
  final GameController _gameController = GameController();
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

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
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: Colors.amber));
        }

        List<Category> categories = snapshot.data!;

        if (categories.isEmpty) {
          return Center(
            child: Text("Sem dados para exibir.", style: TextStyle(color: Colors.white)),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryVoteCard(
              category: category,
              controller: _gameController,
            );
          },
        );
      },
    );
  }
}

class _CategoryVoteCard extends StatelessWidget {
  final Category category;
  final GameController controller;

  const _CategoryVoteCard({required this.category, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          iconColor: Colors.amber,
          collapsedIconColor: Colors.white,
          title: Text(
            category.title.toUpperCase(),
            style: TextStyle(
              color: Colors.amber[800],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          children: [
            FutureBuilder<List<Game>>(
              future: controller.getAllByCategoryId(category.id!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SizedBox(height: 50, child: Center(child: CircularProgressIndicator()));
                
                List<Game> games = snapshot.data!;
                if (games.isEmpty) return Padding(padding: EdgeInsets.all(16), child: Text("Sem jogos.", style: TextStyle(color: Colors.grey)));

                return Column(
                  children: games.map((game) {
                    return FutureBuilder<int>(
                      // --- ATUALIZAÇÃO AQUI: Passando game.id E category.id ---
                      future: controller.getVoteCount(game.id!, category.id!),
                      builder: (context, voteSnap) {
                        int votes = voteSnap.data ?? 0;
                        
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: Colors.white10)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  game.name,
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: votes > 0 ? Colors.amber[800] : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "$votes",
                                  style: TextStyle(
                                    color: votes > 0 ? Colors.black : Colors.white54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}