import 'package:flutter/material.dart';
import 'package:thegameawards/controller/register_controller.dart'; 

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isAdmin = false;
  final RegisterController _controller = RegisterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRIAR CONTA"), backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2E003E), Colors.black], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Icon(Icons.person_add, size: 60, color: Colors.amber[800]),
                  SizedBox(height: 30),
                  _buildField(_usernameController, "Usuário", Icons.person),
                  SizedBox(height: 20),
                  _buildField(_emailController, "Email", Icons.email),
                  SizedBox(height: 20),
                  _buildField(_passwordController, "Senha", Icons.lock, isPass: true),
                  SizedBox(height: 20),
                  Row(children: [
                    Checkbox(value: _isAdmin, activeColor: Colors.amber, onChanged: (v) => setState(() => _isAdmin = v!)),
                    Text("Administrador", style: TextStyle(color: Colors.white))
                  ]),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[800]),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool success = await _controller.register(
                            _usernameController.text, _emailController.text, _passwordController.text, _isAdmin ? 1 : 0
                          );
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sucesso!"), backgroundColor: Colors.green));
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: Text("CADASTRAR", style: TextStyle(color: Colors.black)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController c, String l, IconData i, {bool isPass = false}) {
    return TextFormField(
      controller: c, obscureText: isPass, style: TextStyle(color: Colors.white),
      decoration: InputDecoration(labelText: l, prefixIcon: Icon(i, color: Colors.amber), filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (v) => v!.isEmpty ? "Obrigatório" : null,
    );
  }
}