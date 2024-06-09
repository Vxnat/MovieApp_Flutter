// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_movie/Apis/apis.dart';
import 'package:flutter_application_movie/models/movie_item_detail.dart';
import 'package:flutter_application_movie/screens/home_screen.dart';
import 'package:flutter_application_movie/screens/movie_detail_screen.dart';

// ignore: must_be_immutable
class MovieFavoriteScreen extends StatefulWidget {
  const MovieFavoriteScreen({
    super.key,
  });

  @override
  State<MovieFavoriteScreen> createState() => _MovieFavoriteScreenState();
}

class _MovieFavoriteScreenState extends State<MovieFavoriteScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Phim yêu thích',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(226, 0, 0, 0),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration:
                const BoxDecoration(color: Color.fromARGB(226, 0, 0, 0)),
            height: MediaQuery.of(context).size.height,
            child: FirebaseAuth.instance.currentUser != null
                ? StreamBuilder(
                    stream: Apis.getDataUserMovieFavorite(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        case ConnectionState.done:
                        case ConnectionState.active:
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
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
                                                MovieDetailScreen(
                                                    idMovie: item.movie.id),
                                          ));
                                    },
                                    child: showImg(
                                        item.movie.thumbUrl.split('/')[5],
                                        120,
                                        150));
                              },
                            );
                          } else {
                            return const Center(
                              child: Text(
                                'DANH SÁCH TRỐNG',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),
                            );
                          }
                      }
                    },
                  )
                : const Center(
                    child: Text(
                      'VUI LÒNG ĐĂNG NHẬP',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  )),
      ),
    );
  }
}
