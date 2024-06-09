import 'package:flutter/material.dart';
import 'package:flutter_application_movie/Apis/apis.dart';
import 'package:flutter_application_movie/models/user_movie.dart';
import 'package:flutter_application_movie/provider/movie_provider.dart';

import '../components/custom_textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isHidePassword = true;
  MovieProvider movieProvider = MovieProvider();
  var successUpdate = const SnackBar(
    content: Text('Cập nhật thành công !'),
    duration: Duration(seconds: 2),
  );
  void logout() {
    movieProvider.logout();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void updateNameUser() {
    movieProvider.updateNameUser(nameController.text);
    ScaffoldMessenger.of(context).showSnackBar(successUpdate);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(226, 0, 0, 0),
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.grey,
            )),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(226, 0, 0, 0)),
        padding: const EdgeInsets.all(10),
        height: mq.height,
        child: StreamBuilder(
          stream: Apis.getDataMySelf(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final data = snapshot.data!.docs;
                  final listData =
                      data.map((e) => UserMovie.fromJson(e.data())).toList();
                  final item = listData.first;
                  nameController.text = item.name;
                  emailController.text = item.email;
                  passwordController.text = item.password;
                  return Column(
                    children: [
                      SizedBox(
                        height: mq.height * 0.05,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(item.avatar),
                        radius: 80,
                      ),
                      SizedBox(
                        height: mq.height * 0.05,
                      ),
                      Form(
                          child: Column(
                        children: [
                          CustomTextField(
                            textEditingController: nameController,
                            hintText: 'Full Name',
                            icon: Icons.person,
                            isReadOnly: false,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            textEditingController: emailController,
                            hintText: 'E-Mail',
                            icon: Icons.email,
                            isReadOnly: true,
                          ),
                          // SizedBox(height: 10),
                          // CustomTextField(
                          //   hintText: 'Phone No',
                          //   icon: Icons.phone,
                          // ),
                          const SizedBox(height: 10),
                        ],
                      )),
                      SizedBox(
                        height: mq.height * 0.03,
                      ),
                      SizedBox(
                        height: 45,
                        width: mq.width,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: updateNameUser,
                            child: const Text(
                              'Cập nhật thông tin',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )),
                      ),
                      SizedBox(
                        height: mq.height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ngày tham gia : ${item.dateJoin}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 95, 92)),
                              onPressed: logout,
                              child: const Text(
                                'Đăng xuất',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ))
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
    );
  }
}
