import 'package:flutter/material.dart';
import 'package:flutter_application_movie/screens/movie_favorite_screen.dart';

import '../models/menu_title.dart';
import '../screens/profile_screen.dart';
import 'info_card.dart';
import 'side_menu_title.dart';

class SideBarMenu extends StatefulWidget {
  const SideBarMenu({super.key});

  @override
  State<SideBarMenu> createState() => _SideBarMenuState();
}

class _SideBarMenuState extends State<SideBarMenu> {
  List<MenuTitle> listMenuTitle = [
    MenuTitle(
        urlIcon: 'img/user_img.png',
        name: 'User',
        routeName: const ProfileScreen()),
    MenuTitle(
        urlIcon: 'img/favorite-favorite-svgrepo-com.png',
        name: 'Favorite',
        routeName: MovieFavoriteScreen()),
    // MenuTitle(
    //     urlIcon: 'img/order-food-svgrepo-com.png',
    //     name: 'Order history',
    //     routeName: const OrderHistory()),
    // MenuTitle(
    //     urlIcon: 'img/discount-star-svgrepo-com.png',
    //     name: 'Coupon',
    //     routeName: const CouponScreen()),
    // MenuTitle(
    //     urlIcon: 'img/information-info-svgrepo-com.png',
    //     name: 'Information',
    //     routeName: const AppInfor()),
    // MenuTitle(
    //     urlIcon: 'img/customer-service-help-svgrepo-com.png',
    //     name: 'Help',
    //     routeName: const HelpScreen()),
  ];
  @override
  Widget build(BuildContext context) => Drawer(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.black87,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [buildHeader(context), buildMenuItems(context)],
          ),
        ),
      );
  Widget buildHeader(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const InfoCard(name: 'VxnatFood', profession: 'FastFood'),
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
          child: Text(
            'Application'.toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ]);
  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          for (var item in listMenuTitle)
            SideMenuTitle(
              item: item,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => item.routeName,
                    ));
              },
            ),
        ],
      );
}
