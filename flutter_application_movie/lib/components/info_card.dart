import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.name,
    required this.profession,
  });

  final String name, profession;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        'img/netflix_img.png',
        width: 70,
        height: 150,
      ),
    );
  }
}
