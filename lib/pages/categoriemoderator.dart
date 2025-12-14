import 'package:flutter/material.dart';
import 'package:thegameawards/controller/category_controller.dart';
import 'package:thegameawards/model/category.dart';
import 'package:thegameawards/model/category_form.dart';

class CategorieModerator extends StatefulWidget {
  const CategorieModerator({super.key});

  @override
  State<CategorieModerator> createState() => _CategorieModeratorState();
}

class _CategorieModeratorState extends State<CategorieModerator> {
  CategoryController _categoryController = CategoryController();
  late Future<List<Category>> _catFuture;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _catFuture = _categoryController.getCategories();
    });
  }

  void _deleteCategory(int id) async {
    bool confirm = await showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF2C2C2C),
        title: Text("Excluir Categoria?", style: TextStyle(color: Colors.white)),
        content: Text("Isso apagará também os votos associados.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancelar", style: TextStyle(color: Colors.grey))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Excluir", style: TextStyle(color: Colors.redAccent))),
        ],
      )
    ) ?? false;

    if (confirm) {
      await _categoryController.deleteCategory(id);
      _refreshList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              icon: Icon(Icons.add, color: Colors.black),
              label: Text("NOVA CATEGORIA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[800],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
              onPressed: () async {
                bool? saved = await Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryForm()));
                if (saved == true) _refreshList();
              },
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Category>>(
            future: _catFuture, 
            builder: (context, snapshot){
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator(color: Colors.amber));
              
              List<Category> categories = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  Category cat = categories[index];
                  return Card(
                    color: Color(0xFF1E1E1E),
                    margin: EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white10),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), shape: BoxShape.circle),
                        child: Icon(Icons.emoji_events, color: Colors.amber[800]),
                      ),
                      title: Text(cat.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              bool? saved = await Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryForm(category: cat)));
                              if (saved == true) _refreshList();
                            }, 
                            icon: Icon(Icons.edit, color: Colors.blueAccent)
                          ),
                          IconButton(
                            onPressed: () => _deleteCategory(cat.id!), 
                            icon: Icon(Icons.delete, color: Colors.redAccent)
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