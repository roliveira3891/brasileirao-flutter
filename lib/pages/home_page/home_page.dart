import 'package:brasileirao_flutter/controllers/theme_controller.dart';
import 'package:brasileirao_flutter/models/time.dart';
import 'package:brasileirao_flutter/pages/home_page/home_controller.dart';
import 'package:brasileirao_flutter/pages/time_page/time_page.dart';
import 'package:brasileirao_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var controller;
  var controllerTheme = ThemeController.to;

  @override
  void initState() {
    super.initState();
    controller = HomeController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brassileirão'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Obx(() => controllerTheme.isDark.value
                      ? Icon(Icons.brightness_7)
                      : Icon(Icons.brightness_3)),
                  title: Obx(() => controllerTheme.isDark.value
                      ? Text('Light')
                      : Text('Dark')),
                  onTap: () => controllerTheme.changeTheme(),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sair'),
                  onTap: () {
                    Navigator.pop(context);
                    AuthService.to.logout();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: controller.tabela.length,
        itemBuilder: (BuildContext contexto, int time) {
          final List<Time> tabela = controller.tabela;
          return ListTile(
            leading: Image.network(tabela[time].brasao),
            title: Text(tabela[time].nome),
            trailing: Text(tabela[time].pontos.toString()),
            onTap: () {
              Navigator.push(
                contexto,
                MaterialPageRoute(
                  builder: (_) => TimePage(
                    key: Key(tabela[time].nome),
                    time: tabela[time],
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (_, __) => Divider(),
        padding: EdgeInsets.all(16),
      ),
    );
  }
}
