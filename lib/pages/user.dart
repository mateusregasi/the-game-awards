import 'package:thegameawards/utils/database.dart';

class User {
  final int? id;
  final String name;
  final String password;
  final String email;
  final int role; 

  User({this.id, required this.name, required this.password, required this.email, required this.role});

  Map<String, dynamic> toMap() => {"id": id, "name": name, "password": password, "email": email, "role": role};

  factory User.fromMap(Map<String, dynamic> map) {
    return User(id: map["id"], name: map["name"], password: map["password"], email: map["email"], role: map["role"]);
  }

  Future<int> save(DatabaseHelper con) async {
    var db = await con.db;
    return await db.insert('user', toMap());
  }

  static Future<User> getUserByLogin(DatabaseHelper con, String name, String password) async {
    var db = await con.db;
    var res = await db.query("user", where: "name = ? AND password = ?", whereArgs: [name, password]);
    if (res.isNotEmpty) return User.fromMap(res.first);
    return User(id: -1, name: "", password: "", email: "", role: 0);
  }

  static Future<User> getUserById(DatabaseHelper con, int id) async {
    var db = await con.db;
    var res = await db.query("user", where: "id = ?", whereArgs: [id]);
    if (res.isNotEmpty) return User.fromMap(res.first);
    return User(id: -1, name: "", password: "", email: "", role: 0);
  }
}