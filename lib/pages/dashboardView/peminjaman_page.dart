import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sipinjam/config/app_colors.dart';
import 'package:sipinjam/config/app_format.dart';
import 'package:sipinjam/config/app_session.dart';
import 'package:sipinjam/datasources/kegiatan_datasource.dart';
import 'package:sipinjam/models/kegiatan_model.dart';
import 'package:sipinjam/models/peminjam_model.dart';
import 'package:sipinjam/providers/kegiatan_provider.dart';

import '../../config/failure.dart';
import '../../datasources/ruangan_datasource.dart';
import '../../models/ruangan_model.dart';
import '../../providers/peminjaman_provider.dart';
import '../../providers/ruangan_provider.dart';

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

  late TextEditingController kegiatanController;
  late FocusNode kegiatanNode;
  late TextEditingController ruanganController;
  late FocusNode ruanganNode;
  late TextEditingController tanggalController;
  late TextEditingController keteranganController;

  @override
  void initState() {
    super.initState();
    AppSession.getUser().then(
      (value) {
        peminjam = value!;
        getKegiatan();
        getRuangan();
      },
    );
    kegiatanController = TextEditingController();
    kegiatanNode = FocusNode();
    ruanganController = TextEditingController();
    ruanganNode = FocusNode();
    tanggalController = TextEditingController();
    keteranganController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    kegiatanController.dispose();
    kegiatanNode.dispose();
    ruanganController.dispose();
    ruanganNode.dispose();
    tanggalController.dispose();
    keteranganController.dispose();
  }

  int? sesi;

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
                      child: Consumer(
                        builder: (_, wiRef, __) {
                          final ruanganEntry = wiRef.watch(ruanganProvider);
                          final ruanganSelect =
                              wiRef.watch(ruanganSelectedProvider);
                          ruanganController.text =
                              ruanganSelect?.namaRuangan ?? '';
                          return DropdownMenu(
                            hintText: 'Pilih Ruangan',
                            enableFilter: true,
                            controller: ruanganController,
                            focusNode: ruanganNode,
                            width: double.infinity,
                            inputDecorationTheme: const InputDecorationTheme(
                                border: InputBorder.none),
                            dropdownMenuEntries: ruanganEntry.isNotEmpty
                                ? ruanganEntry.map(
                                    (ruangan) {
                                      return DropdownMenuEntry(
                                          value: ruangan,
                                          label: ruangan.namaRuangan);
                                    },
                                  ).toList()
                                : [
                                    const DropdownMenuEntry(
                                        value: null, label: '')
                                  ],
                            onSelected: (value) {
                              setRuanganSelected(wiRef, value);
                              FocusScope.of(context).unfocus();
                            },
                          );
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
                    Consumer(
                      builder: (_, wiRef, __) {
                        return Container(
                            padding: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                                color: AppColors.putih,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              readOnly: true,
                              controller: tanggalController,
                              onTap: () {
                                // print('ditekan');
                              },
                              textAlignVertical: const TextAlignVertical(y: 0),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Pilih Tanggal Pinjam',
                                  suffixIcon: IconButton(
                                      onPressed: () => showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1970),
                                            lastDate: DateTime(9999),
                                          ).then((value) {
                                            if (value != null) {
                                              tanggalController.text =
                                                  AppFormat.justDate(value);
                                            }
                                          }),
                                      icon: const Icon(
                                        Icons.calendar_month_outlined,
                                        color: AppColors.biruTua,
                                      ))),
                            ));
                      },
                    ),
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
                        final sesiSelected = wiRef.watch(sesiSelectedProvider);
                        sesi = sesiSelected;
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
                                  child: GestureDetector(
                                    onTap: () {
                                      setSesiSelected(wiRef, 1);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.putih,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: sesiSelected == 1
                                                ? Border.all(
                                                    color: AppColors.biruMuda,
                                                    width: 2,
                                                  )
                                                : Border.all()),
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
                                ),
                                StaggeredGridTile.count(
                                  crossAxisCellCount: 1,
                                  mainAxisCellCount: .4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setSesiSelected(wiRef, 2);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.putih,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: sesiSelected == 2
                                                ? Border.all(
                                                    color: AppColors.biruMuda,
                                                    width: 2,
                                                  )
                                                : Border.all()),
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
                                ),
                                StaggeredGridTile.count(
                                  crossAxisCellCount: 2,
                                  mainAxisCellCount: .4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setSesiSelected(wiRef, 3);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.putih,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: sesiSelected == 3
                                                ? Border.all(
                                                    color: AppColors.biruMuda,
                                                    width: 2,
                                                  )
                                                : Border.all()),
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
                                ),
                              ],
                            ));
                      },
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      'Keterangan',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.biruTua),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: AppColors.putih,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all()),
                        child: TextField(
                          controller: keteranganController,
                          maxLines: 3,
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Pinjam Ruangan',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
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
            height: 2,
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
