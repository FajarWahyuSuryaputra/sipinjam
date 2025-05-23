import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/config/app_colors.dart';
import 'package:sipinjam/config/app_constans.dart';
import 'package:sipinjam/providers/dashboard_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (_, wiRef, __) {
          int navIndex = wiRef.watch(dashboardNavIndexProvider);
          return AppConstans.navMenuDashboard[navIndex]['view'] as Widget;
        },
      ),
      // extendBody: true,
      bottomNavigationBar: Consumer(
        builder: (_, wiRef, __) {
          int navIndex = wiRef.watch(dashboardNavIndexProvider);
          return Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            color: AppColors.gray,
            elevation: 10,
            child: BottomNavigationBar(
                currentIndex: navIndex,
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconSize: 25,
                type: BottomNavigationBarType.fixed,
                onTap: (value) {
                  wiRef.read(dashboardNavIndexProvider.notifier).state = value;
                },
                showUnselectedLabels: false,
                showSelectedLabels: false,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey[600],
                items: AppConstans.navMenuDashboard.map(
                  (e) {
                    return BottomNavigationBarItem(
                        icon: Icon(
                          e['icon'],
                        ),
                        label: e['label']);
                  },
                ).toList()),
          );
        },
      ),
    );
  }
}
