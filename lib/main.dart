import 'package:flutter/material.dart';
import 'pages/home.dart';

void main(){
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      title: "The Game Awards"
    )
  );
}