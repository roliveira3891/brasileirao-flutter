import 'package:brasileirao_flutter/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AutenticacaoController extends GetxController {
  final email = TextEditingController();
  final senha = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var titulo = "Bem Vindo! ".obs;
  var botaoPrincipal = 'Entrar '.obs;
  var appBarButton = 'Cadastra-se'.obs;
  var isLogin = true.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(isLogin, (visible) {
      titulo.value = visible ? 'Bem Vindo' : 'Crie sua conta';
      botaoPrincipal.value = visible ? 'Entrar' : 'Registra-se';
      appBarButton.value = visible ? 'Cadastre-se' : 'Login';
      formKey.currentState.reset();
    });
  }

  login() async {
    isLoading.value = true;
    print('O email e ${email.text} e senha ${senha.text}');
    await AuthService.to.login(email.text, senha.text);
    isLoading.value = false;
  }

  registrar() async {
    isLoading.value = true;
    print('O email e ${email.text} e senha ${senha.text}');
    await AuthService.to.createUser(email.text, senha.text);
    isLoading.value = false;
  }

  toogleRegister() {
    isLogin.value = !isLogin.value;
  }
}
