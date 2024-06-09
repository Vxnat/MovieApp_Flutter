// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_application_movie/Apis/apis.dart';
import 'package:flutter_application_movie/models/movie_item_detail.dart';
import 'package:flutter_application_movie/screens/home_screen.dart';
import 'package:flutter_application_movie/screens/movie_detail_screen.dart';

// ignore: must_be_immutable
class MovieTypeFamily extends StatefulWidget {
  const MovieTypeFamily({super.key});

  @override
  State<MovieTypeFamily> createState() => _MovieTypeFamilyState();
}

class _MovieTypeFamilyState extends State<MovieTypeFamily> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PHIM GIA ĐÌNH',
          style: TextStyle(color: Colors.white),
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
          stream: Apis.getDataMovieFamily(0),
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
