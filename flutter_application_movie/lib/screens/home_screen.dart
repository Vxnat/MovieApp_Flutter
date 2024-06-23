import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_movie/Apis/apis.dart';
import 'package:flutter_application_movie/auth/auth_gate.dart';
import 'package:flutter_application_movie/models/movie_item_detail.dart';
import 'package:flutter_application_movie/provider/movie_provider.dart';
import 'package:flutter_application_movie/screens/movie_detail_screen.dart';
import 'package:flutter_application_movie/screens/movie_type_screen.dart';
import 'package:flutter_application_movie/screens/profile_screen.dart';
import '../components/search_delegate.dart';
import '../components/side_bar_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MovieProvider movieProvider = MovieProvider();
  TextEditingController searchController = TextEditingController();
  int quanityLimit = 10;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'img/netflix_img.png',
            height: 70,
            width: 120,
          ),
          backgroundColor: const Color.fromARGB(226, 0, 0, 0),
          // leading: Builder(
          //   builder: (context) {
          //     return IconButton(
          //         onPressed: () {
          //           Scaffold.of(context).openDrawer();
          //         },
          //         icon: const Icon(
          //           Icons.menu,
          //           color: Colors.grey,
          //         ));
          //   },
          // ),
          actions: [
            // IconButton(
            //     onPressed: () {
            //       showSearch(context: context, delegate: SearchDel());
            //     },
            //     icon: const Icon(
            //       Icons.search,
            //       color: Colors.white54,
            //     )),
            IconButton(
                onPressed: () {
                  // movieProvider.fetchNewMovies(1, 5);
                  Apis.updateCategorySlugs();
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white54,
                )),
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ));
                      },
                      icon: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ));
                } else {
                  return IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AuthGate(),
                            ));
                      },
                      icon: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ));
                }
              },
            )
          ],
        ),
        // drawer: const SideBarMenu(),
        body: Container(
          decoration: const BoxDecoration(color: Color.fromARGB(226, 0, 0, 0)),
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                  stream: Apis.getDataTvShow(10),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Colors.grey,
                        ));
                      case ConnectionState.done:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final data = snapshot.data!.docs;
                          final listData = data
                              .map((e) => MovieItemDetail.fromJson(e.data()))
                              .toList();
                          return SizedBox(
                              height: (mq.height * 0.33 < 300)
                                  ? 300
                                  : mq.height * 0.33,
                              width: double.infinity,
                              child: CarouselSlider.builder(
                                itemCount: listData.length,
                                itemBuilder: (context, index, realIndex) {
                                  final item = listData[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MovieDetailScreen(
                                                    idMovie: item.movie.id),
                                          ));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(5.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Hero(
                                            tag:
                                                'location-img-${item.movie.name}',
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Opacity(
                                                    opacity: 0.7,
                                                    child: showImg(
                                                        item.movie.posterUrl
                                                            .split('/')[5],
                                                        1000,
                                                        350),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: mq.height * 0.01,
                                                ),
                                                Container(
                                                  width: mq.width * 0.4,
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Text(
                                                    item.movie.originName,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                    height: (mq.height * 0.33 < 300)
                                        ? 300
                                        : mq.height * 0.33,
                                    aspectRatio: 16 / 9,
                                    reverse: false,
                                    enlargeStrategy:
                                        CenterPageEnlargeStrategy.height,
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: true,
                                    initialPage: 1,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                        const Duration(seconds: 2),
                                    autoPlay: true,
                                    scrollDirection: Axis.horizontal),
                              ));
                        }
                        return Container();
                    }
                  },
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'PHIM ĐIỆN ẢNH',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TypeOfMovie(
                                    typeOfMovie: TypeOfFilm.movie,
                                  ),
                                ));
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: mq.height * 0.25,
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: Apis.getDataMovie(quanityLimit),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.grey,
                          ));
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            final data = snapshot.data!.docs;
                            final listData = data
                                .sublist(0, data.length < 10 ? data.length : 10)
                                .map((e) => MovieItemDetail.fromJson(e.data()))
                                .toList();
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listData.length,
                              itemBuilder: (context, index) {
                                final item = listData[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MovieDetailScreen(
                                                    idMovie: item.movie.id),
                                          ));
                                    },
                                    child: Stack(
                                      children: [
                                        showImg(
                                            item.movie.thumbUrl.split('/')[5],
                                            150,
                                            350),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Container();
                      }
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ANIME ĐẶC SẮC',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TypeOfMovie(
                                    typeOfMovie: TypeOfFilm.anime,
                                  ),
                                ));
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: mq.height * 0.25,
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: Apis.getDataMovieAnime(quanityLimit),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.grey,
                          ));
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            final data = snapshot.data!.docs;
                            final listData = data
                                .sublist(0, data.length < 10 ? data.length : 10)
                                .map((e) => MovieItemDetail.fromJson(e.data()))
                                .toList();
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listData.length,
                              itemBuilder: (context, index) {
                                final item = listData[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MovieDetailScreen(
                                                    idMovie: item.movie.id),
                                          ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: const Color.fromARGB(
                                                        255, 58, 58, 58)
                                                    .withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 8)
                                          ]),
                                      child: showImg(
                                          item.movie.thumbUrl.split('/')[5],
                                          150,
                                          350),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Container();
                      }
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'PHIM MỚI NHẤT',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TypeOfMovie(
                                    typeOfMovie: TypeOfFilm.currentYear,
                                  ),
                                ));
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: mq.height * 0.25,
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: Apis.getDataMovieCurrentYear(quanityLimit),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.grey,
                          ));
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            final data = snapshot.data!.docs;
                            final listData = data
                                .sublist(0, data.length < 10 ? data.length : 10)
                                .map((e) => MovieItemDetail.fromJson(e.data()))
                                .toList();
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listData.length,
                              itemBuilder: (context, index) {
                                final item = listData[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(
                                                  idMovie: item.movie.id),
                                        ));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Stack(
                                      children: [
                                        showImg(
                                            item.movie.thumbUrl.split('/')[5],
                                            150,
                                            350),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Container();
                      }
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SẮP PHÁT SÓNG',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TypeOfMovie(
                                    typeOfMovie: TypeOfFilm.trailer,
                                  ),
                                ));
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: mq.height * 0.25,
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: Apis.getDataMovieTrailer(quanityLimit),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.grey,
                          ));
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            final data = snapshot.data!.docs;
                            final listData = data
                                .sublist(0, data.length < 10 ? data.length : 10)
                                .map((e) => MovieItemDetail.fromJson(e.data()))
                                .toList();
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listData.length,
                              itemBuilder: (context, index) {
                                final item = listData[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(
                                                  idMovie: item.movie.id),
                                        ));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Stack(
                                      children: [
                                        showImg(
                                            item.movie.thumbUrl.split('/')[5],
                                            150,
                                            350),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Container();
                      }
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'BÍ KÍP TRỪ TÀ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TypeOfMovie(
                                    typeOfMovie: TypeOfFilm.horrible,
                                  ),
                                ));
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: mq.height * 0.25,
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: Apis.getDataMovieHorrible(quanityLimit),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.grey,
                          ));
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            final data = snapshot.data!.docs;
                            final listData = data
                                .sublist(0, data.length < 10 ? data.length : 10)
                                .map((e) => MovieItemDetail.fromJson(e.data()))
                                .toList();

                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listData.length,
                              itemBuilder: (context, index) {
                                final item = listData[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(
                                                  idMovie: item.movie.id),
                                        ));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Stack(
                                      children: [
                                        showImg(
                                            item.movie.posterUrl.split('/')[5],
                                            150,
                                            350),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Container();
                      }
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'PHIM GIA ĐÌNH',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TypeOfMovie(
                                    typeOfMovie: TypeOfFilm.family,
                                  ),
                                ));
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: mq.height * 0.25,
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: Apis.getDataMovieFamily(quanityLimit),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.grey,
                          ));
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            final data = snapshot.data!.docs;
                            final listData = data
                                .sublist(0, data.length < 10 ? data.length : 10)
                                .map((e) => MovieItemDetail.fromJson(e.data()))
                                .toList();
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listData.length,
                              itemBuilder: (context, index) {
                                final item = listData[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(
                                                  idMovie: item.movie.id),
                                        ));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Stack(
                                      children: [
                                        showImg(
                                            item.movie.thumbUrl.split('/')[5],
                                            150,
                                            350),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Container();
                      }
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'GIẢI TRÍ NHẸ NHÀNG THÔI',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TypeOfMovie(
                                    typeOfMovie: TypeOfFilm.funny,
                                  ),
                                ));
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: mq.height * 0.25,
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: Apis.getDataMovieFunny(quanityLimit),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.grey,
                          ));
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            final data = snapshot.data!.docs;
                            final listData = data
                                .sublist(0, data.length < 10 ? data.length : 10)
                                .map((e) => MovieItemDetail.fromJson(e.data()))
                                .toList();
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listData.length,
                              itemBuilder: (context, index) {
                                final item = listData[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(
                                                  idMovie: item.movie.id),
                                        ));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Stack(
                                      children: [
                                        showImg(
                                            item.movie.thumbUrl.split('/')[5],
                                            150,
                                            350),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Container();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

ClipRRect showImg(String imageUrl, double width, double? height) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: SizedBox(
      width: width,
      height: height ?? 150,
      child: CachedNetworkImage(
        imageUrl: 'https://img.ophim.live/uploads/movies/$imageUrl',
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
            color: Colors.grey,
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          'assets/img/error_img.jpg',
          width: width,
          height: height ?? 150,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
