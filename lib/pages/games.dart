import 'package:flutter/material.dart';
import 'package:thegameawards/controller/game_controller.dart';
import 'package:thegameawards/controller/login_controler.dart';
import 'package:thegameawards/model/game.dart';
import "../model/category.dart" as model;

class Games extends StatefulWidget {
  final model.Category category;
  const Games({super.key, required this.category});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  int _selectedGameIndex = -1; 
  List<Game> _games = [];
  GameController _gameController = GameController();
  LoginController _loginController = LoginController();

  _select(int index) async{
    if(index == _selectedGameIndex){
      _gameController.unvote(
        _loginController.user!,
        widget.category,
      );
      _selectedGameIndex = -1;
    } else{
      if(_selectedGameIndex != -1){
        _gameController.unvote(
          _loginController.user!,
          widget.category,
        );
      }
      _selectedGameIndex = index;
      _gameController.vote(
        _loginController.user!,
        widget.category,
        _games[index]
      );
    } 
    setState((){});
  }
  
  @override
  void initState() {
    _loginController.loadSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _gameController.getAllByCategoryId(widget.category.id!), 
      builder: (context, snapshot){
        if(snapshot.hasData){
          _games = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.category.title.toUpperCase()),
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
                          onTap: () => _select(index),
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
                                    _games[index].name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.black : Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
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
                          : "Voto confirmado em:\n${_games[_selectedGameIndex].name}",
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
        } else{
          return CircularProgressIndicator();
        }
      }
    );
  }
}