import 'package:brasileirao_flutter/database/db_firestore.dart';
import 'package:brasileirao_flutter/models/titulo.dart';
import 'package:brasileirao_flutter/pages/add_titulo_page/add_titulo_page.dart';
import 'package:brasileirao_flutter/repositories/times_repository.dart';
import 'package:brasileirao_flutter/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:brasileirao_flutter/models/time.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TimePage extends StatefulWidget {
  final Time time;

  TimePage({Key key, this.time}) : super(key: key);

  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  FirebaseFirestore db;

  Stream<DocumentSnapshot> torcedoresSnapshot;

  @override
  void initState() {
    super.initState();

    db = DBFirestore.get();

    torcedoresSnapshot = db.doc('times/${widget.time.id}').snapshots();
  }

  tituloPage() {
    Get.to(() => AddTituloPage(time: widget.time));
  }

  addTitulo(Titulo titulo) {
    setState(() {
      widget.time.titulos.add(titulo);
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Salvo com Sucesso'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.time.cor,
          title: Text(widget.time.nome),
          actions: [IconButton(icon: Icon(Icons.add), onPressed: tituloPage)],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.stacked_line_chart),
                text: 'Estatisticas',
              ),
              Tab(
                icon: Icon(Icons.emoji_events),
                text: 'Titulos',
              ),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Image.network(
                    widget.time.brasao.replaceAll("40x40", "100x100"),
                  ),
                ),
                Text(
                  'Pontos: ${widget.time.pontos}',
                  style: TextStyle(fontSize: 22),
                ),
                Text(
                  AuthService.to.user.email,
                ),
              ],
            ),
            titulos(),
          ],
        ),
      ),
    );
  }

  Widget titulos() {
    final time = Provider.of<TimesRepository>(context)
        .times
        .firstWhere((t) => t.nome == widget.time.nome);

    final quantidade = time.titulos.length;

    return quantidade == 0
        ? Container(
            child: Center(
            child: Text('Nenhum Titulo Ainda'),
          ))
        : ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(Icons.emoji_events),
                title: Text(time.titulos[index].campeonato),
                trailing: Text(time.titulos[index].ano),
                onTap: () {
                  Get.to(
                    () => {},
                    fullscreenDialog: true,
                  );
                },
              );
            },
            separatorBuilder: (_, __) => Divider(),
            itemCount: quantidade,
          );
  }
}
