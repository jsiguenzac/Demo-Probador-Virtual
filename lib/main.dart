import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'utils/token.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Crear un GlobalKey para obtener un contexto válidostatic final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // eliminar token al cerrar la app
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // La aplicación se está cerrando completamente
      Token.clearToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialApp(
        title: 'Demo - Entregable',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 198, 152, 54)),
          useMaterial3: true,
        ),
        navigatorKey: navigatorKey,
        home: const MyHomePage(),
      )
    );
  }
}
