import 'package:flutter/material.dart';

class AppConstans {
  static const _host = 'http:192.168.8.1:8000';
  static const _baseUrl = '$_host/api';
  static const _imageUrl = '$_baseUrl/assets';

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
      'view': const Text('User'),
      'icon': Icons.person,
      'label': 'User',
    },
  ];
}
