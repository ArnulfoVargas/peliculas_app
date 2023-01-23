import 'package:flutter/material.dart';

import '../themes/themes.dart';

import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),

        slivers: <Widget>[
          _CustomAppBar(movie: movie,),
          SliverList(
            delegate: SliverChildListDelegate( 
              [
                _PosterTitle(movie: movie,),
                _Overview(movie: movie),
                CastingCard(id: movie.id,),
              ]
            )
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {

  final Movie movie;

  const _CustomAppBar({ required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Themes.primaryColor,
      expandedHeight: 200,
      pinned: true,
      floating: false,
  
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        expandedTitleScale: 1.3,
        centerTitle: true, 
        title: Container(
          color: Colors.black26,
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(movie.title, style: const TextStyle( fontSize: 25, ), textAlign: TextAlign.center,)),

        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'), 
          image: NetworkImage(movie.getFullBackdropPath),
          fit: BoxFit.cover,
          ),
        ),
      

    );
  }
}

class _PosterTitle extends StatelessWidget {

  final Movie movie;

  const _PosterTitle({required this.movie});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textOfContext = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
        Hero(
          tag: movie.heroID!,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(movie.getFullPosterPath), 
              width: size.width *0.3,),
          ),
        ),

        const SizedBox(width: 20,),
        
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.width *.5),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              Text(movie.title, style: textOfContext.headline5, overflow: TextOverflow.ellipsis, maxLines: 2,),
        
              const SizedBox(height: 5,),
        
              Text(movie.originalTitle, style: textOfContext.subtitle1, overflow: TextOverflow.ellipsis, maxLines: 2,),
        
              const SizedBox(height: 5),
        
              Row(children: [
                const Icon(Icons.star, color: Colors.amberAccent,),
                const SizedBox(width: 5,),
                Text(movie.voteAverage.toString(), style: textOfContext.caption,)
              ],)
            ],
          ),
        )
      ]),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),

      child: Text( movie.overview,
        style: Theme.of(context).textTheme.subtitle1,
        textAlign: TextAlign.justify,
        ),

    );
  }
}
