import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_movie/Apis/apis.dart';
import 'package:flutter_application_movie/auth/auth_service.dart';
import 'package:flutter_application_movie/models/movie_item.dart';
import 'package:flutter_application_movie/models/movie_item_detail.dart';
import 'package:http/http.dart' as http;

enum TypeOfFilm {
  tv,
  movie,
  anime,
  currentYear,
  trailer,
  horrible,
  family,
  funny
}

class MovieProvider extends ChangeNotifier {
  static final MovieProvider _instance = MovieProvider._();
  factory MovieProvider() => _instance;
  MovieProvider._();
  AuthService authService = AuthService();
  bool isMovieFavorite = false;
  List<MovieItemDetail> listNameMovie = [];
  int currentSelectedIndex = -1;
  String currentUrlMovie = '';
  void login(String email, password) {
    authService.login(email, password);
  }

  void register(String email, password) {
    authService.register(email, password);
  }

  void logout() {
    authService.logout();
  }

  void updateNameUser(String newName) {
    Apis.updateNameUser(newName);
  }

  void getMovieFavoriteFromApi(String idMovie) async {
    isMovieFavorite = await Apis.getAllIdMovieFavorite(idMovie);
    notifyListeners();
  }

  void toggleColor(int index) {
    if (currentSelectedIndex == index) {
      // Nếu mục hiện tại đã được chọn, bỏ chọn nó
      currentSelectedIndex = -1;
      currentUrlMovie = '';
    } else {
      // Chọn mục hiện tại
      currentSelectedIndex = index;
    }
    notifyListeners();
  }

  void setCurrentUrlMovie(String newUrlMovie, String trailerUrl) {
    if (newUrlMovie != '') {
      currentUrlMovie = newUrlMovie;
    } else {
      currentUrlMovie = trailerUrl;
    }

    notifyListeners();
  }

  Future<void> fetchNewMovies(int start, int end) async {
    for (int i = start; i <= end; i++) {
      var url =
          'https://ophim1.com/danh-sach/phim-moi-cap-nhat?page=${i.toString()}';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // convert json String to Map
        final Map<String, dynamic> body = jsonDecode(response.body);
        for (var i in body['items']) {
          final item = MovieItem.fromJson(i);
          Apis.addDataMovie(item);
          await getMovieDetailApi(item.slug);
        }
        print(i.toString().toUpperCase());
        // Bạn có thể sử dụng listData ở đây nếu cần
      } else {
        throw Exception('Failed to load movies');
      }
    }
  }

  Future<void> getMovieDetailApi(String slug) async {
    var url = ('https://ophim1.com/phim/$slug');
    var response = await http.get(Uri.parse(url));
    // convert json String to Map
    final Map<String, dynamic> body = jsonDecode(response.body);
    final item = MovieItemDetail.fromJson(body);
    Apis.addDataDetailMovie(item);
    print(item.movie.originName);
    // Parse each item in the list
  }

  int getYear(String date) {
    List<String> parts = date.split(" ");
    String yearString = parts[2];
    int year = int.parse(yearString);
    return year;
  }
}
