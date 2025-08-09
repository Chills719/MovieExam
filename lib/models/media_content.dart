
class MediaContent {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String mediaType; // movie, tv, person
  final double popularity;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final String originalLanguage;
  
  // 人物字段
  final String? knownForDepartment;
  final List<String>? knownFor;
  
  // TV字段
  final String? firstAirDate;
  final List<String>? originCountry;

  MediaContent({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.mediaType,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.originalLanguage,
    this.knownForDepartment,
    this.knownFor,
    this.firstAirDate,
    this.originCountry,
  });

  factory MediaContent.fromJson(Map<String, dynamic> json) {
    String mediaType = json['media_type'] ?? 'unknown';
    
    // 处理不同类型的标题
    String title = '';
    if (mediaType == 'person') {
      title = json['name'] ?? '';
    } else if (mediaType == 'tv') {
      title = json['name'] ?? json['original_name'] ?? '';
    } else {
      title = json['title'] ?? json['original_title'] ?? '';
    }

    List<String>? knownForTitles;
    if (mediaType == 'person' && json['known_for'] != null) {
      knownForTitles = [];
      for (var item in json['known_for']) {
        String itemTitle = item['title'] ?? item['name'] ?? '';
        if (itemTitle.isNotEmpty) {
          knownForTitles.add(itemTitle);
        }
      }
    }

    // 处理TV的origin_country
    List<String>? countries;
    if (json['origin_country'] != null) {
      countries = List<String>.from(json['origin_country']);
    }

    return MediaContent(
      id: json['id'] ?? 0,
      title: title,
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? json['profile_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      mediaType: mediaType,
      popularity: (json['popularity'] ?? 0).toDouble(),
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      knownForDepartment: json['known_for_department'],
      knownFor: knownForTitles,
      firstAirDate: json['first_air_date'],
      originCountry: countries,
    );
  }

  String get fullPosterUrl =>
      posterPath.isNotEmpty ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';
      
  String get displayDate {
    if (mediaType == 'tv' && firstAirDate != null && firstAirDate!.isNotEmpty) {
      return firstAirDate!;
    }
    return releaseDate;
  }
}
