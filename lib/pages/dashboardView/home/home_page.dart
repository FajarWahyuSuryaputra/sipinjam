import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/config/app_colors.dart';
import 'package:sipinjam/config/app_constans.dart';
import 'package:sipinjam/config/app_format.dart';
import 'package:sipinjam/config/app_session.dart';
import 'package:sipinjam/config/nav.dart';
import 'package:sipinjam/datasources/gedung_datasourcce.dart';
import 'package:sipinjam/datasources/peminjaman_datasource.dart';
import 'package:sipinjam/models/gedung_model.dart';
import 'package:sipinjam/models/peminjam_model.dart';
import 'package:sipinjam/models/peminjaman_model.dart';
import 'package:sipinjam/pages/dashboardView/home/room_page.dart';
import 'package:sipinjam/providers/gedung_provider.dart';
import 'package:sipinjam/providers/peminjaman_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../config/failure.dart';
import '../../../datasources/ruangan_datasource.dart';
import '../../../models/ruangan_model.dart';
import '../../../providers/ruangan_provider.dart';

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

  getRuangan() {
    RuanganDatasource.getAllRuangan().then(
      (value) {
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure _:
                setRuanganStatus(ref, 'Server Error');
                break;
              case NotFoundFailure _:
                setRuanganStatus(ref, 'Error Not Found');
                break;
              case ForbiddenFailure _:
                setRuanganStatus(ref, 'You don\'t have access');
                break;
              case BadRequestFailure _:
                setRuanganStatus(ref, 'Bad request');
                break;
              case UnauthorizedFailure _:
                setRuanganStatus(ref, 'Unauthorised');
                break;
              default:
                setRuanganStatus(ref, 'Request Error');
                break;
            }
          },
          (result) {
            setRuanganStatus(ref, 'Success');
            List data = result['data'];
            List<RuanganModel> ruangans = data
                .map(
                  (e) => RuanganModel.fromJson(e),
                )
                .toList();
            ref.read(ruanganProvider.notifier).setData(ruangans);
          },
        );
      },
    );
  }

  refresh() {
    getGedung();
    getPeminjaman();
    getRuangan();
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
    PageController pageController = PageController(viewportFraction: 0.9);
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
                    child: GestureDetector(
                      onTap: () => Nav.push(context, RoomPage(gedung: item)),
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
                  dotWidth: 8,
                  dotHeight: 8,
                  activeDotColor: AppColors.biruMuda),
            )
          ],
        );
      },
    );
  }

  final SearchController _searchController = SearchController();
  Padding header() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Consumer(
          builder: (_, wiRef, __) {
            List<RuanganModel> ruangan = wiRef.watch(ruanganProvider);
            return SearchAnchor(
              searchController: _searchController,
              viewHintText: 'Cari Ruangan ...',
              builder: (context, controller) {
                return SearchBar(
                  padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 20)),
                  controller: controller,
                  hintText: 'Cari Ruangan ...',
                  onTap: () => controller.openView(),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  onChanged: (_) => controller.openView(),
                  leading: const Icon(Icons.search),
                );
              },
              suggestionsBuilder: (context, controller) {
                final search = controller.value.text;

                final result = ruangan.where(
                  (ruangan) {
                    return ruangan.namaRuangan.toLowerCase().contains(search);
                  },
                ).toList();

                return result.map(
                  (item) {
                    return Consumer(
                      builder: (_, wiRef, __) {
                        final height = wiRef
                            .watch(heightContainerProvider(item.idRuangan));
                        final index = wiRef.watch(indexSearchProvider);
                        final same = index == item.idRuangan;
                        return GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            if (!same) {
                              setIndexSearch(ref, item.idRuangan);
                              setNewHeight(ref, item.idRuangan, 250);
                            } else {
                              setIndexSearch(ref, null);
                              setNewHeight(ref, item.idRuangan, 175);
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            height: height,
                            margin: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(174, 0, 0, 0),
                                      offset: Offset(2, 2))
                                ]),
                            child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: item.fotoRuangan!.isNotEmpty
                                              ? DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      '${AppConstans.imageUrl}${item.fotoRuangan!.first.replaceAll('../../../api/assets/', '/')}'))
                                              : null),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                            color: AppColors.gray,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(8),
                                            )),
                                        child: Text(
                                          item.namaGedung,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item.namaRuangan),
                                      Row(
                                        children: [
                                          const Icon(Icons.people),
                                          Text(item.kapasitas.toString())
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: item.namaFasilitas!
                                        .split(',')
                                        .map((fasilitas) {
                                      if (fasilitas.isEmpty) {
                                        return const SizedBox();
                                      }
                                      return Row(
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            size: 8,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            fasilitas.trim(),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ).toList();
              },
            );
          },
        ));
  }
}
