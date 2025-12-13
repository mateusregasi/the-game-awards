import 'package:flutter/material.dart';
import 'package:thegameawards/model/category.dart';
import 'package:thegameawards/model/category_controller.dart';

class CategorieModerator extends StatefulWidget {
  const CategorieModerator({super.key});

  @override
  State<CategorieModerator> createState() => _CategorieModeratorState();
}

class _CategorieModeratorState extends State<CategorieModerator> {
  CategoryController _categoryController = CategoryController();

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
              future: _categoryController.getCategories(), 
              builder: (context, snapshot){
                if(snapshot.hasData){
                  List<Category> categories = snapshot.data!;
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) => GestureDetector(
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(categories[index].title),
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