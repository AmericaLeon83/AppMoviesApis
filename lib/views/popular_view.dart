import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tap2024/models/popular_model.dart';
import 'package:tap2024/network/api_popular.dart';
import 'trailer_screen.dart';

class PopularView extends StatefulWidget {
  final PopularModel popularModel;
  final ApiPopular apiPopular = ApiPopular();

  PopularView({required this.popularModel});

  @override
  _PopularViewState createState() => _PopularViewState();
}

class _PopularViewState extends State<PopularView> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  void checkIfFavorite() async {
    final favorites = await widget.apiPopular.getFavorites();
    if (favorites != null) {
      setState(() {
        isFavorite = favorites.any((movie) => movie.id == widget.popularModel.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrailerScreen(popularModel: widget.popularModel),
          ),
        );
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: 'https://image.tmdb.org/t/p/w500/${widget.popularModel.backdropPath}',
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.network('https://ih1.redbubble.net/image.3224006290.0121/flat,750x,075,f-pad,750x1000,f8f8f8.jpg'),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.popularModel.overview,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                      Text(
                        'Actores: ${widget.popularModel.actors?.map((actor) => actor.name).join(', ') ?? 'No disponible'}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          bool success;
                          if (isFavorite) {
                            success = await widget.apiPopular.removeFromFavorites(widget.popularModel.id);
                            if (success) {
                              setState(() {
                                isFavorite = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Película eliminada de favoritos')));
                            }
                          } else {
                            success = await widget.apiPopular.addToFavorites(widget.popularModel.id);
                            if (success) {
                              setState(() {
                                isFavorite = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Película añadida a favoritos')));
                            }
                          }
                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al modificar favoritos')));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
