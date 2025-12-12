import 'package:flutter/material.dart';
import 'package:thegameawards/controller/login_controler.dart';
import 'package:thegameawards/pages/moderator.dart';
import 'package:thegameawards/pages/user.dart';
import 'register.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _forms = GlobalKey<FormState>();
  LoginController loginController = LoginController();
  String _name = "";
  String _password = "";
  
  void login(){
    switch(loginController.getRole()){
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => User())
        );
      break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Moderator())
        );
        break;
    }
  }

  void enter() async{
    final form = _forms.currentState;
    if(form!.validate())
      form.save();
    if(await loginController.verifyUser(_name, _password)){
      loginController.saveSession();
      login();
      
    } else{
      // Resposta
    }
  }

  @override
  void initState() {
    loginController.loadSession().then((value){
      if(value) login();
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
        
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E003E), 
              Color(0xFF000000), 
            ],
          ),
        ),
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ]
                  ),
                  child: Icon(
                    Icons.emoji_events, 
                    size: 80, 
                    color: Colors.amber[800]
                  ),
                ),
                
                SizedBox(height: 30),
                
                Text(
                  "THE GAME AWARDS",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: Colors.black, offset: Offset(2,2), blurRadius: 4)
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                
                SizedBox(height: 50),

           
                Form(
                  key: _forms,
                  child: Column(
                    children: [
                      
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Usuário",
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor insira o usuário';
                          }
                          return null;
                        },
                        onSaved: (newValue) => _name = newValue!,
                      ),
                      
                      SizedBox(height: 20),
                      
                    
                      TextFormField(
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Senha",
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor insira a senha';
                          }
                          return null;
                        },
                        onSaved: (newValue) => _password = newValue!,
                      ),
                    ],
                  )
                ),

                SizedBox(height: 40),

              
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: enter, 
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
    );
  }
}