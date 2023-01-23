import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movies_providers.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate{

  @override
  String? get searchFieldLabel => "Buscar";

  @override
  List<Widget>? buildActions(BuildContext context) {

    if (query.isEmpty) return null;

    return [
      IconButton(
        onPressed: () => query = '', 
        icon: const Icon(Icons.clear_outlined))

    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null), 
      icon: const Icon(Icons.arrow_back_ios_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {

    if (query.isEmpty){
      return _emptyContainer(context);
    }

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return FutureBuilder(
      future: moviesProvider.searchMovies(query: query),
      builder: ((context, snapshot) {
        if(!snapshot.hasData){
          return _emptyContainer(context);
        }

        final movies = snapshot.data;

        return ListView.builder(
          itemCount: movies!.length,
          itemBuilder: (BuildContext context, int index) {
            return _MovieSearch(movie: movies[index], index: index,);
          },
        );
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty){
      return _emptyContainer(context);
    }

    final moviesProvider = Provider.of<MoviesProvider>(context);
    moviesProvider.getSugestionByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.sugestionController,
      builder: ((context, snapshot) {
        if(!snapshot.hasData){
          return _emptyContainer(context);
        }

        final movies = snapshot.data;

        return ListView.builder(
          itemCount: movies!.length,
          itemBuilder: (BuildContext context, int index) {
            return _MovieSearch(movie: movies[index], index: index,);
          },
        );
      }),
    );
  }


  Widget _emptyContainer( BuildContext context){
    return Container(
        child: Center(
          child: Icon(
            Icons.movie_creation_outlined, 
            size: MediaQuery.of(context).size.width * .5 ,
            color: Colors.black26,
          )
        ),
      );
  }
}

class _MovieSearch extends StatelessWidget {
  final Movie movie;
  final index;

  const _MovieSearch({super.key, required this.movie, required this.index});

  @override
  Widget build(BuildContext context) {

    movie.heroID = 'search-${movie.title}-$index-${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroID! ,
        child: FadeInImage(
            placeholder:  const AssetImage('assets/no-image.jpg'), 
            image: NetworkImage(movie.getFullPosterPath),
            width: 50,
            fit: BoxFit.contain,),
      ),
          title: Text(movie.title),
          subtitle: Text(movie.originalTitle),
          onTap: (() => Navigator.pushNamed(context, 'details', arguments: movie)),
    );
  }
}

