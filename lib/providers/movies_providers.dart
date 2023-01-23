
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/models/search_response.dart';

class MoviesProvider extends ChangeNotifier{

  final String _language = 'es-ES';
  final String _baseURL = 'api.themoviedb.org';
  final String _apiKey = '2d1b66d58882847d8e98c02a60244ced';

  List<Movie> onDisplay = [];
  List<Movie> populars = [];
  int _popularPage = 1;
  Debouncer debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _sugestionsStreamController = StreamController.broadcast();
  Stream<List<Movie>> get sugestionController => _sugestionsStreamController.stream; 

  Map<int, List<Cast>> movieCast = {};

  MoviesProvider(){
    getNowPlayingMovies();
    getPopularMovies();
  }

  Future<String> _getJSONData({ required String endURL, int? page = 1 }) async{
    final url = Uri.https(_baseURL, endURL, 
    {
      "api_key"  : _apiKey,
      "language" : _language,
      "page"     : '$page'
    });
    final response = await http.get(url);
    return response.body;
  } 

  getNowPlayingMovies() async{

    final jsonData = await _getJSONData(endURL: '3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplay =  nowPlayingResponse.results;

    notifyListeners();
  }

  getPopularMovies() async {

    final jsonData = await _getJSONData(endURL: '3/movie/popular', page: _popularPage);

    final popularResponse = PopularResponse.fromJson(jsonData);

    populars =  [...populars ,...popularResponse.results];

    if(popularResponse.totalPages > _popularPage){
      _popularPage++;
    }

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int id) async {

    if (movieCast.containsKey(id)) return movieCast[id]!;

    final jsonData = await _getJSONData(endURL: '3/movie/$id/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    movieCast[id] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies({required String query, int page = 1 }) async {
    final url = Uri.https(_baseURL, '3/search/movie', 
    {
      "api_key"  : _apiKey,
      "language" : _language,
      "page"     : '$page',
      "query"    : query
    });

    final response = await http.get(url);
    final movieSearch = SearchResponse.fromJson(response.body);

    return movieSearch.results;
  }


  void getSugestionByQuery (String query){
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final result = await searchMovies(query: value);
      _sugestionsStreamController.add(result);
    };

    final timer = Timer( const Duration(milliseconds: 300), () {debouncer.value = query;}); 

    Future.delayed( const Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}