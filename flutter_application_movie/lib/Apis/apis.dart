import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_movie/models/movie_item.dart';
import 'package:flutter_application_movie/models/movie_item_detail.dart';

import '../models/user_movie.dart';

class Apis {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User get user => auth.currentUser!;
  static late UserMovie me;

  // Dữ liệu người dùng
  // static Future<void> getSelfInfor() async {
  //   return await firestore
  //       .collection('users')
  //       .doc(user.uid)
  //       .get()
  //       .then((user) async {
  //     if (user.exists) {
  //       me = UserMovie.fromJson(user.data()!);
  //     }
  //   });
  // }

  static Future<void> updateCategorySlugs() async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('movies_detail');
    final snapshot = await collection.get();

    for (var doc in snapshot.docs) {
      List<dynamic> categories = doc.data()['movie']['category'];
      List<String> slugs =
          categories.map((category) => category['slug'].toString()).toList();

      await doc.reference.update({
        'movie.category_slugs': slugs,
      });
    }
  }

  static Future<void> addDataMovie(MovieItem movieItem) async {
    try {
      final movieRef = firestore.collection('movies');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await movieRef.where('_id', isEqualTo: movieItem.id).limit(1).get();
      if (querySnapshot.docs.isEmpty) {
        await movieRef.doc().set(movieItem.toJson());
      } else {
        final docId = querySnapshot.docs.first.id;
        await movieRef.doc(docId).set(movieItem.toJson());
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> addDataDetailMovie(
      MovieItemDetail movieItemDetail) async {
    try {
      final movieDetailRef = firestore.collection('movies_detail');
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await movieDetailRef
          .where('movie._id', isEqualTo: movieItemDetail.movie.id)
          .limit(1)
          .get();
      if (querySnapshot.docs.isEmpty) {
        await movieDetailRef.doc().set(movieItemDetail.toJson());
      } else {
        final docId = querySnapshot.docs.first.id;
        await movieDetailRef.doc(docId).update(movieItemDetail.toJson());
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateNameUser(String newName) async {
    try {
      final ref = firestore.collection('users');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await ref.where('id', isEqualTo: user.uid).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await ref.doc(docId).update({'name': newName});
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateFavoriteMovie(
      MovieItemDetail movieItemDetail) async {
    try {
      final favoriteMovieFef =
          firestore.collection('favorite_movies/${user.uid}/movies');
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await favoriteMovieFef
          .where('movie._id', isEqualTo: movieItemDetail.movie.id)
          .limit(1)
          .get();
      if (querySnapshot.docs.isEmpty) {
        await favoriteMovieFef.doc().set(movieItemDetail.toJson());
      } else {
        final docId = querySnapshot.docs.first.id;
        await favoriteMovieFef.doc(docId).delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<MovieItemDetail>> getAllNameMovie() async {
    try {
      final favoriteMoviesRef = firestore.collection('movies_detail');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await favoriteMoviesRef.get();
      List<MovieItemDetail> listNameMovie = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        final newData = MovieItemDetail.fromJson(data);
        listNameMovie.add(newData);
      }

      return listNameMovie;
    } catch (e) {
      rethrow;
    }
  }

  // Dữ liệu cho profile_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getDataMySelf() {
    return firestore
        .collection('users')
        .where('id', isEqualTo: user.uid.toString())
        .limit(1)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getDataUserMovieFavorite() {
    return firestore
        .collection('favorite_movies/${user.uid}/movies')
        .snapshots();
  }

  static Future<bool> getAllIdMovieFavorite(String idMovie) async {
    final favoriteMoviesRef = FirebaseFirestore.instance
        .collection('favorite_movies/${user.uid}/movies');

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await favoriteMoviesRef.where('movie._id', isEqualTo: idMovie).get();

      bool idMovieFavorite = false;

      querySnapshot.docs.isNotEmpty ? idMovieFavorite = true : null;

      return idMovieFavorite;
    } catch (e) {
      rethrow;
    }
  }

  // Dữ liệu cho home_screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getDataTvShow(int limit) {
    return limit != 0
        ? firestore
            .collection('movies_detail')
            .where('movie.tmdb.type', isEqualTo: 'tv')
            .where('movie.status', isEqualTo: 'completed')
            .limit(limit)
            .snapshots()
        : firestore
            .collection('movies_detail')
            .where('movie.tmdb.type', isEqualTo: 'tv')
            .where('movie.status', isEqualTo: 'completed')
            .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getDataMovie(int limit) {
    return limit != 0
        ? firestore
            .collection('movies_detail')
            .where('movie.tmdb.type', isEqualTo: 'movie')
            .where('movie.status', isEqualTo: 'completed')
            .limit(limit)
            .snapshots()
        : firestore
            .collection('movies_detail')
            .where('movie.tmdb.type', isEqualTo: 'movie')
            .where('movie.status', isEqualTo: 'completed')
            .snapshots();
  }

  // NEW MOVIE
  static Stream<QuerySnapshot<Map<String, dynamic>>> getDataMovieCurrentYear(
      int limit) {
    return limit != 0
        ? firestore
            .collection('movies_detail')
            .where('movie.year', isEqualTo: DateTime.now().year)
            .where('movie.status', isEqualTo: 'completed')
            .limit(limit)
            .snapshots()
        : firestore
            .collection('movies_detail')
            .where('movie.year', isEqualTo: DateTime.now().year)
            .where('movie.status', isEqualTo: 'completed')
            .snapshots();
  }

  // CARTOON MOVIE
  static Stream<QuerySnapshot<Map<String, dynamic>>> getDataMovieAnime(
      int limit) {
    return limit != 0
        ? firestore
            .collection('movies_detail')
            .where('movie.type', isEqualTo: 'hoathinh')
            .where('movie.status', isEqualTo: 'completed')
            .limit(limit)
            .snapshots()
        : firestore
            .collection('movies_detail')
            .where('movie.type', isEqualTo: 'hoathinh')
            .where('movie.status', isEqualTo: 'completed')
            .snapshots();
  }

  // HORRIBLE MOVIE
  static Stream<QuerySnapshot<Map<String, dynamic>>> getDataMovieHorrible(
      int limit) {
    if (limit != 0) {
      return firestore
          .collection('movies_detail')
          .where('movie.category_slugs', arrayContains: 'kinh-di')
          .where('movie.status', isEqualTo: 'completed')
          .limit(limit)
          .snapshots();
    } else {
      return firestore
          .collection('movies_detail')
          .where('movie.category_slugs', arrayContains: 'kinh-di')
          .where('movie.status', isEqualTo: 'completed')
          .snapshots();
    }
  }

  // FAMILY MOVIE
  static Stream<QuerySnapshot<Map<String, dynamic>>> getDataMovieFamily(
      int limit) {
    return limit != 0
        ? firestore
            .collection('movies_detail')
            .where('movie.category_slugs', arrayContains: 'gia-dinh')
            .where('movie.status', isEqualTo: 'completed')
            .limit(limit)
            .snapshots()
        : firestore
            .collection('movies_detail')
            .where('movie.category_slugs', arrayContains: 'gia-dinh')
            .where('movie.status', isEqualTo: 'completed')
            .snapshots();
  }

  // FUNNY MOVIE
  static Stream<QuerySnapshot<Map<String, dynamic>>> getDataMovieFunny(
      int limit) {
    return limit != 0
        ? firestore
            .collection('movies_detail')
            .where('movie.category_slugs', arrayContains: 'hai-huoc')
            .where('movie.status', isEqualTo: 'completed')
            .limit(limit)
            .snapshots()
        : firestore
            .collection('movies_detail')
            .where('movie.category_slugs', arrayContains: 'hai-huoc')
            .where('movie.status', isEqualTo: 'completed')
            .snapshots();
  }

  // TRAILER
  static Stream<QuerySnapshot<Map<String, dynamic>>> getDataMovieTrailer(
      int limit) {
    return limit != 0
        ? firestore
            .collection('movies_detail')
            .where('movie.status', isEqualTo: 'trailer')
            .limit(limit)
            .snapshots()
        : firestore
            .collection('movies_detail')
            .where('movie.status', isEqualTo: 'trailer')
            .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getDataMovieDetail(
      String idMovie) {
    return firestore
        .collection('movies_detail')
        .where('movie._id', isEqualTo: idMovie)
        .limit(1)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllDataMovieDetail() {
    return firestore.collection('movies_detail').snapshots();
  }
}
