// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_movie/Apis/apis.dart';
import 'package:flutter_application_movie/models/movie_item_detail.dart';
import 'package:flutter_application_movie/provider/movie_provider.dart';
import 'package:flutter_application_movie/screens/home_screen.dart';
import 'package:flutter_application_movie/screens/movie_detail_screen.dart';

// ignore: must_be_immutable
class TypeOfMovie extends StatefulWidget {
  final TypeOfFilm typeOfMovie;
  const TypeOfMovie({super.key, required this.typeOfMovie});

  @override
  State<TypeOfMovie> createState() => _TypeOfMovieState();
}

class _TypeOfMovieState extends State<TypeOfMovie> {
  late String title;
  late Stream<QuerySnapshot<Map<String, dynamic>>> movieStream;
  @override
  void initState() {
    super.initState();
    switch (widget.typeOfMovie) {
      case TypeOfFilm.tv:
        title = 'TV';
        movieStream = Apis.getDataTvShow(0);
      case TypeOfFilm.movie:
        title = "Phim điện ảnh";
        movieStream = Apis.getDataMovie(0);
      case TypeOfFilm.anime:
        title = "Anime đặc sắc";
        movieStream = Apis.getDataMovieAnime(0);
      case TypeOfFilm.currentYear:
        title = "Mới ra mắt";
        movieStream = Apis.getDataMovieCurrentYear(0);
      case TypeOfFilm.trailer:
        title = "Sắp ra mắt";
        movieStream = Apis.getDataMovieTrailer(0);
      case TypeOfFilm.horrible:
        title = "Bí kíp trừ tà";
        movieStream = Apis.getDataMovieHorrible(0);
      case TypeOfFilm.family:
        title = "Phim gia đình";
        movieStream = Apis.getDataMovieFamily(0);
      case TypeOfFilm.funny:
        title = "Giải trí nhẹ nhàng thôi";
        movieStream = Apis.getDataMovieFunny(0);
        break;
      default:
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(226, 0, 0, 0),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Color.fromARGB(226, 0, 0, 0)),
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: movieStream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final data = snapshot.data!.docs;
                  final listData = data
                      .map((e) => MovieItemDetail.fromJson(e.data()))
                      .toList();
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 3 / 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: listData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = listData[index];
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MovieDetailScreen(idMovie: item.movie.id),
                                ));
                          },
                          child: showImg(
                              item.movie.thumbUrl.split('/')[5], 120, 150));
                    },
                  );
                }
                return Container();
            }
          },
        ),
      ),
    );
  }
}
