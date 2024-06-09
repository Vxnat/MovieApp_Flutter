import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_movie/components/bottom_nav_bar.dart';
import 'package:flutter_application_movie/provider/movie_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDwjL2t8jKlxHm3Nzh8cpDoJxJciPE-gik',
          appId: '765555458236:android:0770d4b3fbaff488c7d0b9',
          messagingSenderId: '765555458236',
          projectId: 'movie-app-vxnatt'));
  runApp(ChangeNotifierProvider(
    create: (_) => MovieProvider(),
    child: const MaterialApp(
      home: BottomNavBar(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
