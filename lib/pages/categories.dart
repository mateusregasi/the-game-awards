import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thegameawards/model/category.dart';
import 'package:thegameawards/controller/category_controller.dart';
import 'package:thegameawards/pages/games.dart';
import 'home.dart'; 

class Categories extends StatefulWidget {
  const Categories({super.key});
  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final CategoryController _ctrl = CategoryController();

  // --- FUNÇÃO DE LOGOUT ---
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpa a sessão
    
    if (mounted) {
      // Volta para a Home removendo as telas anteriores da pilha
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => Home()), 
        (route) => false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("CATEGORIAS", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // BOTÃO DE SAIR
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout, color: Colors.redAccent),
            tooltip: "Sair",
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E003E), Colors.black],
          ),
        ),
        child: FutureBuilder<List<Category>>(
          future: _ctrl.getCategories(),
          builder: (context, snapshot) {
            // Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.amber));
            }
            
            // Sem dados
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Nenhuma categoria encontrada", style: TextStyle(color: Colors.white54)),
                  ],
                )
              );
            }

            // Lista de Categorias
            return ListView.builder(
              padding: EdgeInsets.fromLTRB(16, 100, 16, 20), // Topo maior por causa do AppBar transparente
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Category cat = snapshot.data![index];
                
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Games(category: cat))),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E), // Cor do card
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white10),
                      boxShadow: [
                        BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 4))
                      ]
                    ),
                    child: Row(
                      children: [
                        // Ícone Decorativo
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber[800]!.withOpacity(0.1),
                            shape: BoxShape.circle
                          ),
                          child: Icon(Icons.emoji_events, color: Colors.amber[800]),
                        ),
                        SizedBox(width: 15),
                        
                        // Texto
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat.title.toUpperCase(), 
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)
                              ),
                              if(cat.description.isNotEmpty) ...[
                                SizedBox(height: 5),
                                Text(
                                  cat.description, 
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                  maxLines: 1, 
                                  overflow: TextOverflow.ellipsis
                                ),
                              ]
                            ],
                          ),
                        ),
                        
                        // Seta
                        Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
                      ],
                    ),
                  ),
                );
              }
            );
          }
        ),
      ),
    );
  }
}