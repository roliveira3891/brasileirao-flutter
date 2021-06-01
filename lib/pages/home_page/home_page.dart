import 'package:brasileirao_flutter/controllers/theme_controller.dart';
import 'package:brasileirao_flutter/models/time.dart';
//import 'package:brasileirao_flutter/pages/home_page/home_controller.dart';
import 'package:brasileirao_flutter/pages/time_page/time_page.dart';
import 'package:brasileirao_flutter/repositories/times_repository.dart';
import 'package:brasileirao_flutter/services/auth_service.dart';
import 'package:brasileirao_flutter/widget/brasao.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //var controller;
  var controller = ThemeController.to;

  showEscolherTime() {
    Get.back();
    final times = Provider.of<TimesRepository>(context, listen: false).times;
    List<SimpleDialogOption> items = [];

    times.forEach((time) {
      items.add(SimpleDialogOption(
        child: Row(
          children: [
            Brasao(
              image: time.brasao,
              width: 30,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16.0,
              ),
              child: Text(time.nome),
            )
          ],
        ),
        onPressed: () => {
          Get.find<AuthService>().definirTime(time),
          Get.back(),
        },
      ));
    });

    final SimpleDialog dialog = SimpleDialog(
      title: Text('Escolha sua Torcida'),
      children: items,
      insetPadding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height / 6,
      ),
    );

    showDialog(context: context, builder: (_) => dialog);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   controller = HomeController();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Consumer<TimesRepository>(builder: (context, repositorio, child) {
          return repositorio.loading.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                    Text('Atualizando'),
                  ],
                )
              : Text('Tabela Brasileirão');
        }),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Obx(() => controller.isDark.value
                      ? Icon(Icons.brightness_7)
                      : Icon(Icons.brightness_3)),
                  title: Obx(() =>
                      controller.isDark.value ? Text('Light') : Text('Dark')),
                  onTap: () => controller.changeTheme(),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.sports_soccer),
                  title: Text('Escolher Time'),
                  onTap: () => showEscolherTime(),
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
      body: Consumer<TimesRepository>(
        builder: (context, repositorio, child) {
          return RefreshIndicator(
            child: ListView.separated(
              itemCount: repositorio.times.length,
              itemBuilder: (BuildContext contexto, int time) {
                print(repositorio.times.length);
                final List<Time> tabela = repositorio.times;
                return ListTile(
                  leading: Image.network(tabela[time].brasao),
                  title: Text(tabela[time].nome),
                  subtitle: Text('Titulos: ${tabela[time].titulos.length}'),
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
            onRefresh: () => repositorio.updateTabela(),
          );
        },
      ),
    );
  }
}
