
import 'dart:convert';

class Movie {
  final String title;
  final String? posterPath;
  final String overview;
  final double rating;

  Movie({
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? 'Unknown Title',
      posterPath: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500${json['poster_path']}"
          : "https://via.placeholder.com/150", // Default Placeholder Image
      overview: json['overview'] ?? 'No Overview Available',
      rating: (json['vote_average'] ?? 0).toDouble(),
    );
  }

  static List<Movie> fromJsonList(String jsonData) {
    final data = json.decode(jsonData);
    if (data['results'] == null) return [];
    return (data['results'] as List).map((movie) => Movie.fromJson(movie)).toList();
  }
}
