import 'movie_item.dart';

class MovieItemDetail {
  MovieItemDetail({
    required this.status,
    required this.msg,
    required this.movie,
    required this.episodes,
  });
  late final bool status;
  late final String msg;
  late final Movie movie;
  late final List<Episodes> episodes;

  MovieItemDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
    msg = json['msg'] ?? '';
    movie = Movie.fromJson(json['movie']);
    episodes =
        List.from(json['episodes']).map((e) => Episodes.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    data['movie'] = movie.toJson();
    data['episodes'] = episodes.map((e) => e.toJson()).toList();
    return data;
  }
}

class Movie {
  Movie({
    required this.tmdb,
    required this.imdb,
    required this.created,
    required this.modified,
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.content,
    required this.type,
    required this.status,
    required this.thumbUrl,
    required this.posterUrl,
    required this.isCopyright,
    required this.subDocquyen,
    required this.chieurap,
    required this.trailerUrl,
    required this.time,
    required this.episodeCurrent,
    required this.episodeTotal,
    required this.quality,
    required this.lang,
    required this.notify,
    required this.showtimes,
    required this.year,
    required this.view,
    required this.actor,
    required this.director,
    required this.category,
    required this.categorySlugs,
    required this.country,
  });
  late final Tmdb tmdb;
  late final Imdb imdb;
  late final Created created;
  late final Modified modified;
  late final String id;
  late final String name;
  late final String slug;
  late final String originName;
  late final String content;
  late final String type;
  late final String status;
  late final String thumbUrl;
  late final String posterUrl;
  late final bool isCopyright;
  late final bool subDocquyen;
  late final bool chieurap;
  late final String trailerUrl;
  late final String time;
  late final String episodeCurrent;
  late final String episodeTotal;
  late final String quality;
  late final String lang;
  late final String notify;
  late final String showtimes;
  late final int year;
  late final int view;
  late final List<String> actor;
  late final List<String> director;
  late final List<Category> category;
  late final List<String> categorySlugs;
  late final List<Country> country;

  Movie.fromJson(Map<String, dynamic> json) {
    tmdb = Tmdb.fromJson(json['tmdb']);
    imdb = Imdb.fromJson(json['imdb']);
    created = Created.fromJson(json['created']);
    modified = Modified.fromJson(json['modified']);
    id = json['_id'] ?? '';
    name = json['name'] ?? '';
    slug = json['slug'] ?? '';
    originName = json['origin_name'] ?? '';
    content = json['content'] ?? '';
    type = json['type'] ?? '';
    status = json['status'] ?? '';
    thumbUrl = json['thumb_url'] ?? '';
    posterUrl = json['poster_url'] ?? '';
    isCopyright = json['is_copyright'] ?? false;
    subDocquyen = json['sub_docquyen'] ?? false;
    chieurap = json['chieurap'] ?? false;
    trailerUrl = json['trailer_url'] ?? '';
    time = json['time'] ?? '';
    episodeCurrent = json['episode_current'] ?? '';
    episodeTotal = json['episode_total'] ?? '';
    quality = json['quality'] ?? '';
    lang = json['lang'] ?? '';
    notify = json['notify'] ?? '';
    showtimes = json['showtimes'] ?? '';
    year = json['year'] ?? 0;
    view = json['view'] ?? 0;
    actor = List<String>.from(json['actor'] ?? []);
    director = List<String>.from(json['director'] ?? []);
    category =
        List.from(json['category']).map((e) => Category.fromJson(e)).toList();
    categorySlugs = List<String>.from(json['category_slugs'] ?? []);
    country =
        List.from(json['country']).map((e) => Country.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tmdb'] = tmdb.toJson();
    data['imdb'] = imdb.toJson();
    data['created'] = created.toJson();
    data['modified'] = modified.toJson();
    data['_id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['origin_name'] = originName;
    data['content'] = content;
    data['type'] = type;
    data['status'] = status;
    data['thumb_url'] = thumbUrl;
    data['poster_url'] = posterUrl;
    data['is_copyright'] = isCopyright;
    data['sub_docquyen'] = subDocquyen;
    data['chieurap'] = chieurap;
    data['trailer_url'] = trailerUrl;
    data['time'] = time;
    data['episode_current'] = episodeCurrent;
    data['episode_total'] = episodeTotal;
    data['quality'] = quality;
    data['lang'] = lang;
    data['notify'] = notify;
    data['showtimes'] = showtimes;
    data['year'] = year;
    data['view'] = view;
    data['actor'] = actor;
    data['director'] = director;
    data['category'] = category.map((e) => e.toJson()).toList();
    data['category_slugs'] = categorySlugs;
    data['country'] = country.map((e) => e.toJson()).toList();
    return data;
  }
}

class Created {
  Created({
    required this.time,
  });
  late final String time;

  Created.fromJson(Map<String, dynamic> json) {
    time = json['time'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['time'] = time;
    return data;
  }
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.slug,
  });
  late final String id;
  late final String name;
  late final String slug;

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    slug = json['slug'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}

class Country {
  Country({
    required this.id,
    required this.name,
    required this.slug,
  });
  late final String id;
  late final String name;
  late final String slug;

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    slug = json['slug'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}

class Episodes {
  Episodes({
    required this.serverName,
    required this.serverData,
  });
  late final String serverName;
  late final List<ServerData> serverData;

  Episodes.fromJson(Map<String, dynamic> json) {
    serverName = json['server_name'] ?? '';
    serverData = List.from(json['server_data'])
        .map((e) => ServerData.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['server_name'] = serverName;
    data['server_data'] = serverData.map((e) => e.toJson()).toList();
    return data;
  }
}

class ServerData {
  ServerData({
    required this.name,
    required this.slug,
    required this.filename,
    required this.linkEmbed,
    required this.linkM3u8,
  });
  late final String name;
  late final String slug;
  late final String filename;
  late final String linkEmbed;
  late final String linkM3u8;

  ServerData.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    slug = json['slug'] ?? '';
    filename = json['filename'] ?? '';
    linkEmbed = json['link_embed'] ?? '';
    linkM3u8 = json['link_m3u8'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['slug'] = slug;
    data['filename'] = filename;
    data['link_embed'] = linkEmbed;
    data['link_m3u8'] = linkM3u8;
    return data;
  }
}
