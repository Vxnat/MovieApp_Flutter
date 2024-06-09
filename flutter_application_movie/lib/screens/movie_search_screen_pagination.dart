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
  int currentPage = 1;
  final int itemsPerPage = 10;
  late int totalItems;
  late int endPage;

  List<MovieItemDetail> getCurrentPageData(
      List<MovieItemDetail> allData, int currentPage, int itemsPerPage) {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    if (endIndex > allData.length) {
      endIndex = allData.length;
    }
    return allData.sublist(startIndex, endIndex);
  }

  void fetchTotalItems(int total) {
    totalItems = total;
    endPage = total ~/ itemsPerPage;
    if (total ~/ itemsPerPage != 0) {
      endPage++;
    }
  }

  @override
  void initState() {
    super.initState();
    searchEditingController =
        TextEditingController(text: widget.nameMovieSearch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Form(
            child: TextField(
          controller: searchEditingController,
          onSubmitted: (value) {
            setState(() {});
          },
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
              hintText: 'Tên phim...',
              hintStyle: TextStyle(color: Colors.white)),
        )),
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
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: Apis.getAllDataMovieDetail(),
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
                    final newListData = listData
                        .where((element) =>
                            element.movie.name.toLowerCase().contains(
                                searchEditingController.text.toLowerCase()) ||
                            element.movie.originName.toLowerCase().contains(
                                searchEditingController.text.toLowerCase()))
                        .toList();
                    fetchTotalItems(newListData.length);
                    final listFiltered = getCurrentPageData(
                        newListData, currentPage, itemsPerPage);
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (currentPage > 2) page(0, 'First'),
                            for (int i = 0; i < endPage; i++)
                              if (i > currentPage - 3 && i < currentPage + 3)
                                page(i, ''),
                            if (currentPage < endPage - 3)
                              page(endPage - 1, 'Last')
                          ],
                        )
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

  GestureDetector page(int i, String namePage) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentPage = i + 1;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: currentPage == i + 1
              ? Colors.black
              : Colors.grey, // Màu nền của nút
        ),
        child: Text(
          namePage == '' ? (i + 1).toString() : namePage,
          style: const TextStyle(
            color: Colors.white, // Màu chữ
          ),
        ),
      ),
    );
  }
}
