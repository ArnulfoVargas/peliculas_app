import 'package:flutter/material.dart';

import 'package:peliculas_app/providers/movies_providers.dart';
import 'package:provider/provider.dart';

import 'package:peliculas_app/search/search_delegate.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);


    return Scaffold(
      appBar: AppBar(
        title: const Text("Peliculas en cines"),
        actions: [
          IconButton(
            onPressed: (() => showSearch(context: context, delegate: MovieSearchDelegate())), 
            icon: const Icon(Icons.search_outlined))
        ],
        ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            //Tarjetas Pricipales
            CardSwiper(movies: moviesProvider.onDisplay,),
            //Slider de peliculas
            MovieSlider(popularMovies: moviesProvider.populars, descriptionText: "Populares", onNextPage: moviesProvider.getPopularMovies),
          ],
        ),
      )
    );
  }
}