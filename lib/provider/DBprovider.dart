

import 'dart:io';
import 'package:flutter_app_qrscanner/models/scan_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider{
  static Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future <Database> get database async {

    if (_database != null){
      return _database;
    }else{
      _database = await initDB();
      return _database;
    }
  }

  Future<Database> initDB() async{
    //path de donde almacenaremos la base de datos

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);

    //Crear Base de datos

    return await openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('''

          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipo TEXT,
            valor TEXT
          )
          
        ''');
        }
    );

  }

  Future <int> nuevoScan(ScanModel nuevoScan) async {

    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());

    return res;

  }

  Future <ScanModel> getScanPorId(int id) async {

    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty
        ? ScanModel.fromJson(res.first)
        : null;
  }

  Future <List<ScanModel>> getTodosLosScans() async {

    final db = await database;
    final res = await db.query('Scans');

    return res.isNotEmpty
        ? res.map((s) => ScanModel.fromJson(s)).toList()
        : null;
  }

  Future <List<ScanModel>> getScansPorTipo( String tipo) async {

    final db = await database;
    final res = await db.query('Scans', where: 'tipo = ?', whereArgs: [tipo]);

    return res.isNotEmpty
        ? res.map((s) => ScanModel.fromJson(s)).toList()
        : [];
  }

  Future <int> actualizarScan( ScanModel nuevoScan ) async {

    final db = await database;
    final res = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id]);
    return res;

  }

  Future <int> borrarScan ( int id ) async {

    final db = await database;
    final res = await db.delete( 'Scans', where: 'id = ?', whereArgs: [id] );
    return res;
  }

  Future <int> borrarTodosLosScan () async {

    final db = await database;
    final res = await db.delete( 'Scans' );
    return res;
  }
}