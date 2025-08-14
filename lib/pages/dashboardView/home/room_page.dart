import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/config/nav.dart';
import 'package:sipinjam/datasources/ruangan_datasource.dart';
import 'package:sipinjam/models/gedung_model.dart';
import 'package:sipinjam/models/ruangan_model.dart';
import 'package:sipinjam/pages/dashboard.dart';
import 'package:sipinjam/providers/ruangan_provider.dart';

import '../../../config/failure.dart';
import '../../../widget.dart';

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
            header(context),
            Expanded(child: Consumer(
              builder: (_, wiRef, __) {
                List<RuanganModel> listRoom = wiRef.watch(ruanganProvider);

                return Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: List.generate(
                      listRoom.length,
                      (index) {
                        RuanganModel room = listRoom[index];
                        final expandedRoomId =
                            wiRef.watch(expandedRoomIdProvider);
                        return GestureDetector(
                          onTap: () {
                            if (expandedRoomId == room.idRuangan) {
                              setExpandedRoomId(ref, null); // collapse
                            } else {
                              setExpandedRoomId(
                                  ref, room.idRuangan); // expand this one
                            }
                          },
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: expandedRoomId == room.idRuangan
                                ? expandRoomItem(room, context, wiRef)
                                : defaultRoomItem(room, 0.435, context),
                          ),
                        );
                      },
                    ));
              },
            ))
          ],
        ),
      ),
    );
  }

  TextButton header(BuildContext context) {
    return TextButton.icon(
        onPressed: () {
          Nav.replace(context, const Dashboard());
        },
        icon: const Icon(
          Icons.keyboard_backspace_rounded,
          color: Colors.black,
          size: 20,
        ),
        label: Text(
          widget.gedung.namaGedung,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ));
  }
}
