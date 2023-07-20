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

    int id = await db.insert("video", videoData);
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

  Future<List<String>> genresByVideo(String name) async {
    Database db = await initDb();
    String sql =
        "SELECT genre.name from video, video_genre, genre WHERE video.id = video_genre.videoid and video_genre.genreid = genre.id and video.name = '$name'";
    List ret = await db.rawQuery(sql);
    List<String> genres = [];
    for (var r in ret) {
      genres.add(r["name"]);
    }
    return genres;
  }

  Future<void> modifyVideo(
      int id,
      String name,
      String description,
      int type,
      String ageRestriction,
      int durationMinutes,
      String thumbnailImageId,
      String releaseDate) async {
    Database db = await initDb();
    String sql = """UPDATE video 
    SET name = ?, 
    description = ?, 
    type = ?, 
    ageRestriction = ?, 
    durationMinutes = ? , 
    thumbnailImageId = ?, 
    releaseDate = ?
    WHERE id = ?;""";
    int n = await db.rawUpdate(sql, [
      name,
      description,
      type,
      ageRestriction,
      durationMinutes,
      thumbnailImageId,
      releaseDate,
      id
    ]);
  }

  Future<VideoDb> searchVideo(String name) async {
    //essa funcao eh auxiliar da funcao filtervideo()
    Database db = await initDb();
    String sql = "SELECT * FROM video WHERE name = '$name'";
    List ret = await db.rawQuery(sql);
    List<String> generos = await genresByVideo(ret[0]["name"]);
    VideoDb v = VideoDb(
        ret[0]["id"],
        ret[0]["name"],
        ret[0]["description"],
        ret[0]["type"],
        ret[0]["ageRestriction"],
        ret[0]["durationMinutes"],
        ret[0]["thumbnailImageId"],
        ret[0]["releaseDate"],
        generos);
    return v;
  }

  Future<List<VideoDb>> filterVideo(int type, String nameSearched,
      {String? genre}) async {
    Database db = await initDb();
    String sql;
    if (nameSearched == "") nameSearched = "%";
    if (genre == "Todos") genre = "%";
    if (type == 2) {
      sql =
          "SELECT distinct v.name FROM video v, video_genre vg, genre g WHERE v.id = vg.videoid and vg.genreid = g.id and g.name like '$genre' and v.name like '%$nameSearched%';";
    } else {
      sql =
          "SELECT distinct v.name FROM video v, video_genre vg, genre g WHERE v.id = vg.videoid and vg.genreid = g.id and g.name like '$genre' and type = $type and v.name like '%$nameSearched%';";
    }

    List<dynamic> ret = await db.rawQuery(sql);
    List<VideoDb> videos = [];
    for (int i = 0; i < ret.length; i++) {
      VideoDb video = await searchVideo(ret[i]['name']);
      videos.add(video);
    }
    return videos;
  }

  Future<void> autoPopulateDb() async {
    Database db = await initDb();
    String sql = "select * from video;";
    List ret = await db.rawQuery(sql);
    if (ret.isNotEmpty) return;

    saveGenreDb('Suspense');
    saveGenreDb('Ação');
    saveGenreDb('Aventura');
    saveGenreDb('Comédia');
    saveGenreDb('Crime');
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
    saveGenreDb('Guerra');
    saveGenreDb('Sobrevivência');
    saveGenreDb('Mistério');
    saveGenreDb('Esportes');
    saveGenreDb('Policial');

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
    saveVideoDb(
        'Parasita',
        'Descrição 5',
        0,
        '16',
        132,
        'https://veja.abril.com.br/wp-content/uploads/2020/02/poster-filme-parasite.jpg?quality=70&strip=info',
        '30/05/2019',
        ["Suspense", "Drama"]);
    saveVideoDb(
        'Pearl Harbor',
        'Descrição 6',
        0,
        '14',
        183,
        'https://upload.wikimedia.org/wikipedia/pt/thumb/a/ae/Pearl_Harbor_filme.jpg/250px-Pearl_Harbor_filme.jpg',
        '21/05/2001',
        ["Drama", "Romance", "Guerra"]);
    saveVideoDb(
        'Alice in Borderland',
        'Descrição 7',
        1,
        '16',
        50,
        'https://m.media-amazon.com/images/M/MV5BZmUwMGI4M2QtYmRlYy00NDQ1LThjNDAtYTI4NDNiNDg5MDViXkEyXkFqcGdeQXVyMzgxODM4NjM@._V1_.jpg',
        '10/12/2020',
        ["Suspense", "Drama", "Sobrevivência", "Ficção"]);
    saveVideoDb(
        'All of Us Are Dead',
        'Descrição 8',
        1,
        '18',
        60,
        'https://image.tmdb.org/t/p/original/8gjbGKe5WNOaLrkoeOUPLvDhPhK.jpg',
        '28/01/2022',
        ["Terror", "Suspense", "Drama"]);
    saveVideoDb(
        'The Flash',
        'Descrição 9',
        0,
        '14',
        144,
        'https://i0.wp.com/cloud.estacaonerd.com/wp-content/uploads/2023/04/25143827/FuktbO-WwAAtXbu.jpg?fit=1638%2C2048&ssl=1',
        '15/06/2023',
        ["Ação", "Ficção", "Fantasia"]);
    saveVideoDb(
        'Stephen Curry: Underrated',
        'Descrição 10',
        0,
        '12',
        110,
        'https://m.media-amazon.com/images/M/MV5BM2M3NmNkMjktNTc2MS00NjRiLTk0NmEtNDRiNzFlNGFiNGQ4XkEyXkFqcGdeQXVyMDc5ODIzMw@@._V1_.jpg',
        '21/07/2023',
        ["Documentário", "Esportes"]);
    saveVideoDb(
        'The Big Bang Theory',
        'Descrição 11',
        1,
        '10',
        22,
        'https://img.posterstore.com/zoom/wb0174-8thebigbangtheory-thegroup50x70.jpg',
        '24/09/2007',
        ["Comédia"]);
    saveVideoDb(
        'No Dia do Seu Casamento',
        'Descrição 12',
        0,
        '14',
        110,
        'https://br.web.img2.acsta.net/c_310_420/pictures/22/01/31/18/00/1786077.jpg',
        '22/08/2018',
        ["Comédia", "Romance"]);
    saveVideoDb(
        'Sweet & Sour',
        'Descrição 13',
        0,
        '14',
        101,
        'https://image.tmdb.org/t/p/w500/3yGwAPl6LWpi8QwHjwCMaqsPgNB.jpg',
        '04/06/2021',
        ["Comédia", "Romance"]);
    saveVideoDb(
        'Vincenzo',
        'Descrição 14',
        1,
        '14',
        80,
        'https://upload.wikimedia.org/wikipedia/pt/5/5b/Vincenzo_TV_series.jpg',
        '20/02/2021',
        ["Crime", "Comédia", "Romance"]);
    saveVideoDb(
        'A Ligação',
        'Descrição 15',
        0,
        '16',
        112,
        'https://media.fstatic.com/5yHdfAHz7rS-ItxiPKBOI-sbhCo=/322x478/smart/filters:format(webp)/media/movies/covers/2023/06/images_HTzZRPj.jpeg',
        '27/11/2020',
        ["Terror", "Suspense", "Mistério"]);
    saveVideoDb(
        'Hotel Del Luna',
        'Descrição 16',
        1,
        '14',
        80,
        'https://media.fstatic.com/5HV8rZWrJNMv6M8txYd6d_K0o_8=/210x312/smart/filters:format(webp)/media/movies/covers/2021/09/16610.jpg',
        '13/07/2019',
        ["Fantasia", "Comédia", "Romance", "Drama"]);
    saveVideoDb(
        'Stranger Things',
        'Descrição 17',
        1,
        '14',
        51,
        'https://img.elo7.com.br/product/original/3041510/big-poster-serie-stranger-things-netflix-lo001-90x60-cm-geek.jpg',
        '15/07/2016',
        ["Ficção", "Terror", "Suspense", "Drama", "Fantasia"]);
    saveVideoDb(
        'Pokémon',
        'Descrição 18',
        1,
        'Livre',
        24,
        'https://image.tmdb.org/t/p/w500/f14a75WxUcKBu7nPBQjyJufIFuC.jpg',
        '01/04/1997',
        ["Animação", "Aventura", "Ação"]);
    saveVideoDb(
        'Solteiros, Ilhados e Desesperados',
        'Descrição 19',
        1,
        '10',
        64,
        'http://www.impawards.com/intl/south_korea/tv/posters/singles_inferno_xlg.jpg',
        '18/12/2021',
        ["Reality", "Romance"]);
    saveVideoDb(
        'MasterChef Junior',
        'Descrição 20',
        1,
        '12',
        60,
        'https://image.tmdb.org/t/p/original/nEPbBjpJq7i7Mx6WO92NNG0vo5V.jpg',
        '27/09/2013',
        ["Reality", "Variedades"]);
    saveVideoDb(
        'Besouro Azul',
        'Descrição 21',
        0,
        '14',
        127,
        'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiOriqjXE8YJkwlO10RWG3FNeT5Hslcectcs0fzfc8fDaz6bCwLu7hcJRJquaOp4TYKm2UMcldqsydOGX58nEdd-TjNOW-LoNuyaeq07szDWCw-FuUJzbz3GDqnQqj2Ao16o7Q4g1C0tbpEDnldnTILG-pc1XJAUepL9vb0zMfbdKTMZjXNPSYxG-aNtQ/s800/bzrazl02.jpg',
        '17/08/2023',
        ["Ação", "Aventura", "Fantasia", "Ficção"]);
    saveVideoDb(
        'Doutor Estranho',
        'Descrição 22',
        0,
        '12',
        115,
        'https://img.elo7.com.br/product/zoom/2665614/big-poster-filme-doutor-estranho-lo02-tamanho-90x60-cm-poster.jpg',
        '02/11/2016',
        ["Ação", "Aventura", "Fantasia"]);
    saveVideoDb(
        'Desgraça ao Seu Dispor',
        'Descrição 23',
        1,
        '14',
        65,
        'https://br.web.img3.acsta.net/r_1280_720/pictures/23/07/10/17/20/4666781.jpg',
        '10/05/2021',
        ["Drama", "Romance", "Fantasia"]);
    saveVideoDb(
        'Velozes e Furiosos 10',
        'Descrição 24',
        0,
        '14',
        141,
        'https://s2-gshow.glbimg.com/srEPJBTXJB3_KKThSe0zUSBdlz8=/0x0:1080x1351/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_e84042ef78cb4708aeebdf1c68c6cbd6/internal_photos/bs/2023/Q/g/IPSDQ1SVKCAFBEjZsj0w/vin-diesel-poster.jpg',
        '18/05/2023',
        ["Ação", "Aventura"]);
    saveVideoDb(
        'Batman: O Cavaleiro das Trevas',
        'Descrição 25',
        0,
        '12',
        152,
        'https://img.elo7.com.br/product/original/264FCC6/big-poster-filme-batman-o-cavaleiro-das-trevas-lo02-90x60-cm-batman.jpg',
        '18/07/2008',
        ["Ação", "Suspense", "Policial"]);
    saveVideoDb(
        'The Mandalorian',
        'Descrição 26',
        1,
        '12',
        40,
        'https://lumiere-a.akamaihd.net/v1/images/the_mandalorian_800d1505.jpeg',
        '12/11/2019',
        ["Ação", "Aventura", "Fantasia", "Ficção"]);
  }

  listGenres() async {
    Database db = await initDb();
    //String sql = "SELECT * from genre";
    String sql = "SELECT * from genre where id = 234";
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