import 'package:flutter/material.dart';
import 'package:thegameawards/controller/game_controller.dart';
import 'package:thegameawards/model/game.dart';

class GamesModerator extends StatefulWidget {
  const GamesModerator({super.key});

  @override
  State<GamesModerator> createState() => _GamesModeratorState();
}

class _GamesModeratorState extends State<GamesModerator> {
  GameController _gameController = GameController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))
              )
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(30) 
          ),
          Expanded(
            child: FutureBuilder(
              future: _gameController.getAllGames(), 
              builder: (context, snapshot){
                if(snapshot.hasData){
                  List<Game> games = snapshot.data!;
                  return ListView.builder(
                    itemCount: games.length,
                    itemBuilder: (context, index) => GestureDetector(
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(games[index].name),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => "", 
                                    icon: Icon(Icons.edit)
                                  ),
                                  IconButton(
                                    onPressed: () => "", 
                                    icon: Icon(Icons.delete)
                                  ),
                                ],
                              )
                            ],
                          ),
                        ) 
                      ),
                      onTap: () => "",
                    ),
                  );
                } else{
                  return CircularProgressIndicator();
                }
              }
            )
          )
        ],
      ),
    );
  }
}