import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sipinjam/config/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        backgroundPattern(context),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'SIPINJAM',
                  style: TextStyle(
                      fontSize: 36, height: 1, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Let\'s get you sign in!',
                        style: TextStyle(
                          color: AppColors.biruMuda,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 16,
                ),
                Form(
                    child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.gray,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Username',
                            contentPadding: EdgeInsets.only(top: 12)),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.gray,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.lock),
                            hintText: 'Password',
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.visibility)),
                            contentPadding: const EdgeInsets.only(top: 12)),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.amber)),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )),
                    )
                  ],
                )),
              ],
            ),
          ),
        )
      ],
    ));
  }

  Column backgroundPattern(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(MediaQuery.sizeOf(context).width * 0.85)),
            color: Colors.grey,
          ),
        ),
        Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(100)),
            color: AppColors.biruTua,
          ),
        ),
      ],
    );
  }
}
