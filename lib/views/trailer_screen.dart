import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tap2024/models/popular_model.dart';
import 'package:tap2024/network/api_popular.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerScreen extends StatefulWidget {
  final PopularModel popularModel;

  TrailerScreen({required this.popularModel});

  @override
  _TrailerScreenState createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  late YoutubePlayerController _controller;
  bool hasTrailer = false;
  final ApiPopular apiPopular = ApiPopular();

  @override
  void initState() {
    super.initState();
    if (widget.popularModel.trailerId != null && widget.popularModel.trailerId!.isNotEmpty) {
      hasTrailer = true;
      _controller = YoutubePlayerController(
        initialVideoId: widget.popularModel.trailerId!,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (hasTrailer) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.popularModel.title),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (hasTrailer)
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
              )
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Trailer no disponible',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.popularModel.overview,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recomendación',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < (widget.popularModel.voteAverage / 2).round()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.yellow,
                        size: 16,
                      );
                    }),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Actores',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widget.popularModel.actors?.map((actor) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  'https://image.tmdb.org/t/p/w500${actor.profilePath}',
                                ),
                                radius: 30,
                              ),
                              SizedBox(height: 5),
                              Text(
                                actor.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      }).toList() ?? [],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () async {
                      bool success = await apiPopular.addToFavorites(widget.popularModel.id);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Película añadida a favoritos')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al añadir a favoritos')));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
