import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tap2024/models/popular_model.dart';

class ApiPopular {
  final String apiKey = '5019e68de7bc112f4e4337a500b96c56';
  final String sessionId = 'your_session_id_here'; // Añade tu session ID aquí
  final String language = 'es-MX';
  final String listId = 'your_list_id_here'; // Añade tu list ID aquí

  Uri getPopularUri() {
    return Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=$language&page=1');
  }

  Uri getTrailerUri(int movieId) {
    return Uri.parse('https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey&language=$language');
  }

  Uri getActorsUri(int movieId) {
    return Uri.parse('https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey&language=$language');
  }

  Uri addFavoriteUri() {
    return Uri.parse('https://api.themoviedb.org/3/list/$listId/add_item?api_key=$apiKey&session_id=$sessionId');
  }

  Uri removeFavoriteUri() {
    return Uri.parse('https://api.themoviedb.org/3/list/$listId/remove_item?api_key=$apiKey&session_id=$sessionId');
  }

  Uri getFavoritesUri() {
    return Uri.parse('https://api.themoviedb.org/3/list/$listId?api_key=$apiKey&language=$language');
  }

  Future<List<PopularModel>?> getAllPopular() async {
    final response = await http.get(getPopularUri());
    if (response.statusCode == 200) {
      final jsonPopular = jsonDecode(response.body)['results'] as List;
      List<PopularModel> movies = await Future.wait(jsonPopular.map((popular) async {
        final movie = PopularModel.fromMap(popular);
        movie.trailerId = await getTrailerId(movie.id);
        movie.actors = await getActors(movie.id);
        return movie;
      }).toList());
      return movies;
    }
    return null;
  }

  Future<String> getTrailerId(int movieId) async {
    final response = await http.get(getTrailerUri(movieId));
    if (response.statusCode == 200) {
      final videos = jsonDecode(response.body)['results'] as List;
      for (var video in videos) {
        if (video['site'] == 'YouTube' && video['type'] == 'Trailer') {
          return video['key'];
        }
      }
    }
    return '';
  }

  Future<List<Actor>> getActors(int movieId) async {
    final response = await http.get(getActorsUri(movieId));
    if (response.statusCode == 200) {
      final credits = jsonDecode(response.body)['cast'] as List;
      List<Actor> actors = credits.map((actor) => Actor.fromMap(actor)).toList();
      return actors;
    }
    return [];
  }

  Future<bool> addToFavorites(int movieId) async {
    final response = await http.post(
      addFavoriteUri(),
      headers: {'Content-Type': 'application/json;charset=utf-8'},
      body: jsonEncode({'media_id': movieId}),
    );

    if (response.statusCode == 201) {
      print('Película añadida a favoritos correctamente');
      return true;
    } else {
      print('Error al añadir película a favoritos: ${response.body}');
      return false;
    }
  }

  Future<bool> removeFromFavorites(int movieId) async {
    final response = await http.post(
      removeFavoriteUri(),
      headers: {'Content-Type': 'application/json;charset=utf-8'},
      body: jsonEncode({'media_id': movieId}),
    );

    if (response.statusCode == 201) {
      print('Película eliminada de favoritos correctamente');
      return true;
    } else {
      print('Error al eliminar película de favoritos: ${response.body}');
      return false;
    }
  }

  Future<List<PopularModel>?> getFavorites() async {
    final response = await http.get(getFavoritesUri());
    if (response.statusCode == 200) {
      final jsonFavorites = jsonDecode(response.body)['items'] as List;
      List<PopularModel> favorites = jsonFavorites.map((favorite) => PopularModel.fromMap(favorite)).toList();
      return favorites;
    }
    return null;
  }
}
