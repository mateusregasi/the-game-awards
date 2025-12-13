import 'package:flutter/material.dart';
import 'package:thegameawards/model/category.dart';
import 'package:thegameawards/model/category_controller.dart';

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
      appBar: AppBar(title: Text(widget.category == null ? "NOVA CATEGORIA" : "EDITAR CATEGORIA")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Título", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: "Descrição", border: OutlineInputBorder()),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[800], padding: EdgeInsets.all(15)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Category c = Category(
                        id: widget.category?.id,
                        userId: 1, // Assume admin ID 1
                        title: _titleController.text,
                        description: _descController.text,
                        date: "2025"
                      );
                      await _ctrl.saveCategory(c);
                      if (mounted) Navigator.pop(context, true); // Retorna true para recarregar lista
                    }
                  },
                  child: Text("SALVAR", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}