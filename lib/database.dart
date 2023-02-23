import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  Database? db;

  Future open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'db.db');

    log("PATH  <=======>  $path");

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("""
                    CREATE TABLE IF NOT EXISTS pending(
                          id primary key,
                          title varchar(255) not null,
                          description varchar(255) not null,
                          amount varchar(255) not null,
                          deadline varchar(255) not null
                      );
                      """);

      await db.execute("""
                    CREATE TABLE IF NOT EXISTS completed(
                          id primary key,
                          title varchar(255) not null,
                          description varchar(255) not null,
                          amount varchar(255) not null,
                          deadline varchar(255) not null
                      );
                      """);

      //create more table here

      log("Table Created");
    });
  }
}
