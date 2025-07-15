import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/config/app_colors.dart';
import 'package:sipinjam/datasources/ruangan_datasource.dart';
import 'package:sipinjam/models/gedung_model.dart';
import 'package:sipinjam/models/ruangan_model.dart';
import 'package:sipinjam/providers/ruangan_provider.dart';

import '../../../config/app_constans.dart';
import '../../../config/failure.dart';

class RoomPage extends ConsumerStatefulWidget {
  const RoomPage({super.key, required this.gedung});
  final GedungModel gedung;

  @override
  ConsumerState<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage> {
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
                .where(
              (element) {
                return element.idGedung == widget.gedung.idGedung;
              },
            ).toList();
            ref.read(ruanganProvider.notifier).setData(ruangans);
          },
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRuangan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.keyboard_backspace_rounded,
                  color: Colors.black,
                  size: 20,
                ),
                label: Text(
                  widget.gedung.namaGedung,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                )),
            Expanded(child: Consumer(
              builder: (_, wiRef, __) {
                List<RuanganModel> ruanganList = wiRef.watch(ruanganProvider);
                if (ruanganList.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada list ruangan'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8),
                  itemCount: ruanganList.length,
                  itemBuilder: (context, index) {
                    RuanganModel ruangan = ruanganList[index];
                    return Material(
                      color: AppColors.putih,
                      elevation: 3,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(ruangan.fotoRuangan !=
                                                  null &&
                                              ruangan.fotoRuangan!.isNotEmpty
                                          ? '${AppConstans.imageUrl}${ruangan.fotoRuangan!.first.replaceAll('../../../api/assets/', '/')}'
                                          : ''))),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                ruangan.namaRuangan,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.people,
                                    // size: 20,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(ruangan.kapasitas.toString())
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
