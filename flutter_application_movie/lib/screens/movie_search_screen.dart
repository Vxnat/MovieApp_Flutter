// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_application_movie/Apis/apis.dart';
import 'package:flutter_application_movie/models/movie_item_detail.dart';
import 'package:flutter_application_movie/screens/home_screen.dart';
import 'package:flutter_application_movie/screens/movie_detail_screen.dart';

// ignore: must_be_immutable
class MovieSearchScreen extends StatefulWidget {
  String nameMovieSearch;
  MovieSearchScreen({
    super.key,
    required this.nameMovieSearch,
  });

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  late TextEditingController searchEditingController;

  @override
  void initState() {
    super.initState();
    searchEditingController =
        TextEditingController(text: widget.nameMovieSearch);
  }

  @override
  void dispose() {
    super.dispose();
    searchEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Form(
            child: TextFormField(
          controller: searchEditingController,
          onChanged: (value) {
            setState(() {});
          },
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: 'Tên phim...',
              hintStyle: TextStyle(color: Colors.white)),
        )),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(226, 0, 0, 0),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_outlined,
                color: Colors.grey,
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Color.fromARGB(226, 0, 0, 0)),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: Apis.getAllDataMovieDetail(),
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
                    final newListData = listData
                        .where((element) =>
                            element.movie.name.toLowerCase().contains(
                                searchEditingController.text.toLowerCase()) ||
                            element.movie.originName.toLowerCase().contains(
                                searchEditingController.text.toLowerCase()))
                        .toList();
                    final listFiltered = newListData.sublist(
                        0, newListData.length < 20 ? newListData.length : 20);
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.873,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: listFiltered.length,
                            itemBuilder: (context, index) {
                              final item = listFiltered[index];
                              return Container(
                                  margin: const EdgeInsets.only(bottom: 15),
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
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          showImg(
                                            item.movie.posterUrl.split('/')[5],
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                            250,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.movie.originName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  190,
                                                                  186,
                                                                  103),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        5),
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .yellow,
                                                                  size: 15,
                                                                ),
                                                                const SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Text(
                                                                  item
                                                                      .movie
                                                                      .tmdb
                                                                      .voteAverage
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: const Color
                                                              .fromARGB(255,
                                                              190, 186, 103),
                                                        ),
                                                        child: Text(
                                                          item.movie.year
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                  ),
                                                  Text(
                                                    item.movie.content,
                                                    maxLines: 5,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  )
                                                ]),
                                          )
                                        ],
                                      )));
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
