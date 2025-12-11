import 'package:flutter/material.dart';
import 'package:thegameawards/view/interface.dart';

class Games extends StatefulWidget {
  final String categorie;
  const Games({super.key, required this.categorie});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  int _vote = -1;
  String _statusText = "Sem nenhum voto!";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Interface(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => Container(
                  height: 100,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: ElevatedButton(
                    onPressed: () => "", 
                    child: Text("Jogo")
                  ),
                )
              ),
            ),
            
            Center(
              child: Text(
                _statusText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey[400]
                ),
              )
            )
          ],
        ),
      ),
      
      title: widget.categorie,
    );
  }
}