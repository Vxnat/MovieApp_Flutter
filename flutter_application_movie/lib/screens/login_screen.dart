import 'package:flutter/material.dart';
import '../provider/movie_provider.dart';

enum AuthMode { login, register }

extension on AuthMode {
  String get title => this == AuthMode.login ? 'Đăng nhập' : 'Đăng ký';
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var mode = AuthMode.login;
  MovieProvider movieProvider = MovieProvider();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cfpasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  void login(String email, password) {
    movieProvider.login(email, password);
  }

  void register(String email, password) {
    movieProvider.register(email, password);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration:
              const BoxDecoration(color: Color.fromARGB(223, 24, 19, 32)),
          child: mode == AuthMode.login
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: mq.height * 0.2,
                    ),
                    const Text(
                      'Đăng nhập',
                      style: TextStyle(color: Colors.white, fontSize: 50),
                    ),
                    SizedBox(
                      height: mq.height * 0.2,
                    ),
                    Form(
                        child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.black)),
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            controller: passwordController,
                            style: const TextStyle(color: Colors.black),
                            obscureText: true,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                                hintText: 'Mật khẩu',
                                hintStyle: TextStyle(color: Colors.black)),
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        GestureDetector(
                          child: const Text(
                            'Quên mật khẩu ?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.03,
                        ),
                        SizedBox(
                          width: mq.width,
                          height: 45,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              onPressed: () {
                                login(emailController.text,
                                    passwordController.text);
                              },
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        const Text(
                          'Chưa có tài khoản ?',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: mq.height * 0.01,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              mode = AuthMode.register;
                            });
                          },
                          child: const Text(
                            'Đăng ký ngay',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ))
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: mq.height * 0.2,
                    ),
                    const Text(
                      'Đăng ký',
                      style: TextStyle(color: Colors.white, fontSize: 50),
                    ),
                    SizedBox(
                      height: mq.height * 0.2,
                    ),
                    Form(
                        child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.black)),
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            controller: passwordController,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                                hintText: 'Mật khẩu',
                                hintStyle: TextStyle(color: Colors.black)),
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            controller: cfpasswordController,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                                hintText: 'Nhập lại mật khẩu',
                                hintStyle: TextStyle(color: Colors.black)),
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.03,
                        ),
                        SizedBox(
                          width: mq.width,
                          height: 45,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              onPressed: () {
                                register(emailController.text,
                                    passwordController.text);
                              },
                              child: const Text(
                                'Đăng ký',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        const Text(
                          'Đã có tài khoản ?',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: mq.height * 0.01,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              mode = AuthMode.login;
                            });
                          },
                          child: const Text(
                            'Đăng nhập',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ))
                  ],
                )),
    );
  }
}
