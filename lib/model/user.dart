import 'dart:convert';
import 'package:thegameawards/utils/database.dart';

class User {

  final int? id;
  final String name;
  final String password;
  final String email;
  final int role; 

  User({
    this.id, 
    required this.name, 
    required this.password, 
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      "id": id,
      "name": name,
      "password": password,
      "email": email,
      "role": role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"],
      name: map["name"] as String,
      password: map["password"] as String,
      email: map["email"] as String,
      role: map["role"] as int
    );
  }

  String toJson() => jsonEncode(toMap());

  factory User.fromJson(String source) => User.fromMap(jsonDecode(source) as Map<String, dynamic>);

  Future<int> save(DatabaseHelper con) async {
    var db = await con.db;
    int res = await db.insert('user', toMap());
    return res;
  }
  
  Future<int> delete(DatabaseHelper con) async {
    var db = await con.db;
    int res = await db.delete("user", where: "id = ?", whereArgs: [id]);
    return res;
  }

  static Future<User> getUserByLogin(DatabaseHelper con, String name, String password) async {
    var db = await con.db;
    // Correção: Uso de '?' para prevenir SQL Injection e erros de sintaxe
    var res = await db.query(
      "user", 
      where: "name = ? AND password = ?", 
      whereArgs: [name, password]
    );
   
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    
    return User(id: -1, name: "", password: "", email: "", role: 0);
  }

  // --- MÉTODO QUE FALTAVA ---
  static Future<User> getUserById(DatabaseHelper con, int id) async {
    var db = await con.db;
    var res = await db.query("user", where: "id = ?", whereArgs: [id]);
    
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return User(id: -1, name: "", password: "", email: "", role: 0);
  }

  Future<List<User>> getAll(DatabaseHelper con) async {
    var db = await con.db;
    var res = await db.query("user");
    List<User> list = res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }
}