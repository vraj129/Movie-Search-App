class Movie {
  final String title;
  final String poster;
  final String year;
  final String imdbrating;

  Movie(
      {required this.title,
      required this.poster,
      required this.year,
      required this.imdbrating});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        title: json["title"],
        poster: json["image"],
        year: json["year"],
        imdbrating: json["imDbRating"]);
  }
}
