class Movie {
  final int id;
  final String title;
  final String urlImagen;

  Movie({required this.id, required this.title, required this.urlImagen});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      urlImagen: json['poster_path'] ?? '',
    );
  }
}
