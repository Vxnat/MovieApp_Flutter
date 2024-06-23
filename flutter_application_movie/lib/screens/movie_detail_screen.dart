import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_movie/Apis/apis.dart';
import 'package:flutter_application_movie/auth/auth_gate.dart';
import 'package:flutter_application_movie/models/movie_item_detail.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/movie_provider.dart';
import 'home_screen.dart';

// ignore: must_be_immutable
class MovieDetailScreen extends StatefulWidget {
  final String idMovie;
  const MovieDetailScreen({
    super.key,
    required this.idMovie,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  MovieProvider movieProvider = MovieProvider();
  var chooseEpisodeFilm = const SnackBar(
    content: Text('Vui lòng chọn tập phim !'),
    duration: Duration(seconds: 2),
  );
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser != null
        ? movieProvider.getMovieFavoriteFromApi(widget.idMovie)
        : null;
  }

  @override
  void dispose() {
    super.dispose();
    movieProvider.currentUrlMovie = '';
    movieProvider.currentSelectedIndex = -1;
  }

  Future<void> _confirmAndLaunchUrl(
      BuildContext context, String currentUrlMovie) async {
    if (currentUrlMovie != '') {
      bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Open in Web Browser'),
            content:
                const Text('Do you want to open this link in a web browser?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Open'),
              ),
            ],
          );
        },
      );

      if (confirmed) {
        _launchUrl(currentUrlMovie);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(chooseEpisodeFilm);
    }
  }

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> updateFavoriteMovie(
      bool isLiked, MovieItemDetail movieItemDetail) async {
    movieProvider.isMovieFavorite = !movieProvider.isMovieFavorite;
    Apis.updateFavoriteMovie(movieItemDetail);

    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Container(
        height: mq.height,
        color: Colors.black87,
        child: StreamBuilder(
          stream: Apis.getDataMovieDetail(widget.idMovie),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  final data = snapshot.data!.docs;
                  final listData = data
                      .map((e) => MovieItemDetail.fromJson(e.data()))
                      .toList();
                  final item = listData.first;
                  final category = item.movie.category;

                  List<String> listIDCategory = [];
                  for (var i in category) {
                    listIDCategory.add(i.id);
                  }

                  return Stack(
                    children: [
                      Opacity(
                        opacity: 0.4,
                        child: Hero(
                          tag: 'location-img-${item.movie.name}',
                          child: showImg(item.movie.posterUrl.split('/')[5],
                              double.infinity, 280),
                        ),
                      ),
                      SingleChildScrollView(
                        child: SafeArea(
                            child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_ios_new,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  LikeButton(
                                    size: 35,
                                    isLiked: movieProvider.isMovieFavorite,
                                    onTap: (isLiked) {
                                      if (FirebaseAuth.instance.currentUser ==
                                          null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AuthGate(),
                                            ));
                                        return Future(() => null);
                                      } else {
                                        return updateFavoriteMovie(
                                            isLiked, item);
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.red.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 8)
                                        ]),
                                    child: showImg(
                                        item.movie.thumbUrl.split('/')[5],
                                        180,
                                        250),
                                  ),
                                  StreamBuilder(
                                    stream: FirebaseAuth.instance
                                        .authStateChanges(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return GestureDetector(
                                          onTap: () {
                                            _confirmAndLaunchUrl(context,
                                                movieProvider.currentUrlMovie);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 50, top: 70),
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                color: Colors.redAccent,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.red
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 8)
                                                ]),
                                            child: const Icon(
                                              Icons.play_arrow_rounded,
                                              color: Colors.white,
                                              size: 60,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AuthGate(),
                                                ));
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 50, top: 70),
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                color: Colors.redAccent,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.red
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 8)
                                                ]),
                                            child: const Icon(
                                              Icons.play_arrow_rounded,
                                              color: Colors.white,
                                              size: 60,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF292B37),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 6)
                                        ]),
                                    child: const Icon(
                                      Icons.add,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF292B37),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 6)
                                        ]),
                                    child: const Icon(
                                      Icons.favorite_border_outlined,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF292B37),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 6)
                                        ]),
                                    child: const Icon(
                                      Icons.download,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF292B37),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 6)
                                        ]),
                                    child: const Icon(
                                      Icons.share,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.movie.originName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    item.movie.content,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tập phim',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Consumer<MovieProvider>(
                                    builder: (context, value, child) {
                                      return SingleChildScrollView(
                                        child: SizedBox(
                                          height: 100,
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                        7, // Số lượng cột
                                                    childAspectRatio: 4 /
                                                        2, // Tỉ lệ khung hình của mỗi item
                                                    crossAxisSpacing: 10,
                                                    mainAxisSpacing: 10),
                                            itemCount: item.episodes.first
                                                .serverData.length,
                                            itemBuilder: (context, index) {
                                              // Danh sach cac tap phim
                                              final listEpisodes = item
                                                  .episodes.first.serverData;
                                              // Tap phim
                                              final itemEpisode =
                                                  listEpisodes[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  value.setCurrentUrlMovie(
                                                      itemEpisode.linkEmbed,
                                                      item.movie.trailerUrl);
                                                  value.toggleColor(index);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          value.currentSelectedIndex ==
                                                                  index
                                                              ? Colors.white
                                                              : Colors.black54,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Center(
                                                    child: Text(
                                                      itemEpisode.name != ''
                                                          ? itemEpisode.name
                                                          : item.movie.trailerUrl !=
                                                                  ''
                                                              ? 'Trailer'
                                                              : '',
                                                      style: TextStyle(
                                                          color:
                                                              value.currentSelectedIndex ==
                                                                      index
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Đề xuất',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: StreamBuilder(
                                    stream: Apis.getAllDataMovieDetail(),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                        case ConnectionState.waiting:
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        case ConnectionState.active:
                                        case ConnectionState.done:
                                          if (snapshot.hasData) {
                                            final data = snapshot.data!.docs;
                                            final listData = data
                                                .sublist(
                                                    0,
                                                    data.length < 10
                                                        ? data.length
                                                        : 10)
                                                .map((e) =>
                                                    MovieItemDetail.fromJson(
                                                        e.data()))
                                                .toList();
                                            final listDataSameCategory =
                                                listData.where((element) {
                                              final elementCategoryIds = element
                                                  .movie.category
                                                  .map((cat) => cat.id)
                                                  .toList();
                                              return listIDCategory.any((id) =>
                                                  elementCategoryIds
                                                      .contains(id));
                                            }).toList();
                                            return SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    listDataSameCategory.length,
                                                itemBuilder: (context, index) {
                                                  final itemMovieSameCategory =
                                                      listDataSameCategory[
                                                          index];
                                                  if (itemMovieSameCategory
                                                          .movie.id !=
                                                      widget.idMovie) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    MovieDetailScreen(
                                                                        idMovie: itemMovieSameCategory
                                                                            .movie
                                                                            .id),
                                                              ));
                                                        },
                                                        child: showImg(
                                                            itemMovieSameCategory
                                                                .movie.posterUrl
                                                                .split('/')[5],
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.3,
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.2),
                                                      ),
                                                    );
                                                  }
                                                  return null;
                                                },
                                              ),
                                            );
                                          }
                                          return Container();
                                      }
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                      )
                    ],
                  );
                }
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    ));
  }
}
