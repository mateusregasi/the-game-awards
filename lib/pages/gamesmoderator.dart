import 'package:flutter/material.dart';

class GamesModerator extends StatefulWidget {
  const GamesModerator({super.key});

  @override
  State<GamesModerator> createState() => _GamesModeratorState();
}

class _GamesModeratorState extends State<GamesModerator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
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
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) => GestureDetector(
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Nome"),
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
              )
            )
          ],
        ),
      )
    );
  }
}