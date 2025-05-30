import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/config/app_colors.dart';
import 'package:sipinjam/config/app_constans.dart';
import 'package:sipinjam/config/app_format.dart';
import 'package:sipinjam/config/app_session.dart';
import 'package:sipinjam/datasources/gedung_datasourcce.dart';
import 'package:sipinjam/datasources/peminjaman_datasource.dart';
import 'package:sipinjam/models/gedung_model.dart';
import 'package:sipinjam/models/peminjam_model.dart';
import 'package:sipinjam/models/peminjaman_model.dart';
import 'package:sipinjam/providers/gedung_provider.dart';
import 'package:sipinjam/providers/peminjaman_provider.dart';
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
              case NotFoundFailure _:
                setGedungStatus(ref, 'Error Not Found');
                break;
              case ForbiddenFailure _:
                setGedungStatus(ref, 'You don\'t have access');
                break;
              case BadRequestFailure _:
                setGedungStatus(ref, 'Bad request');
                break;
              case UnauthorizedFailure _:
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

  late PeminjamModel peminjam;
  getPeminjaman() {
    PeminjamanDatasource.peminjamanByOrmawa(peminjam.idOrmawa).then(
      (value) {
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure _:
                setPeminjamanStatus(ref, 'Server Error');
                break;
              case NotFoundFailure _:
                setPeminjamanStatus(ref, 'Error Not Found');
                break;
              case ForbiddenFailure _:
                setPeminjamanStatus(ref, 'You don\'t have access');
                break;
              case BadRequestFailure _:
                setPeminjamanStatus(ref, 'Bad request');
                break;
              case UnauthorizedFailure _:
                setPeminjamanStatus(ref, 'Unauthorised');
                break;
              default:
                setPeminjamanStatus(ref, 'Request Error');
                break;
            }
          },
          (result) {
            setPeminjamanStatus(ref, "Success");
            List data = result['data'];
            List<PeminjamanModel> peminjaman = data
                .map(
              (e) => PeminjamanModel.fromJson(e),
            )
                .where(
              (element) {
                final tglPeminjaman =
                    DateTime.tryParse('${element.tglPeminjaman}');
                return element.namaStatus != 'ditolak' &&
                    tglPeminjaman != null &&
                    tglPeminjaman.isAfter(DateTime.now());
              },
            ).toList();
            ref.read(peminjamanProvider.notifier).setData(peminjaman);
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
    super.initState();
    AppSession.getUser().then(
      (value) {
        peminjam = value!;
        refresh();
      },
    );
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
          const SizedBox(
            height: 20,
          ),
          peminjaman()
        ],
      ),
    ));
  }

  Consumer peminjaman() {
    Color statusColor(String status) {
      switch (status) {
        case 'disetujui':
          return Colors.green[700]!;
        case 'proses':
          return Colors.blue[900]!;
        case 'ditolak':
          return Colors.red[700]!;
        default:
          return Colors.black;
      }
    }

    return Consumer(
      builder: (_, wiRef, __) {
        List<PeminjamanModel> listPeminjaman = wiRef.watch(peminjamanProvider);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ruangan yang dipinjam',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              if (listPeminjaman.isEmpty)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.grey,
                    child: const Center(
                      child: Text('Tidak ada ruangan yang dipinjam'),
                    ),
                  ),
                ),
              if (listPeminjaman.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.32,
                  child: ListView.builder(
                    itemCount: listPeminjaman.length,
                    itemBuilder: (context, index) {
                      PeminjamanModel peminjaman = listPeminjaman[index];
                      return Column(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(16),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    peminjaman.namaRuangan,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    peminjaman.namaKegiatan,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Container(
                                    height: 3,
                                    width: double.infinity,
                                    color: Colors.grey[800],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppFormat.justDate(
                                            peminjaman.tglPeminjaman),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      Text(
                                        peminjaman.namaStatus,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          color: statusColor(
                                              peminjaman.namaStatus),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          )
                        ],
                      );
                    },
                  ),
                )
            ],
          ),
        );
      },
    );
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
              height: 12,
            ),
            SmoothPageIndicator(
              controller: pageController,
              count: list.length,
              effect: const SwapEffect(
                  dotWidth: 10,
                  dotHeight: 10,
                  activeDotColor: AppColors.biruMuda),
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
