import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';

class MovieSlider extends StatefulWidget {

  final List<Movie> popularMovies;
  final String? descriptionText;
  final Function onNextPage;

  const MovieSlider({super.key, required this.popularMovies, this.descriptionText, required this.onNextPage});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() { 
      if ( scrollController.position.pixels + 500 >= scrollController.position.maxScrollExtent){
        widget.onNextPage();
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: 275,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if(widget.descriptionText != null)
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(widget.descriptionText!,
              style: const TextStyle( 
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),),
          ),

          const SizedBox(height: 5,),

          if ( widget.popularMovies.isNotEmpty )
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal ,
              itemCount: widget.popularMovies.length,
              itemBuilder: (BuildContext context, int index) => _MovieContainer(movie: widget.popularMovies[index], index: index,)
            ),
          ) else const Expanded(child: Center( child: CircularProgressIndicator(),))
        ,
        ]
      ),
    );
  }
}

class _MovieContainer extends StatelessWidget {

  final Movie movie;
  final index;

  const _MovieContainer({required this.movie, required this.index});

  @override
  Widget build(BuildContext context) {

    movie.heroID = 'slider-${movie.id}-${movie.title}-$index';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 130,
      height: 200,
      child: Column(
        children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
          child: Hero(
            tag: movie.heroID!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
                  
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(movie.getFullPosterPath),
                fit: BoxFit.cover,
                width: 130,
                height: 190,),
            ),
          ),
        ),

        const SizedBox(height: 5,),
        
        Expanded(
          child: Text(movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
            ),
        )
      ]),
    );
  }
}