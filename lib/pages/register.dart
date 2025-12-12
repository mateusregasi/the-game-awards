import 'package:flutter/material.dart';
import 'package:thegameawards/controller/register_controller.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isAdmin = false;
  String _name = "";
  String _email = "";
  String _password = "";
  GlobalKey<FormState> _forms = GlobalKey<FormState>();
  RegisterController _registerController = RegisterController();

  register(){
    FormState form = _forms.currentState!; 
    if(form.validate()){
      form.save();
      _registerController.register(
        _name, 
        _email, 
        _password, 
        _isAdmin ? 1 : 0
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar simplificada pois o Theme já define o estilo
      appBar: AppBar(
        title: Text("Criar Conta"),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Center( // Centraliza verticalmente
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add_outlined, size: 60, color: Colors.amber[800]),
                SizedBox(height: 30),
                
                Form(
                  key: _forms,
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Username",
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        onSaved: (newValue) => _name = newValue!,
                      ),
                      SizedBox(height: 20),
                      
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (newValue) => _email = newValue!,
                      ),
                      SizedBox(height: 20),
                      
                      TextFormField(
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Senha",
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                        ),
                        onSaved: (newValue) => _password = newValue!,
                      ),
                      SizedBox(height: 20),
                      
                      // Checkbox customizado
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isAdmin = !_isAdmin;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: _isAdmin,
                                  activeColor: Colors.amber[800],
                                  checkColor: Colors.black,
                                  onChanged: (value) => setState(() => _isAdmin = value!),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Conta de Administrador",
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => register(),
                    child: Text("CADASTRAR")
                  ),
                ),
                
                SizedBox(height: 15),
                
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Já possui conta? Faça login",
                    style: TextStyle(color: Colors.white60),
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}