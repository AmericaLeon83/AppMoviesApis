import 'package:flutter/material.dart';
import 'package:tap2024/network/api_popular.dart';
import 'package:tap2024/models/popular_model.dart';
import 'package:tap2024/views/popular_view.dart';
import 'package:tap2024/views/favorites_screen.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  ApiPopular? apiPopular;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Películas Populares'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Descubre\nGrandes Películas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 38,
                      height: 38,
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {},
                        icon: Image.asset('assets/notification.png'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Text(
                  'Películas Populares',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                FutureBuilder(
                  future: apiPopular!.getAllPopular(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('No hay datos disponibles'));
                    } else {
                      List<PopularModel> movies = snapshot.data as List<PopularModel>;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return PopularView(popularModel: movies[index]);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
