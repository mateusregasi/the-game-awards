import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io' as io;

class DatabaseHelper {

  static final DatabaseHelper _instance = DatabaseHelper.internal();
  static Database? _db;
  
  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database> get db async {
    return _db ??= await initDb();
  }

  Future<Database> initDb() async {
    sqfliteFfiInit();

    var databaseFactory = databaseFactoryFfi;
    io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    final path = p.join(appDocumentsDir.path, "data.db");
    
    Database db = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {

          String sql = """
              
              CREATE TABLE user(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name VARCHAR NOT NULL,
                email VARCHAR NOT NULL,
                password VARCHAR NOT NULL,
                role INTEGER NOT NULL
              );

              CREATE TABLE genre(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name VARCHAR NOT NULL
              );

              CREATE TABLE game(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER NOT NULL,
                name VARCHAR NOT NULL UNIQUE,
                description TEXT NOT NULL,
                release_date VARCHAR NOT NULL,
                FOREIGN KEY(user_id) REFERENCES user(id),
              );

              CREATE TABLE game_genre(
                game_id INTEGER NOT NULL,
                genre_id INTEGER NOT NULL,
                FOREIGN KEY(game_id) REFERENCES game(id),
                FOREIGN KEY(genre_id) REFERENCES genre(id),
              );

              CREATE TABLE category(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER NOT NULL,
                title VARCHAR NOT NULL,
                description TEXT,  
                date VARCHAR NOT NULL,
                FOREIGN KEY(user_id) REFERENCES user(id)
              );

              CREATE TABLE category_game(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                category_id INTEGER NOT NULL,
                game_id INTEGER NOT NULL,
                FOREIGN KEY(category_id) REFERENCES category(id),
                FOREIGN KEY(game_id) REFERENCES game(id)
              );

              CREATE TABLE user_vote(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER NOT NULL,
                category_id INTEGER NOT NULL,
                vote_game_id INTEGER NOT NULL,    
                FOREIGN KEY(user_id) REFERENCES user(id),
                FOREIGN KEY(category_id) REFERENCES category(id),
                FOREIGN KEY(vote_game_id) REFERENCES category_game(game_id)
              );

              """;
          await db.execute(sql);

        }
      )
    );

    return db;
  }


}