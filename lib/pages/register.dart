import 'package:flutter/material.dart';
import '../utils/conf.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.white, 
          child: Text("The Game Awards"),
        ),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30
        ),
        backgroundColor: Conf.primaryColor,
        foregroundColor: Colors.white, 
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Imagem
            Form(
              child: Column(
                children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        0, 0, 0, 30
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          label: Text("Username"),
                          border: OutlineInputBorder()
                        ),
                        validator: (value){
                          return value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        0, 0, 0, 30
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          label: Text("Email"),
                          border: OutlineInputBorder()
                        ),
                        validator: (value){
                          return value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        0, 0, 0, 30
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          label: Text("Senha"),
                          border: OutlineInputBorder()
                        ),
                        validator: (value){
                          return value;
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: false, 
                          onChanged: (value) => "",
                        ),
                        Text("Administrador")  
                      ],
                    )
                ],
              ),
            ),

            Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                    0, 30, 0, 30
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cadastrar")
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Já possui conta?\nFaça login!",
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
    );
  }
}