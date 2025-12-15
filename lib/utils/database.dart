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
    
   
    final path = p.join(appDocumentsDir.path, "tga_2025_v2.db"); 

    Database db = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        
       
        onOpen: (db) async {
          await db.execute("""
            CREATE TABLE IF NOT EXISTS user_vote(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL,
              category_id INTEGER NOT NULL,
              vote_game_id INTEGER NOT NULL,    
              FOREIGN KEY(user_id) REFERENCES user(id),
              FOREIGN KEY(category_id) REFERENCES category(id),
              FOREIGN KEY(vote_game_id) REFERENCES game(id)
            );
          """);
        },

     
        onCreate: (db, version) async {
          
          await db.execute("""
            CREATE TABLE user(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL,
              email VARCHAR NOT NULL,
              password VARCHAR NOT NULL,
              role INTEGER NOT NULL
            );
          """);

          await db.execute("""
            CREATE TABLE genre(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL
            );
          """);

          await db.execute("""
            CREATE TABLE game(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL,
              name VARCHAR NOT NULL UNIQUE,
              description TEXT NOT NULL,
              release_date VARCHAR NOT NULL,
              FOREIGN KEY(user_id) REFERENCES user(id)
            );
          """);

          await db.execute("""
            CREATE TABLE category(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL,
              title VARCHAR NOT NULL,
              description TEXT,  
              date VARCHAR NOT NULL,
              FOREIGN KEY(user_id) REFERENCES user(id)
            );
          """);

          await db.execute("""
            CREATE TABLE category_game(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              category_id INTEGER NOT NULL,
              game_id INTEGER NOT NULL,
              FOREIGN KEY(category_id) REFERENCES category(id),
              FOREIGN KEY(game_id) REFERENCES game(id)
            );
          """);

          await db.execute("""
            CREATE TABLE user_vote(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL,
              category_id INTEGER NOT NULL,
              vote_game_id INTEGER NOT NULL,    
              FOREIGN KEY(user_id) REFERENCES user(id),
              FOREIGN KEY(category_id) REFERENCES category(id),
              FOREIGN KEY(vote_game_id) REFERENCES game(id)
            );
          """);

     
          await db.rawInsert("INSERT INTO user(name, email, password, role) VALUES('admin', 'admin@tga.com', 'admin', 1)"); 
          await db.rawInsert("INSERT INTO user(name, email, password, role) VALUES('user', 'user@tga.com', '123', 0)");

          // Mapa completo dos jogos TGA 2025
          Map<String, List<String>> categoriesData = {
            'Jogo do ano': [
              'Clair Obscur: Expedition 33', 'Death Stranding 2: On the beach', 'Donkey Kong Bananza',
              'Hades 2', 'Hollow Knight: Silksong', 'Kingdom Come: Deliverance 2'
            ],
            'Melhor direção': [
              'Clair Obscur: Expedition 33', 'Death Stranding 2: On the beach', 'Ghost of Yotei',
              'Hades 2', 'Split Fiction'
            ],
            'Melhor time de E-sports': [
              'Gen.G - League of legends', 'NRG - Valorant', 'Team Falcons - Dota 2',
              'Team Liquid PH - Mobile Legends: Bang bang', 'Team Vitality - Counter Strike 2'
            ],
            'Melhor atleta de esports': [
              'Brawk', 'Chovy', 'Forsaken', 'Kakeru', 'Menard', 'Zywoo'
            ],
            'Melhor jogo de esports': [
              'Counter Strike 2', 'Dota 2', 'League of legends', 'Mobile legends: Bang bang', 'Valorant'
            ],
            'Melhor jogo de esporte/corrida': [
              'EA FC 26', 'F1 25', 'Mario Kart World', 'Rematch', 'Sonic Racing: CrossWorlds'
            ],
            'Melhor jogo de simulação/estratégia': [
              'The Alters', 'Final Fantasy Tactics - The Ivalice chronicles', 'Jurassic World Evolution 3',
              'Civilization 7', 'Tempest rising', 'Two point museum'
            ],
            'Melhor jogo para a família': [
              'Donkey Kong Bananza', 'Lego Party!', 'Lego Voyagers', 'Mario Kart World',
              'Sonic Racing: CrossWorlds', 'Split Fiction'
            ],
            'Inovação em acessibilidade': [
              "Assassin's Creed Shadows", 'Atomfall', 'Doom: The dark ages', 'FC 26', 'South of midnight'
            ],
            'Melhor jogo de ação': [
              'Battlefield 6', 'Doom: The dark ages', 'Hades 2', 'Ninja Gaiden 4', 'Shinobi: Art of vengeance'
            ],
            'Melhor jogo de luta': [
              '2XKO', 'Capcom Fighting Collection 2', 'Fatal Fury: City of the wolves',
              'Mortal Kombat: Legacy kollection', 'Virtua Fighter 5 R.E.V.O. World Stage'
            ],
            'Melhor jogo de RPG': [
              'Avowed', 'Clair Obscur: Expedition 33', 'Kingdom Come: Deliverance 2',
              'Monster Hunter Wilds', 'The Outer Worlds 2'
            ],
            'Melhor jogo de ação/aventura': [
              'Death Stranding 2: On the beach', 'Ghost of Yotei', 'Hollow Knight: Silksong',
              'Indiana Jones and the great circle', 'Split Fiction'
            ],
            'Jogo mais aguardado': [
              '007: First light', 'Grand theft auto 6', "Marvel's Wolverine",
              'Resident Evil: Requiem', 'The Witcher 4'
            ],
            'Criador de conteúdo do ano': [
              'Caedrel', 'Kai Cenat', 'Moistcr1tikal', 'Sakura Miko', 'The Burnt Peanut'
            ],
            'Melhor jogo de VR/AR': [
              'Alien: Rogue Incursion', 'Arken Age', 'Ghost town', "Marvel's Deadpool VR", 'The midnight walk'
            ],
            'Melhor jogo de estreia independente': [
              'Blue Prince', 'Clair Obscur: Expedition 33', 'Despelote', 'Dispatch', 'Megabonk'
            ],
            'Melhor jogo independente': [
              'Absolum', 'Ball x Pit', 'Blue Prince', 'Clair Obscur: Expedition 33',
              'Hades 2', 'Hollow Knight: Silksong'
            ],
            'Melhor multiplayer': [
              'Arc Raiders', 'Battlefield 6', 'Elden Ring: Nightreign', 'Peak', 'Split Fiction'
            ],
            'Games for impact': [
              'Consume me', 'Despelote', 'Lost records: Bloom & rage', 'South of midnight', 'Wanderstop'
            ],
            'Melhor apoio à comunidade': [
              "Baldur's Gate 3", 'Final Fantasy 14', 'Fortnite', 'Helldivers 2', "No man's sky"
            ],
            'Melhor narrativa': [
              'Clair Obscur: Expedition 33', 'Death Stranding 2: On the beach', 'Ghost of Yotei',
              'Kingdom Come: Deliverance 2', 'Silent Hill f'
            ],
            'Melhor adaptação': [
              'Um filme Minecraft', 'Devil May Cry', 'Splinter Cell: Deathwatch', 'The last of us', 'Untill Dawn'
            ],
            'Melhor direção de som': [
              'Battlefield 6', 'Clair Obscur: Expedition 33', 'Death Stranding 2: On the beach',
              'Ghost of Yotei', 'Silent Hill f'
            ],
            'Melhor trilha e música': [
              "Christopher Larkin - Hollow Knight: Silksong",
              "Darren Korb - Hades 2",
              "Lorien Testard - Clair Obscur: Expedition 33",
              "Toma Otowa - Ghost of Yotei",
              "Woodkid & Ludvig Forssell - Death Stranding 2: On the beach"
            ],
            'Melhor direção de arte': [
              'Clair Obscur: Expedition 33', 'Death Stranding 2: On the beach', 'Ghost of Yotei',
              'Hades 2', 'Hollow Knight: Silksong'
            ],
            'Melhor jogo para dispositivos móveis': [
              'Destiny rising', 'Persona 5: The Phantom X', 'Sonic Rumble',
              'Umamusume: Pretty derby', 'Wuthering waves'
            ],
            'Melhor jogo em atualização': [
              'Final Fantasy 14', 'Fortnite', 'Helldivers 2', 'Marvel Rivals', "No man's sky"
            ],
            'Melhor atuação': [
              "Ben Starr - Clair Obscur: Expedition 33",
              "Charlie Cox - Clair Obscur: Expedition 33",
              "Erika Ishii - Ghost of Yotei",
              "Jennifer English - Clair Obscur: Expedition 33",
              "Konatsu Kato - Silent Hill f",
              "Troy Baker - Indiana Jones and the great circle"
            ]
          };

          Map<String, int> gameIdCache = {};

          for (var entry in categoriesData.entries) {
            String catTitle = entry.key;
            List<String> nominees = entry.value;

            int catId = await db.rawInsert(
              "INSERT INTO category(title, description, date, user_id) VALUES(?, ?, '2025', 1)",
              [catTitle, "Votação oficial TGA 2025"]
            );

            for (String nomineeName in nominees) {
              int gameId;
              String cleanName = nomineeName.replaceAll(RegExp(r"^'|'$"), "");

              if (gameIdCache.containsKey(cleanName)) {
                gameId = gameIdCache[cleanName]!;
              } else {
                var res = await db.rawQuery("SELECT id FROM game WHERE name = ?", [cleanName]);
                if (res.isNotEmpty) {
                  gameId = res.first['id'] as int;
                } else {
                  gameId = await db.rawInsert(
                    "INSERT INTO game(user_id, name, description, release_date) VALUES(1, ?, 'Nomeado TGA 2025', '2025')",
                    [cleanName]
                  );
                }
                gameIdCache[cleanName] = gameId;
              }

              await db.rawInsert(
                "INSERT INTO category_game(category_id, game_id) VALUES(?, ?)",
                [catId, gameId]
              );
            }
          }
        }
      )
    );

    return db;
  }
}