import 'package:flutter/material.dart';
import 'package:tap2024/network/api_popular.dart';
import 'package:tap2024/models/popular_model.dart';
import 'package:tap2024/views/popular_view.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ApiPopular apiPopular = ApiPopular();
  List<PopularModel>? favorites;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() async {
    final favs = await apiPopular.getFavorites();
    setState(() {
      favorites = favs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Favoritos'),
      ),
      body: favorites == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: favorites?.length ?? 0,
              itemBuilder: (context, index) {
                final movie = favorites![index];
                return PopularView(popularModel: movie);
              },
            ),
    );
  }
}
