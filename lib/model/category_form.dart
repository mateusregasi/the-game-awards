import 'package:flutter/material.dart';
import 'package:thegameawards/controller/category_controller.dart';
import 'package:thegameawards/model/category.dart';

class CategoryForm extends StatefulWidget {
  final Category? category;
  const CategoryForm({super.key, this.category});

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final CategoryController _ctrl = CategoryController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _titleController.text = widget.category!.title;
      _descController.text = widget.category!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text(widget.category == null ? "NOVA CATEGORIA" : "EDITAR CATEGORIA", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.amber[800]),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Título", 
                  labelStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF1E1E1E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                ),
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Descrição", 
                  labelStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF1E1E1E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                ),
                maxLines: 3,
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[800], 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Category c = Category(
                        id: widget.category?.id,
                        userId: 1, 
                        title: _titleController.text,
                        description: _descController.text,
                        date: "2025"
                      );
                      await _ctrl.saveCategory(c);
                      if (mounted) Navigator.pop(context, true);
                    }
                  },
                  child: Text("SALVAR", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}