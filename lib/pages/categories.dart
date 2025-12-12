import 'package:flutter/material.dart';
import 'package:thegameawards/controller/category_controller.dart';
import 'package:thegameawards/model/category.dart';
import 'package:thegameawards/pages/games.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  CategoryController _categoryController = CategoryController();
  List<Category> _categories = [];
  List<int> _length = [];

  handle() async{
    _categories = await _categoryController.getCategories();
    for(int i=0; i < _categories.length; i++){
      _length.add(
        await _categoryController.getCategoryLength(_categories[i])
      );
    }
    return _categories;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: handle(), 
      builder: (context, snapshot){
        if(snapshot.hasData){
          List<Category> categories = _categories;
          return ListView.builder(
            physics: BouncingScrollPhysics(), 
            itemCount: categories.length,
            padding: EdgeInsets.all(16),
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ]
                ),
                child: Material(
                  color: Color(0xFF1E1E1E), 
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    splashColor: Colors.amber.withOpacity(0.1),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Games(
                          category: categories[index],
                        ) 
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Row(
                        children: [
                          
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.amber[800]!.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.emoji_events_outlined, color: Colors.amber[800]),
                          ),
                          SizedBox(width: 20),
                          
                          
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  categories[index].title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${_length[index]} Indicados",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Seta
                          Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          );
        } else {
          return CircularProgressIndicator();
        }
      }
    );
  }
}