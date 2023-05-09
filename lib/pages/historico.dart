import 'package:database/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoricoPage extends StatefulWidget {
  final Database database;

  HistoricoPage({required this.database});

  @override
  _HistoricoPageState createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  late Future<List<Map<String, dynamic>>> _pontos;

  @override
  void initState() {
    super.initState();
    _pontos = _recuperarPontos() as Future<List<Map<String, dynamic>>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Registros'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _pontos,
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final ponto = snapshot.data![index];
                return ListTile(
                  title: Text(ponto['horario']),
                  subtitle: Text('Lat: ${ponto['latitude']} - Long: ${ponto['longitude']}'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar histórico de registros'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<Database> _recuperarPontos() async {
    final Database pontos = await widget.database;
    return pontos;
  }
}
