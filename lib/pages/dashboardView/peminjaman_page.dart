import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void initState() {
    super.initState();
    AppSession.getUser().then(
      (value) {
        peminjam = value!;
        getKegiatan();
      },
    );
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
              Container(
                padding: const EdgeInsets.all(8),
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.gray),
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
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8)),
                          child: DropdownMenu(
                              width: double.infinity,
                              inputDecorationTheme: const InputDecorationTheme(
                                  border: InputBorder.none),
                              dropdownMenuEntries: kegiatanEntry.isNotEmpty
                                  ? kegiatanEntry.map(
                                      (kegiatan) {
                                        return DropdownMenuEntry(
                                            value: kegiatan,
                                            label: kegiatan.namaKegiatan);
                                      },
                                    ).toList()
                                  : [
                                      const DropdownMenuEntry(
                                          value: null, label: '')
                                    ]),
                        );
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
}
