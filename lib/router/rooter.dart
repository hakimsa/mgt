import 'package:Upmstyle/widgets/Menu.dart';
import 'package:Upmstyle/widgets/add_user.dart';
import 'package:Upmstyle/widgets/loginWidget.dart';
import 'package:flutter/material.dart';
import '../views/home_page.dart';
import '../views/news.dart';

Map<String, WidgetBuilder> getapp() {
  return <String, WidgetBuilder>{
    "/": (_) => const HomePage(),
    "Nove": (_) => AboutWidget(),
    "menu": (_) => const Menu(),
    "login": (_) => LoginWidget(),
    "add": (_) => const AddUser(),
  };
}
