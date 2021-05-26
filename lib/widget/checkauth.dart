import 'package:brasileirao_flutter/pages/autenticacao_page/autenticacao_page.dart';
import 'package:brasileirao_flutter/pages/home_page/home_page.dart';
import 'package:brasileirao_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AuthService.to.userIsAuthenticated.value
        ? HomePage()
        : AutenticacaoPage());
  }
}
