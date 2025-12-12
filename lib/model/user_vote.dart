import 'dart:convert';

import 'package:thegameawards/utils/database.dart';

class UserVote {

  final int? id;
  final int userId;
  final int categoryId;
  final int voteGameId;

  UserVote({
    this.id, 
    required this.userId, 
    required this.categoryId, 
    required this.voteGameId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      "id": id,
      "user_id": userId,
      "category_id": categoryId,
      "vote_game_id": voteGameId,
    };
  }

  factory UserVote.fromMap(Map<String, dynamic> map) {
    return UserVote(
      id: map["id"] ??= map["id"],
      userId: map["user_id"] as int,
      categoryId: map["category_id"] as int,
      voteGameId: map["vote_game_id"] as int
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UserVote.fromJson(String source) => UserVote.fromMap(jsonDecode(source) as Map<String, dynamic>);

  Future<int> save(DatabaseHelper con) async {
    var db = await con.db;
    int res = await db.insert('user_vote', toMap());
    return res;
  }
  
  Future<int> delete(DatabaseHelper con) async {
    var db = await con.db;
    int res = await db.delete("user_vote", where: "id = ?", whereArgs: [id]);
    return res;
  }

  static Future<int> deleteByUserCategory(DatabaseHelper con, int userId, int categoryId) async {
    var db = await con.db;
    int res = await db.delete(
      "user_vote", 
      where: "user_id = ? and category_id = ?", 
      whereArgs: [userId, categoryId]
    );
    return res;
  }
  static Future<UserVote> getById(DatabaseHelper con, int id) async {
    
    var db = await con.db;
    var res = await db.query(
    "user_vote",
      where:"id = $id" 
    );
   
    if (res.length > 0) {
      return UserVote.fromMap(res.first);
    }
    
    return UserVote(id: -1, categoryId: -1, userId: -1, voteGameId: -1);
  }

  Future<List<UserVote>> getAll(DatabaseHelper con) async {
    var db = await con.db;
    var res = await db.query("user_vote");
    List<UserVote> list = res.isNotEmpty ? res.map((c) => UserVote.fromMap(c)).toList() : [];
    return list;
  }
}