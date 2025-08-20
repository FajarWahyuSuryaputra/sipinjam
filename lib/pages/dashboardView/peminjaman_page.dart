import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sipinjam/config/app_colors.dart';
import 'package:sipinjam/config/app_session.dart';
import 'package:sipinjam/datasources/kegiatan_datasource.dart';
import 'package:sipinjam/models/kegiatan_model.dart';
import 'package:sipinjam/models/peminjam_model.dart';
import 'package:sipinjam/providers/kegiatan_provider.dart';

import '../../config/failure.dart';

class PeminjamanPage extends ConsumerStatefulWidget {
  const PeminjamanPage({super.key});

  @override
  ConsumerState<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends ConsumerState<PeminjamanPage> {
  late PeminjamModel peminjam;

  getKegiatan() {
    KegiatanDatasource.getAllKegiatan().then(
      (value) {
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure _:
                setKegiatanStatus(ref, 'Server Error');
                break;
              case NotFoundFailure _:
                setKegiatanStatus(ref, 'Error Not Found');
                break;
              case ForbiddenFailure _:
                setKegiatanStatus(ref, 'You don\'t have access');
                break;
              case BadRequestFailure _:
                setKegiatanStatus(ref, 'Bad request');
                break;
              case UnauthorizedFailure _:
                setKegiatanStatus(ref, 'Unauthorised');
                break;
              default:
                setKegiatanStatus(ref, 'Request Error');
                break;
            }
          },
          (result) {
            setKegiatanStatus(ref, "Success");
            List data = result['data'];
            List<KegiatanModel> kegiatans = data
                .map(
              (e) => KegiatanModel.fromJson(e),
            )
                .where(
              (element) {
                return element.idOrmawa == peminjam.idOrmawa;
              },
            ).toList();
            ref.read(kegiatanProvider.notifier).setData(kegiatans);
          },
        );
      },
    );
  }

  late TextEditingController kegiatanController;
  late FocusNode kegiatanNode;

  @override
  void initState() {
    super.initState();
    AppSession.getUser().then(
      (value) {
        peminjam = value!;
        getKegiatan();
      },
    );
    kegiatanController = TextEditingController();
    kegiatanNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    kegiatanController.dispose();
    kegiatanNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Peminjaman',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              kegiatanCard(context),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.gray,
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 61, 61, 61),
                          offset: Offset(2, 2),
                          blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ruangan',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.biruTua),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                          color: AppColors.putih,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8)),
                      child: DropdownMenu(
                        hintText: 'Pilih Ruangan',
                        enableFilter: true,
                        // controller: kegiatanController,
                        // focusNode: kegiatanNode,
                        width: double.infinity,
                        inputDecorationTheme: const InputDecorationTheme(
                            border: InputBorder.none),
                        dropdownMenuEntries: const [],
                        onSelected: (value) {
                          // setKegiatanSelected(wiRef, value);
                          // FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      'Tanggal Peminjaman',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.biruTua),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                            color: AppColors.putih,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8)),
                        child: TextField(
                          readOnly: true,
                          textAlignVertical: const TextAlignVertical(y: 0),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Pilih Tanggal Pinjam',
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.calendar_month_outlined,
                                    color: AppColors.biruTua,
                                  ))),
                        )),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      'Sesi Peminjaman',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.biruTua),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Consumer(
                      builder: (_, wiRef, __) {
                        return SizedBox(
                            width: double.infinity,
                            child: StaggeredGrid.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                              children: [
                                StaggeredGridTile.count(
                                  crossAxisCellCount: 1,
                                  mainAxisCellCount: .4,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.putih,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all()),
                                      child: const Center(
                                        child: Text(
                                          'Sesi Pagi',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )),
                                ),
                                StaggeredGridTile.count(
                                  crossAxisCellCount: 1,
                                  mainAxisCellCount: .4,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.putih,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all()),
                                      child: const Center(
                                        child: Text(
                                          'Sesi Siang',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )),
                                ),
                                StaggeredGridTile.count(
                                  crossAxisCellCount: 2,
                                  mainAxisCellCount: .4,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.putih,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all()),
                                      child: const Center(
                                        child: Text(
                                          'Full Sesi',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            ));
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Container kegiatanCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.gray,
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 61, 61, 61),
                offset: Offset(2, 2),
                blurRadius: 2)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kegiatan',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.biruTua),
          ),
          const SizedBox(
            height: 4,
          ),
          Consumer(
            builder: (_, wiRef, __) {
              final kegiatanEntry = wiRef.watch(kegiatanProvider);
              final kegiatanSelect = wiRef.watch(kegiatanSelected);
              kegiatanController.text = kegiatanSelect?.namaKegiatan ?? '';
              return Container(
                padding: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                    color: AppColors.putih,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8)),
                child: DropdownMenu(
                  hintText: 'Pilih Kegiatan',
                  enableFilter: true,
                  controller: kegiatanController,
                  focusNode: kegiatanNode,
                  width: double.infinity,
                  inputDecorationTheme:
                      const InputDecorationTheme(border: InputBorder.none),
                  dropdownMenuEntries: kegiatanEntry.isNotEmpty
                      ? kegiatanEntry.map(
                          (kegiatan) {
                            return DropdownMenuEntry(
                                value: kegiatan, label: kegiatan.namaKegiatan);
                          },
                        ).toList()
                      : [const DropdownMenuEntry(value: null, label: '')],
                  onSelected: (value) {
                    setKegiatanSelected(wiRef, value);
                    FocusScope.of(context).unfocus();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
