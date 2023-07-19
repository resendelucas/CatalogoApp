import 'package:catalogo_app/videoCard.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  static Database? _db;

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database> get db async {
    return _db ??= await initDb();
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, "dataBase.db");

    Database db =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute("""
            CREATE TABLE user(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL,
              email VARCHAR NOT NULL,
              password VARCHAR NOT NULL
            );""");

      await db.execute(""" 
          CREATE TABLE video(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL,
              description TEXT NOT NULL,
              type INTEGER NOT NULL,
              ageRestriction VARCHAR NOT NULL,
              durationMinutes INTEGER NOT NULL,
              thumbnailImageId VARCHAR NOT NULL,
              releaseDate TEXT NOT NULL
            );
      """);

      await db.execute(""" 
          CREATE TABLE genre(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL
            );
      """);

      await db.execute(""" 
          CREATE TABLE video_genre(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              videoid INTEGER NOT NULL,
              genreid INTEGER NOT NULL,
              FOREIGN KEY(videoid) REFERENCES video(id),
              FOREIGN KEY(genreid) REFERENCES genre(id)
            );
      """);
    });

    return db;
  }

  Future<void> saveVideoDb(
      String name,
      String description,
      int type,
      String ageRestriction,
      int durationMinutes,
      String thumbnailImageId,
      String releaseDate,
      List<String> genre) async {
    Database db = await initDb();

    Map<String, dynamic> videoData = {
      "name": name,
      "description": description,
      "type": type,
      "ageRestriction": ageRestriction,
      "durationMinutes": durationMinutes,
      "thumbnailImageId": thumbnailImageId,
      "releaseDate": releaseDate
    };

    int idVideo = await db.insert("video", videoData);
    for (String s in genre) {
      saveVideo_GenreDb(name, s);
    }
  }

  Future<void> saveGenreDb(
    String name,
  ) async {
    Database db = await initDb();
    //String sql = "SELECT id from genre WHERE name = '$name'";
    //List res = await db.rawQuery(sql);

    Map<String, dynamic> genreData = {
      "name": name,
    };

    int id = await db.insert('genre', genreData);

    print("Genero adicionado: $name");
  }

  Future<void> saveVideo_GenreDb(String nameVideo, String nameGenre) async {
    Database db = await initDb();

    String sql1 = "SELECT id from video WHERE name = '$nameVideo'";
    List ret1 = await db.rawQuery(sql1);
    int videoId = ret1[0]['id'];
    String sql2 = "SELECT id from genre WHERE name = '$nameGenre'";
    List ret2 = await db.rawQuery(sql2);
    int genreId = ret2[0]['id'];
    Map<String, dynamic> videoGenreData = {
      "videoid": videoId,
      "genreid": genreId,
    };

    int id = await db.insert('video_genre', videoGenreData);
  }

  Future<void> saveUserDb(String name, String email, String password) async {
    Database db = await initDb();

    Map<String, dynamic> userData = {
      "name": name,
      "email": email,
      "password": password
    };

    int id = await db.insert("user", userData);
    print("Id inserido: $id");
  }

  Future<bool> verifyUser(String user, String password) async {
    Database db = await initDb();
    String sql =
        "SELECT id FROM user WHERE email = '$user' and password = '$password'";
    List? users = await db.rawQuery(sql);
    if (users.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<VideoDb> searchVideo(String name) async {
    Database db = await initDb();
    String sql = "SELECT * FROM video WHERE name = '$name'";
    List ret = await db.rawQuery(sql);
    VideoDb v = VideoDb(
        ret[0]["id"],
        ret[0]["name"],
        ret[0]["description"],
        ret[0]["type"],
        ret[0]["ageRestriction"],
        ret[0]["durationMinutes"],
        ret[0]["thumbnailImageId"],
        ret[0]["releaseDate"]);

    print(v);
    return v;
  }

  //Future<Map<String, List<VideoDb>>>
  Future<List<VideoDb>> filterVideo(int type, {String? genre}) async {
    Database db = await initDb();
    String sql;
    if (genre == null) {
      sql = "SELECT * FROM video WHERE type = $type";
    } else {
      sql =
          "SELECT v.name FROM video v, video_genre vg, genre g WHERE v.id = vg.videoid and vg.genreid = g.id and g.name = '$genre' and type = $type;";
    }

    List<dynamic> ret = await db.rawQuery(sql);

    List<VideoDb> videos = [];
    for (int i = 0; i < ret.length; i++) {
      VideoDb video = await searchVideo(ret[i]['name']);
      videos.add(video);
    }
    return videos;
  }

  Future<void> insereDb() async {
    //Database db = await initDb();

    saveVideoDb(
        'Shrek',
        'Descrição 1',
        0,
        'Livre',
        92,
        'https://upload.wikimedia.org/wikipedia/pt/7/78/Shrek_2_Poster.jpg',
        '18/06/2004',
        ["Animação", "Comédia", "Fantasia"]);
    saveVideoDb(
        'Avatar',
        'Descrição 2',
        0,
        '12',
        162,
        'https://upload.wikimedia.org/wikipedia/pt/b/b0/Avatar-Teaser-Poster.jpg',
        '10/12/2009', [
      "Aventura",
      "Ação",
      "Ficção",
    ]);
    saveVideoDb(
        'The last of us',
        'Descrição 3',
        1,
        '16 anos',
        81,
        'https://meups.com.br/wp-content/uploads/2022/11/Serie-de-The-Last-of-Us-3.jpg',
        '15/01/2023',
        ["Terror"]);
    saveVideoDb(
        'Madagascar',
        'Descrição 4',
        0,
        'Livre',
        86,
        'https://upload.wikimedia.org/wikipedia/pt/3/36/Madagascar_Theatrical_Poster.jpg',
        '25/05/2005',
        ['Animação']);

    saveGenreDb('Suspense');
    saveGenreDb('Ação');
    saveGenreDb('Aventura');
    saveGenreDb('Comédia');
    saveGenreDb('Drama');
    saveGenreDb('Ficção');
    saveGenreDb('Romance');
    saveGenreDb('Terror');
    saveGenreDb('Animação');
    saveGenreDb('Documentário');
    saveGenreDb('Fantasia');
    saveGenreDb('Musical');
    saveGenreDb('Reality');
    saveGenreDb('Variedades');
  }

  listGenres() async {
    Database db = await initDb();
    String sql = "SELECT * from genre";
    List ret = await db.rawQuery(sql);
    print("Generos : $ret");
  }

  listVideos() async {
    Database db = await initDb();
    String sql = "SELECT * from video";
    List ret = await db.rawQuery(sql);
    print("Videos : $ret");
  }

  listVideo_Genres() async {
    Database db = await initDb();
    String sql = "SELECT videoid, genreid from video_genre";
    List ret = await db.rawQuery(sql);
    print("Video_genero : $ret");
  }
}

/*void deleteDatabase(String path) =>
    databaseFactory.deleteDatabase(path);
    */
