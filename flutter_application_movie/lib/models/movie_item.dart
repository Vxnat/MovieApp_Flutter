class MovieItem {
  MovieItem({
    required this.tmdb,
    required this.imdb,
    required this.modified,
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.thumbUrl,
    required this.posterUrl,
    required this.year,
  });
  late final Tmdb tmdb;
  late final Imdb imdb;
  late final Modified modified;
  late final String id;
  late final String name;
  late final String slug;
  late final String originName;
  late final String thumbUrl;
  late final String posterUrl;
  late final int year;

  MovieItem.fromJson(Map<String, dynamic> json) {
    tmdb = Tmdb.fromJson(json['tmdb']);
    imdb = Imdb.fromJson(json['imdb']);
    modified = Modified.fromJson(json['modified']);
    id = json['_id'] ?? '';
    name = json['name'] ?? '';
    slug = json['slug'] ?? '';
    originName = json['origin_name'] ?? '';
    thumbUrl = json['thumb_url'] ?? '';
    posterUrl = json['poster_url'] ?? '';
    year = json['year'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tmdb'] = tmdb.toJson();
    data['imdb'] = imdb.toJson();
    data['modified'] = modified.toJson();
    data['_id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['origin_name'] = originName;
    data['thumb_url'] = thumbUrl;
    data['poster_url'] = posterUrl;
    data['year'] = year;
    return data;
  }
}

class Tmdb {
  Tmdb({
    required this.type,
    required this.id,
    required this.season,
    required this.voteAverage,
    required this.voteCount,
  });
  late final String type;
  late final String id;
  late final int season;
  late final double voteAverage;
  late final int voteCount;

  Tmdb.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? '';
    id = json['id'] ?? '';
    season = json['season'] ?? 0;
    voteAverage = json['vote_average'] ?? 0.0;
    voteCount = json['vote_count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['season'] = season;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }
}

class Imdb {
  Imdb({
    required this.id,
  });
  late final String id;

  Imdb.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class Modified {
  Modified({
    required this.time,
  });
  late final String time;

  Modified.fromJson(Map<String, dynamic> json) {
    time = json['time'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['time'] = time;
    return data;
  }
}
