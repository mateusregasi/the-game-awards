import 'package:flutter/material.dart';
import 'package:thegameawards/controller/login_controler.dart';
import 'package:thegameawards/pages/moderator.dart'; 
import 'categories.dart'; // CORREÇÃO 1: Importar a tela de categorias
import 'register.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  
  final LoginController _loginController = LoginController();
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    // Pequeno delay para a logo aparecer
    await Future.delayed(Duration(milliseconds: 500));

    bool hasSession = await _loginController.loadSession();

    if (hasSession) {
      if (mounted) _navigateBasedOnRole();
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateBasedOnRole() {
    int role = _loginController.getRole();
    if (role == 1) {
      // Admin -> Vai para tela de Moderador
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Moderator())
      );
    } else {
      // Usuário Comum -> Vai para tela de Votação (Categorias)
      // CORREÇÃO 2: Alterado de User() para Categories()
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Categories())
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF1E1E1E), // Fundo escuro
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.redAccent.withOpacity(0.5), width: 1)
        ),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 30),
            SizedBox(width: 10),
            Text("Acesso Negado", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Tentar Novamente",
              style: TextStyle(color: Colors.amber[800], fontWeight: FontWeight.bold),
            ),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tela de Carregamento Inicial
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2E003E), Colors.black],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, size: 80, color: Colors.amber[800]),
                SizedBox(height: 20),
                CircularProgressIndicator(color: Colors.amber[800]),
              ],
            ),
          ),
        ),
      );
    }

    // Tela de Login
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E003E), // Roxo escuro
              Color(0xFF000000), // Preto
            ],
          ),
        ),
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  // LOGO
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
                      boxShadow: [
                        BoxShadow(color: Colors.amber.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)
                      ]
                    ),
                    child: Icon(Icons.emoji_events, size: 80, color: Colors.amber[800]),
                  ),
                  SizedBox(height: 30),
                  
                  Text(
                    "THE GAME AWARDS",
                    style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 3, color: Colors.white,
                      shadows: [Shadow(color: Colors.black, offset: Offset(2,2), blurRadius: 4)]
                    ),
                  ),
                  SizedBox(height: 50),

                  // Campos
                  TextFormField(
                    controller: _userController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Login",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) => value!.isEmpty ? 'Digite seu usuário' : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passController,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Senha",
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value) => value!.isEmpty ? 'Digite sua senha' : null,
                  ),
                  SizedBox(height: 40),

                  // --- BOTÃO DE ENTRAR ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                         
                          bool isValid = await _loginController.verifyUser(
                            _userController.text, 
                            _passController.text
                          );

                          if (isValid) {
                            await _loginController.saveSession();
                            _navigateBasedOnRole();
                          } else {
                            _showErrorDialog("Usuário ou senha incorretos. Verifique seus dados.");
                          }
                        }
                      }, 
                      child: Text("ENTRAR")
                    ),
                  ),
                  
                  SizedBox(height: 15),
                  
                  TextButton(
                    onPressed: () => Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => Register())
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: "Não possui conta? ",
                        style: TextStyle(color: Colors.white60),
                        children: [
                          TextSpan(
                            text: "Cadastre-se!",
                            style: TextStyle(
                              color: Colors.amber[800],
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ]
                      ),
                    )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}