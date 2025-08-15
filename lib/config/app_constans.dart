import 'package:flutter/material.dart';
import 'package:sipinjam/pages/dashboardView/calendar.dart';
import 'package:sipinjam/pages/dashboardView/history.dart';
import 'package:sipinjam/pages/dashboardView/home/home_page.dart';
import 'package:sipinjam/pages/dashboardView/profile/account_view.dart';

class AppConstans {
  static const _host = 'http://192.168.1.3:8000';
  // localhost 'http://10.0.2.2/sipinjamfix/sipinjam'
  // server local 'http://192.168.1.7:8000'
  static const baseUrl = '$_host/api';
  static const imageUrl = '$baseUrl/assets';

  static List<Map> navMenuDashboard = [
    {
      'view': const HomePage(),
      'icon': Icons.home_filled,
      'label': 'Home',
    },
    {
      'view': const History(),
      'icon': Icons.history,
      'label': 'History',
    },
    {
      'view': const Text('Peminjaman'),
      'icon': Icons.article,
      'label': 'Peminjaman',
    },
    {
      'view': const Calendar(),
      'icon': Icons.calendar_month,
      'label': 'Calendar',
    },
    {
      'view': const AccountView(),
      'icon': Icons.person,
      'label': 'User',
    },
  ];
}
