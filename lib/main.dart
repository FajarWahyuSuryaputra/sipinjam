import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sipinjam/config/app_colors.dart';
import 'package:sipinjam/config/app_session.dart';
import 'package:sipinjam/pages/login_page.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: AppColors.biruTua,
            scaffoldBackgroundColor: AppColors.putih,
            textTheme: GoogleFonts.latoTextTheme(),
            elevatedButtonTheme: const ElevatedButtonThemeData(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.biruMuda),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                    textStyle: WidgetStatePropertyAll(
                        TextStyle(fontSize: 15, color: Colors.black))))),
        home: const LoginPage());
  }
}
