import 'package:Upmstyle/router/rooter.dart';
import 'package:Upmstyle/services/provider_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UserProvider(),
        child: MaterialApp(
          title: 'MGT-U',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            cardColor: Colors.purpleAccent,
            useMaterial3: true,
          ),
          initialRoute: "/",
          routes: getapp(),
        ));
  }
}
