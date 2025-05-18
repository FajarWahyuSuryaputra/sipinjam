import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/config/app_colors.dart';
import 'package:sipinjam/config/app_constans.dart';
import 'package:sipinjam/config/app_session.dart';
import 'package:sipinjam/datasources/gedung_datasourcce.dart';
import 'package:sipinjam/datasources/peminjaman_datasource.dart';
import 'package:sipinjam/models/gedung_model.dart';
import 'package:sipinjam/models/peminjam_model.dart';
import 'package:sipinjam/providers/gedung_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../config/failure.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  getGedung() {
    GedungDatasourcce.getAllGedung().then(
      (value) {
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure _:
                setGedungStatus(ref, 'Server Error');
                break;
              case NotFoundFailure:
                setGedungStatus(ref, 'Error Not Found');
                break;
              case ForbiddenFailure:
                setGedungStatus(ref, 'You don\'t have access');
                break;
              case BadRequestFailure:
                setGedungStatus(ref, 'Bad request');
                break;
              case UnauthorizedFailure:
                setGedungStatus(ref, 'Unauthorised');
                break;
              default:
                setGedungStatus(ref, 'Request Error');
                break;
            }
          },
          (result) {
            setGedungStatus(ref, "Success");
            List data = result['data'];
            List<GedungModel> gedungs = data
                .map(
                  (e) => GedungModel.fromJson(e),
                )
                .toList();
            ref.read(gedungProvider.notifier).setData(gedungs);
          },
        );
      },
    );
  }

  getPeminjaman() {
    Future<PeminjamModel?> user = AppSession.getUser();
    PeminjamModel peminjam = user;
    PeminjamanDatasource.peminjamanByOrmawa(peminjam.).then(
      (value) {
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure _:
                setGedungStatus(ref, 'Server Error');
                break;
              case NotFoundFailure:
                setGedungStatus(ref, 'Error Not Found');
                break;
              case ForbiddenFailure:
                setGedungStatus(ref, 'You don\'t have access');
                break;
              case BadRequestFailure:
                setGedungStatus(ref, 'Bad request');
                break;
              case UnauthorizedFailure:
                setGedungStatus(ref, 'Unauthorised');
                break;
              default:
                setGedungStatus(ref, 'Request Error');
                break;
            }
          },
          (result) {
            setGedungStatus(ref, "Success");
            List data = result['data'];
            List<GedungModel> gedungs = data
                .map(
                  (e) => GedungModel.fromJson(e),
                )
                .toList();
            ref.read(gedungProvider.notifier).setData(gedungs);
          },
        );
      },
    );
  }

  refresh() {
    getGedung();
    getPeminjaman();
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async => refresh(),
      child: ListView(
        children: [
          header(),
          const SizedBox(height: 20),
          gedung(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Ruangan yang dipinjam',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Consumer gedung() {
    PageController pageController = PageController(viewportFraction: 0.85);
    return Consumer(
      builder: (_, wiRef, __) {
        List<GedungModel> list = wiRef.watch(gedungProvider);
        if (list.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const Center(
                child: Text(
              'list empty',
              style: TextStyle(),
            )),
          );
        }
        return Column(
          children: [
            SizedBox(
              height: 210,
              child: PageView.builder(
                controller: pageController,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  GedungModel item = list[index];
                  return Container(
                    margin: EdgeInsets.only(
                        right: index != list.length - 1 ? 8 : 0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      '${AppConstans.imageUrl}${item.fotoGedung.replaceAll('../../../api/assets/', '/')}'))),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: AppColors.gray,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    topRight: Radius.circular(10))),
                            child: Text(
                              item.namaGedung,
                              style: const TextStyle(
                                  height: 1, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SmoothPageIndicator(
              controller: pageController,
              count: list.length,
              effect: const SwapEffect(
                  dotWidth: 10,
                  dotHeight: 10,
                  activeDotColor: AppColors.biruTua),
            )
          ],
        );
      },
    );
  }

  Padding header() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: "Search",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100))),
        ),
      ),
    );
  }
}
