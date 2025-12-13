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
    
    setState(() {
      _currentUserId = uid;
      _categories = cats;
      if (widget.game != null) {
        _nameController.text = widget.game!.name;
        _descController.text = widget.game!.description;
        _dateController.text = widget.game!.releaseDate;
      }
      if (_categories.isNotEmpty) _selectedCategoryId = _categories[0].id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.game == null ? "NOVO JOGO" : "EDITAR")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(controller: _nameController, decoration: InputDecoration(labelText: "Nome"), validator: (v) => v!.isEmpty ? "Erro" : null),
            if (widget.game == null) DropdownButton<int>(
              value: _selectedCategoryId,
              items: _categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.title))).toList(),
              onChanged: (v) => setState(() => _selectedCategoryId = v),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Game g = Game(id: widget.game?.id, userId: _currentUserId!, name: _nameController.text, description: _descController.text, releaseDate: _dateController.text);
                  await _controller.saveGame(g, _selectedCategoryId ?? 0);
                  Navigator.pop(context, true);
                }
              },
              child: Text("SALVAR")
            )
          ]),
        ),
      ),
    );
  }
}