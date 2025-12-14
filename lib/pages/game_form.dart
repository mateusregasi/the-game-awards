import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thegameawards/controller/game_controller.dart';
import 'package:thegameawards/model/category.dart';
import 'package:thegameawards/model/game.dart';

class GameForm extends StatefulWidget {
  final Game? game;
  const GameForm({super.key, this.game});
  @override
  State<GameForm> createState() => _GameFormState();
}

class _GameFormState extends State<GameForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _dateController = TextEditingController();
  
  final GameController _controller = GameController();
  List<Category> _categories = [];
  int? _selectedCategoryId;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    int? uid = prefs.getInt("user_id");
  
    var cats = await _controller.getAllCategories();
  
    int? currentCatId;
    if (widget.game != null) {
      currentCatId = await _controller.getGameCategoryId(widget.game!.id!);
    }
    
    setState(() {
      _currentUserId = uid;
      _categories = cats;
      
      if (widget.game != null) {
        _nameController.text = widget.game!.name;
        _descController.text = widget.game!.description;
        _dateController.text = widget.game!.releaseDate;
      }

      
      if (currentCatId != null) {
        _selectedCategoryId = currentCatId;
      } else if (_categories.isNotEmpty && _selectedCategoryId == null) {
        _selectedCategoryId = _categories[0].id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text(widget.game == null ? "NOVO JOGO" : "EDITAR JOGO", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.amber[800]),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController, 
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Nome do Jogo",
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: true, fillColor: Color(0xFF1E1E1E),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                  ), 
                  validator: (v) => v!.isEmpty ? "Obrigatório" : null
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _descController, 
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Descrição",
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: true, fillColor: Color(0xFF1E1E1E),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                  ), 
                  validator: (v) => v!.isEmpty ? "Obrigatório" : null
                ),
                SizedBox(height: 20),
                
              
                Text("Categoria", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedCategoryId,
                      dropdownColor: Color(0xFF1E1E1E),
                      isExpanded: true,
                      style: TextStyle(color: Colors.white),
                      items: _categories.map((c) => DropdownMenuItem(
                        value: c.id, 
                        child: Text(c.title, overflow: TextOverflow.ellipsis)
                      )).toList(),
                      onChanged: (v) => setState(() => _selectedCategoryId = v),
                    ),
                  ),
                ),
                
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[800]),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Game g = Game(
                          id: widget.game?.id, 
                          userId: _currentUserId ?? 1, 
                          name: _nameController.text, 
                          description: _descController.text, 
                          releaseDate: _dateController.text.isEmpty ? "2025" : _dateController.text
                        );
                        // Salva o jogo com a nova categoria
                        await _controller.saveGame(g, _selectedCategoryId ?? 0);
                        if (mounted) Navigator.pop(context, true);
                      }
                    },
                    child: Text("SALVAR", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16))
                  ),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}