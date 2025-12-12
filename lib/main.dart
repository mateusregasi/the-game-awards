import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() {
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      title: "The Game Awards",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.amber[800], 
        scaffoldBackgroundColor: Color(0xFF121212),
        colorScheme: ColorScheme.dark(
          primary: Colors.amber[800]!,
          secondary: Colors.deepPurpleAccent,
          surface: Color(0xFF1E1E1E), 
          background: Color(0xFF121212),
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),

        
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.08), 
          labelStyle: TextStyle(color: Colors.white70),
          prefixIconColor: Colors.amber[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.amber[800]!, width: 2),
          ),
        ),

     
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[800],
            foregroundColor: Colors.black, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
            elevation: 5,
          ),
        ),
      ),
    )
  );
}