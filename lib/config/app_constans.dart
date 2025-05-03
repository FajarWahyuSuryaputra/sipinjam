import 'package:flutter/material.dart';
import 'package:sipinjam/pages/dashboardView/profile/account_view.dart';

class AppConstans {
  static const _host = 'http://192.168.1.8:8000';
  static const baseUrl = '$_host/api';
  static const imageUrl = '$baseUrl/assets';

  static List<Map> navMenuDashboard = [
    {
      'view': const Text('HomeView'),
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
