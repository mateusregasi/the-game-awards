import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thegameawards/controller/login_controler.dart';
import 'package:thegameawards/pages/moderator.dart';
import 'package:thegameawards/view/interface.dart';
import 'register.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _forms = GlobalKey<FormState>();
  LoginController loginController = LoginController();
  String _login = "";
  String _password = "";
   

  login() async{
    final form = _forms.currentState;
    if(form!.validate())
      form.save();
    if(await loginController.verifyUser(_login, _password)){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Moderator())
      );
    } else{
      // Resposta
    }
    print("verificar");
  }

  @override
  Widget build(BuildContext context) {
    return Interface(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Imagem
            Form(
              key: _forms,
              child: Column(
                children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        0, 0, 0, 30
                      ),
                      child:   TextFormField(
                        decoration: InputDecoration(
                          label: Text("Login"),
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (newValue) => _login = newValue!,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        0, 0, 0, 30
                      ),
                      child:   TextFormField(
                        decoration: InputDecoration(
                          label: Text("Senha"),
                          border: OutlineInputBorder()
                        ),
                        onSaved: (newValue) => _password = newValue!,
                      ),
                    ),
                ],
              )
            ),

            Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                    0, 30, 0, 30
                  ),
                  child: ElevatedButton(
                    onPressed: login, 
                    child: Text("Login")
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => Register())
                  ),
                  child: Text(
                    "Não possui conta?\nCadastre-se!",
                    style: TextStyle(
                      decoration: TextDecoration.underline
                    ),
                    textAlign: TextAlign.center,  
                  )
                )
              ],
            )
          ],
        ),
      ),
      title: "The Game Awards",
    );
  }
}