import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movies_providers.dart';
import 'package:provider/provider.dart';

class CastingCard extends StatelessWidget {
  final int id;

  const CastingCard({super.key, required this.id});

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(this.id),
      builder: ((context, snapshot) 
      { if (!snapshot.hasData){
          return Container(
            width: double.infinity, 
            height: 180, 
            child: const Center(
              child: SizedBox(child: CircularProgressIndicator(), height: 50, width: 50,),
            ),);

        }

        final cast = snapshot.data;

        return Container(
          width: double.infinity,
          height: 180,
          margin: const EdgeInsets.only(bottom: 30),
          child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: cast!.length,
          itemBuilder: (BuildContext context, int index) {
            return _CastCard(castActor: cast[index],);
            },
          ),
        );
      } )
    );
  }
}

class _CastCard extends StatelessWidget {

  final Cast castActor;

  const _CastCard({required this.castActor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10),

      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'), 
              image: NetworkImage(castActor.getFullProfilePath),
              width: 100,
              height: 140,
              fit: BoxFit.cover,
            )
          ),

          const SizedBox(height: 5,),

          Text(castActor.name, 
            maxLines: 2, 
            overflow: TextOverflow.ellipsis, 
            style: Theme.of(context).textTheme.subtitle2,
            textAlign: TextAlign.center,)
        ]
      ),
    );
  }
}