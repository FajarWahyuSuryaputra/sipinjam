import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/config/app_session.dart';
import 'package:sipinjam/datasources/peminjaman_datasource.dart';
import 'package:sipinjam/models/peminjam_model.dart';
import 'package:sipinjam/models/peminjaman_model.dart';

import '../../config/app_format.dart';
import '../../config/failure.dart';
import '../../providers/peminjaman_provider.dart';

class History extends ConsumerStatefulWidget {
  const History({super.key});

  @override
  ConsumerState<History> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<History> {
  late PeminjamModel peminjam;

  getAllPeminjaman() {
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
            setPeminjamanStatus(ref, 'Success');
            List data = result['data'];
            List<PeminjamanModel> peminjaman =
                data.map((e) => PeminjamanModel.fromJson(e)).toList();
            peminjaman.sort((a, b) => b.idPeminjaman.compareTo(a.idPeminjaman));
            ref.read(peminjamanProvider.notifier).setData(peminjaman);
          },
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppSession.getUser().then(
      (value) {
        peminjam = value!;
        getAllPeminjaman();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Text(
            'HISTORY',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Consumer(
            builder: (_, wiRef, __) {
              List<PeminjamanModel> list = wiRef.watch(peminjamanProvider);
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

              return SizedBox(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height,
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    PeminjamanModel peminjaman = list[index];
                    return Column(
                      children: [
                        Container(
                          // borderRadius: BorderRadius.circular(16),
                          // elevation: 3,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
                              )
                            ],
                          ),
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
                                        color:
                                            statusColor(peminjaman.namaStatus),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        )
                      ],
                    );
                  },
                ),
              );
            },
          ),
        )
      ],
    ));
  }
}
