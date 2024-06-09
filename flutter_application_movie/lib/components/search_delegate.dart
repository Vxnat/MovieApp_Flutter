import 'package:flutter/material.dart';
import 'package:flutter_application_movie/models/movie_item_detail.dart';
import 'package:flutter_application_movie/provider/movie_provider.dart';
import 'package:flutter_application_movie/screens/home_screen.dart';
import 'package:flutter_application_movie/screens/movie_detail_screen.dart';
import 'package:flutter_application_movie/screens/movie_search_screen.dart';

class SearchDel extends SearchDelegate {
  final MovieProvider movieProvider = MovieProvider();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MovieSearchScreen(nameMovieSearch: query),
                ));
          },
          icon: const Icon(Icons.search)),
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(color: Colors.black, child: _buildSearchList(query));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(color: Colors.black, child: _buildSearchList(query));
  }

  // Hiển thị kết qủa tìm kiếm
  Widget _buildSearchList(String query) {
    List<String> listSearch = [];

    for (int i = 0; i < movieProvider.listNameMovie.length; i++) {
      if (i > 0) {
        break;
      }
      listSearch.add(movieProvider.listNameMovie[i].movie.name);
    }
    List<MovieItemDetail> matchQuery = [];

    for (var itemName in listSearch) {
      if (itemName.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.addAll(movieProvider.listNameMovie.where((element) =>
            element.movie.name.toLowerCase().contains(query.toLowerCase()) ||
            element.movie.originName
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            element.movie.originName
                .toLowerCase()
                .startsWith(query.toLowerCase()) ||
            element.movie.name.toLowerCase().startsWith(query.toLowerCase())));
        break;
      }
    }
    List<MovieItemDetail> newListData = [];
    if (matchQuery.length > 10) {
      newListData.addAll(matchQuery.sublist(0, 10));
    } else {
      newListData.addAll(matchQuery);
    }
    // Nếu thanh Search rỗng thì hiển thị gợi ý tên 1 vài item
    return query.isEmpty
        ? ListView.builder(
            itemCount: listSearch.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  listSearch[index],
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          )
        // Hiển thị kết quả tìm được
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            itemCount: newListData.length,
            itemBuilder: (context, index) {
              final item = newListData[index];
              return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailScreen(idMovie: item.movie.id),
                          ));
                    },
                    child: Row(
                      children: [
                        showImg(item.movie.posterUrl.split('/')[5], 150, 150),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                item.movie.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                item.movie.content,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ));
            });
  }
}
