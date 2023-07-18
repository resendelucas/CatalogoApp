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

    final path = join(databasePath, "data.db");

    Database db =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      String sql = """
            CREATE TABLE user(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL,
              email VARCHAR NOT NULL,
              password VARCHAR NOT NULL
            );

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

            CREATE TABLE genre(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL
            );

            CREATE TABLE video_genre(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              videoid INTEGER NOT NULL,
              genreid INTEGER NOT NULL,
              FOREIGN KEY(videoid) REFERENCES video(id),
              FOREIGN KEY(genreid) REFERENCES genre(id)
            );


            """;
      await db.execute(sql);
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

  Future<int> saveGenreDb(
    String name,
  ) async {
    Database db = await initDb();
    String sql = "SELECT id from genre WHERE name = '$name'";
    List res = await db.rawQuery(sql);
    if (res.isEmpty) {
      Map<String, dynamic> genreData = {
        "name": name,
      };

      int id = await db.insert("video", genreData);
      return id;
    }
    return res[0]["id"];
  }

  Future<void> saveVideo_GenreDb(String nameVideo, String nameGenre) async {
    Database db = await initDb();

    String sql1 = "SELECT id from video WHERE video.name = '$nameVideo'";
    List ret1 = await db.rawQuery(sql1);
    String sql2 = "SELECT id from genre WHERE genre.name = '$nameGenre'";
    List ret2 = await db.rawQuery(sql2);

    Map<String, dynamic> videoGenreData = {
      "videoid": ret1[0],
      "genreid": ret2[0]
    };

    int id = await db.insert("video_genre", videoGenreData);
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

    //Future<Map<String, List<VideoDb>>>
    Future<void> filterVideo(int type) async {
     Database db = await initDb();
     String sql =
         "SELECT * FROM video, video_genre WHERE type = '$type' and video.id = video_genre.videoid GROUP BY genreid";
     List<Map<String,Object?>> ret = await db.rawQuery(sql);
     print(ret[0]);
   }

  Future<void> insereDb() async {
    Database db = await initDb();
    String sql = """
        INSERT INTO video(name, description, type, ageRestriction, durationMinutes, thumbnailImageId, releaseDate) VALUES('Shrek', 'Descrição 1', 0, 'Livre', 92, 'https://upload.wikimedia.org/wikipedia/pt/7/78/Shrek_2_Poster.jpg', '18/06/2004');
        INSERT INTO video(name, description, type, ageRestriction, durationMinutes, thumbnailImageId, releaseDate) VALUES('Avatar', 'Descrição 2', 0, '12', 162, 'https://upload.wikimedia.org/wikipedia/pt/b/b0/Avatar-Teaser-Poster.jpg', '10/12/2009');
        INSERT INTO video(name, description, type, ageRestriction, durationMinutes, thumbnailImageId, releaseDate) VALUES('The last of us', 'Descrição 3', 1, '16 anos', 81, 'https://meups.com.br/wp-content/uploads/2022/11/Serie-de-The-Last-of-Us-3.jpg', '15/01/2023');
        INSERT INTO video(name, description, type, ageRestriction, durationMinutes, thumbnailImageId, releaseDate) VALUES('Madagascar', 'Descrição 4', 0, 'Livre', 86, 'https://upload.wikimedia.org/wikipedia/pt/3/36/Madagascar_Theatrical_Poster.jpg', '25/05/2005');


        INSERT INTO video_genre(videoid, genreid) VALUES ()      
      
      """;
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

    db.rawInsert(sql);
    saveVideo_GenreDb('Avatar', 'Aventura');
    saveVideo_GenreDb('Avatar', 'Ação');
    saveVideo_GenreDb('Avatar', 'Ficção');
    saveVideo_GenreDb('Shrek', 'Aventura');
    saveVideo_GenreDb('Shrek', 'Animação');
    saveVideo_GenreDb('Shrek', 'Comédia');
    saveVideo_GenreDb('Shrek', 'Fantasia');
    saveVideo_GenreDb('The last of us', 'Terror');
    saveVideo_GenreDb('Madagascar', 'Animação');


  }
}
