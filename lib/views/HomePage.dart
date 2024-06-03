import 'package:flutter/material.dart';
import 'package:tap2024/network/api_popular.dart';
import 'package:tap2024/models/popular_model.dart';
import 'package:tap2024/views/popular_view.dart';
import 'favorites_screen.dart';

class HomePage extends StatelessWidget {
  final ApiPopular apiPopular = ApiPopular();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Películas Populares'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<PopularModel>?>(
        future: apiPopular.getAllPopular(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos disponibles'));
          } else {
            final movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return PopularView(popularModel: movie);
              },
            );
          }
        },
      ),
    );
  }
}
