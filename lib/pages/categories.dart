import 'package:flutter/material.dart';
import 'package:thegameawards/pages/games.dart';
import '../utils/conf.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) => Container(
        height: 100,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Games(
                categorie: "Categoria",
              ) 
            )
          ), 
          child: Text("Categoria")
        ),
      )
    );
  }
}