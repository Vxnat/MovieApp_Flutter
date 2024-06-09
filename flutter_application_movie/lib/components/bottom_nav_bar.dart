import 'package:flutter/material.dart';
import 'package:flutter_application_movie/screens/home_screen.dart';
import 'package:flutter_application_movie/screens/movie_favorite_screen.dart';
import 'package:flutter_application_movie/screens/movie_search_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: Container(
            color: Colors.black,
            height: 70,
            child: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  text: 'Home',
                ),
                Tab(
                  icon: Icon(Icons.search),
                  text: 'Search',
                ),
                Tab(
                  icon: Icon(Icons.favorite),
                  text: 'Favorite',
                )
              ],
              indicatorColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xff999999),
            ),
          ),
          body: TabBarView(children: [
            const HomeScreen(),
            MovieSearchScreen(nameMovieSearch: ''),
            const MovieFavoriteScreen()
          ]),
        ));
  }
}
