import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/config/app_colors.dart';
import 'package:sipinjam/providers/calendar_provider.dart';

import '../../config/failure.dart';
import '../../datasources/gedung_datasourcce.dart';
import '../../datasources/ruangan_datasource.dart';
import '../../models/gedung_model.dart';
import '../../models/ruangan_model.dart';
import '../../providers/gedung_provider.dart';
import '../../providers/ruangan_provider.dart';

class Calendar extends ConsumerStatefulWidget {
  const Calendar({super.key});

  @override
  ConsumerState<Calendar> createState() => _CalendarState();
}

class _CalendarState extends ConsumerState<Calendar> {
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
    // getPeminjaman();
    getRuangan();
  }

  late TextEditingController gedungController;
  late TextEditingController ruanganController;
  late FocusNode gedungFilterNode;
  late FocusNode ruanganFilterNode;

  @override
  void initState() {
    super.initState();
    gedungController = TextEditingController();
    gedungFilterNode = FocusNode();
    ruanganController = TextEditingController();
    ruanganFilterNode = FocusNode();
    refresh();
  }

  @override
  void dispose() {
    gedungController.dispose();
    gedungFilterNode.dispose();
    ruanganController.dispose();
    ruanganFilterNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CALENDAR',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: Consumer(
                  builder: (_, wiRef, __) {
                    final gedungEntries = wiRef.watch(gedungProvider);
                    final gedungSelected = wiRef.watch(gedungCalendarProvider);
                    final ruanganEntries = wiRef.watch(ruanganProvider);
                    final ruanganSelected =
                        wiRef.watch(ruanganCalendarProvider);
                    gedungController.text = gedungSelected?.namaGedung ?? '';
                    ruanganController.text = ruanganSelected?.namaRuangan ?? '';
                    return Container(
                      padding: const EdgeInsets.all(8),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                          color: AppColors.gray,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: DropdownMenu(
                              controller: gedungController,
                              hintText: 'Cari Gedung',
                              focusNode: gedungFilterNode,
                              enableFilter: true,
                              width: double.infinity,
                              dropdownMenuEntries: gedungEntries.isNotEmpty
                                  ? gedungEntries.map(
                                      (gedung) {
                                        return DropdownMenuEntry(
                                            value: gedung,
                                            label: gedung.namaGedung);
                                      },
                                    ).toList()
                                  : [
                                      const DropdownMenuEntry(
                                          value: null, label: '')
                                    ],
                              onSelected: (value) {
                                setGedungCalendar(ref, value);
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: DropdownMenu(
                              controller: ruanganController,
                              hintText: 'Cari Ruangan',
                              focusNode: ruanganFilterNode,
                              errorText: gedungSelected != null
                                  ? null
                                  : 'Pilih gedung terlebih dahulu',
                              enabled: gedungSelected != null ? true : false,
                              enableFilter: true,
                              width: double.infinity,
                              dropdownMenuEntries: gedungEntries.isNotEmpty
                                  ? ruanganEntries
                                      .where((element) =>
                                          element.idGedung ==
                                          gedungSelected?.idGedung)
                                      .map(
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
                                setRuanganCalendar(ref, value);
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {},
                                child: const Text(
                                  'Lihat Jadwal',
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
