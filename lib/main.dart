import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:peliculas_app/providers/movies_providers.dart';
import 'package:peliculas_app/screens/screens.dart';
import 'package:peliculas_app/themes/themes.dart';


void main() => runApp(const AppState());


class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: ((context) => MoviesProvider()), lazy: false,)
    ],
    child: const MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas App',
      initialRoute: 'home',

      routes: {
        'home':(context) => const HomeScreen(),
        'details' :(context) => const DetailsScreen()
        },
        theme: Themes.lightTheme,
    );
  }
}