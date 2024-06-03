class PopularModel {
  final String backdropPath;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final double voteAverage;
  final int voteCount;
  String? trailerId;
  List<Actor>? actors;

  PopularModel({
    required this.backdropPath,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
    this.trailerId,
    this.actors,
  });

  factory PopularModel.fromMap(Map<String, dynamic> map) {
    return PopularModel(
      backdropPath: map['backdrop_path'] ?? '',
      id: map['id'],
      originalLanguage: map['original_language'],
      originalTitle: map['original_title'],
      overview: map['overview'],
      popularity: map['popularity'],
      posterPath: map['poster_path'],
      releaseDate: map['release_date'],
      title: map['title'],
      voteAverage: map['vote_average'].toDouble(),
      voteCount: map['vote_count'],
    );
  }
}

class Actor {
  final String name;
  final String profilePath;

  Actor({required this.name, required this.profilePath});

  factory Actor.fromMap(Map<String, dynamic> map) {
    return Actor(
      name: map['name'],
      profilePath: map['profile_path'] ?? '',
    );
  }
}
