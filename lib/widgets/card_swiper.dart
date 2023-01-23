import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import '../models/movie.dart';



class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  const CardSwiper({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    if ( movies.isEmpty) {
      return Container(
        width: double.infinity, 
        height: size.height * .5,
        child: const Center(child: CircularProgressIndicator()),);
    }

    return SizedBox(

      width: double.infinity,
      height: size.height * .5,

      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * .6,
        itemHeight: size.height * .4,

        itemBuilder: (context, index) {

          final movie = movies[index];
          movie.heroID = 'swiper-${movie.title}-${movie.id}';

          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroID!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  image: NetworkImage(movie.getFullPosterPath),
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  fadeInDuration: const Duration(seconds: 1),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}