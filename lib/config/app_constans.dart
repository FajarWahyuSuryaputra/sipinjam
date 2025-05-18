import 'package:flutter/material.dart';
import 'package:sipinjam/pages/dashboardView/home/home_page.dart';
import 'package:sipinjam/pages/dashboardView/profile/account_view.dart';

class AppConstans {
  static const _host = 'http://192.168.1.7:8000';
  static const baseUrl = '$_host/api';
  static const imageUrl = '$baseUrl/assets';
  // ../../../api/assets/gedung/mst.jpg
  // http://192.168.1.7:8000/api/assets/gedung/mst.jpg

  static List<Map> navMenuDashboard = [
    {
      'view': const HomePage(),
      'icon': Icons.home_filled,
      'label': 'Home',
    },
    {
      'view': const Text('History'),
      'icon': Icons.history,
      'label': 'History',
    },
    {
      'view': const Text('Peminjaman'),
      'icon': Icons.article,
      'label': 'Peminjaman',
    },
    {
      'view': const Text('Tanggal'),
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
