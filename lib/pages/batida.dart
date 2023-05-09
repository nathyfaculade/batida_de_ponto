import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await openDatabase(
    join(await getDatabasesPath(), 'pontos.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE pontos(id INTEGER PRIMARY KEY AUTOINCREMENT, latitude REAL, longitude REAL, horario TEXT)',
      );
    },
    version: 1,
  );
  runApp(MyApp(database: database));
}

openDatabase(String join, {required Function(dynamic db, dynamic version) onCreate, required int version}) {
}

getDatabasesPath() {
}

class MyApp extends StatelessWidget {
  final Database database;

  MyApp({required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Ponto',
      home: HomePage(database: database),
    );
  }
}

class HomePage extends StatefulWidget {
  final Database database;

  HomePage({required this.database});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Ponto'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _registrarPonto();
          },
          child: Text('Registrar Ponto'),
        ),
      ),
    );
  }

  Future<void> _registrarPonto() async {
    final position = await Geolocator.getCurrentPosition();
    final latitude = position.latitude;
    final longitude = position.longitude;
    final horario = DateTime.now().toString();
    await widget.database.insert(
      'pontos',
      {'latitude': latitude, 'longitude': longitude, 'horario': horario},
    );
  }
}
