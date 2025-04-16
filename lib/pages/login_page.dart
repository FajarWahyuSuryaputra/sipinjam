import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/config/app_colors.dart';
import 'package:sipinjam/config/app_session.dart';
import 'package:sipinjam/config/failure.dart';
import 'package:sipinjam/config/nav.dart';
import 'package:sipinjam/datasources/user_datasource.dart';
import 'package:sipinjam/pages/dashboard.dart';
import 'package:sipinjam/providers/login_provider.dart';

import '../config/app_response.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final edtUsername = TextEditingController();
  final edtPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool hidePass = true;

  execute() {
    bool validInput = formKey.currentState!.validate();
    if (!validInput) {
      return;
    }

    setLoginStatus(ref, 'Loading');

    UserDatasource.login(edtUsername.text, edtPassword.text).then(
      (value) {
        String newStatus = '';
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure:
                newStatus = 'Server Error';
                DInfo.toastError(newStatus);
                break;
              case NotFoundFailure:
                newStatus = 'Error Not Found';
                DInfo.toastError(newStatus);
                break;
              case ForbiddenFailure:
                newStatus = 'You don\' have access';
                DInfo.toastError(newStatus);
                break;
              case BadRequestFailure:
                newStatus = 'Bad request';
                DInfo.toastError(newStatus);
                break;
              case InvalidInputFailure:
                newStatus = 'Invalid Input';
                AppResponse.invalidInput(context, failure.message ?? '{}');
                break;
              case UnauthorizedFailure:
                newStatus = 'Login Failed';
                DInfo.toastError(newStatus);
                break;
              default:
                newStatus = 'Request Error';
                DInfo.toastError(newStatus);
                newStatus = failure.message ?? '-';
                break;
            }
            setLoginStatus(ref, newStatus);
          },
          (r) {
            AppSession.setUser(r['data']);
            DInfo.toastSuccess('Login Success');
            setLoginStatus(ref, 'Success');
            Nav.replace(context, const Dashboard());
          },
        );
      },
    );
  }

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
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(4, 4),
                                  blurRadius: 2),
                            ],
                          ),
                          child: TextField(
                            controller: edtUsername,
                            decoration: const InputDecoration(
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
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(4, 4),
                                  blurRadius: 2),
                            ],
                          ),
                          child: TextField(
                            controller: edtPassword,
                            obscureText: hidePass,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(Icons.lock),
                                hintText: 'Password',
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePass = !hidePass;
                                      });
                                    },
                                    icon: Icon(hidePass
                                        ? Icons.visibility
                                        : Icons.visibility_off)),
                                contentPadding: const EdgeInsets.only(top: 12)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: double.infinity,
                          child: Consumer(
                            builder: (_, wiRef, __) {
                              String status = wiRef.watch(loginStatusProvider);
                              if (status == 'Loading') {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return ElevatedButton(
                                  onPressed: () => execute(),
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.amber)),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ));
                            },
                          ),
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
