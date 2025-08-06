import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sipinjam/config/app_colors.dart';
import 'package:sipinjam/config/nav.dart';
import 'package:sipinjam/datasources/ruangan_datasource.dart';
import 'package:sipinjam/models/gedung_model.dart';
import 'package:sipinjam/models/ruangan_model.dart';
import 'package:sipinjam/pages/dashboardView/home/home_page.dart';
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
                //     .where(
                //   (element) {
                //     return element.idGedung == widget.gedung.idGedung;
                //   },
                // )
                .toList();
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
                            duration: const Duration(milliseconds: 400),
                            switchInCurve: Curves.easeInOut,
                            switchOutCurve: Curves.easeInOut,
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
                                ? expandRoomItem(room, context)
                                : defaultRoomItem(room, context),
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
          Nav.replace(context, const HomePage());
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

Widget expandRoomItem(RuanganModel room, BuildContext context) {
  return Container(
    key: const ValueKey('expanded'),
    width: MediaQuery.sizeOf(context).width,
    decoration: BoxDecoration(
        color: AppColors.gray, borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.2,
          decoration: BoxDecoration(
              image: room.fotoRuangan!.isNotEmpty
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          '${AppConstans.imageUrl}${room.fotoRuangan!.first.replaceAll('../../../api/assets/', '/')}'))
                  : null,
              color: room.fotoRuangan!.isNotEmpty ? null : Colors.grey,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Icon(room.fotoRuangan!.isNotEmpty ? null : Icons.warning),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(room.namaRuangan),
              Row(
                children: [
                  const Icon(Icons.people),
                  Text(room.kapasitas.toString())
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            height: 2,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(2)),
          ),
        ),
        if (room.namaFasilitas!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
            child: Text('Fasilitas Ruangan: ${room.namaFasilitas}'),
          ),
        if (room.fotoRuangan!.isNotEmpty)
          SizedBox(
            height: 60,
            child: ListView.builder(
              padding: const EdgeInsets.all(4),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: room.fotoRuangan!.length,
              itemBuilder: (context, index) {
                final foto = room.fotoRuangan![index];
                // final selected =
                //     wiRef.watch(imgSelectedProvider(expandedIndex));
                final imgUrl =
                    '${AppConstans.imageUrl}${foto.replaceAll('../../../api/assets/', '/')}';

                return GestureDetector(
                  onTap: () {
                    // setImgSelected(ref, expandedIndex, imgUrl);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.biruMuda,
                        // width: selected == imgUrl ? 2 : 0,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        image: NetworkImage(imgUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
          child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.amber),
                  textStyle:
                      WidgetStatePropertyAll(TextStyle(color: Colors.black))),
              onPressed: () {},
              child: const Text('Pinjam Ruangan')),
        )
      ],
    ),
  );
}

Widget defaultRoomItem(RuanganModel room, BuildContext context) {
  return Container(
    key: const ValueKey('default'),
    height: MediaQuery.sizeOf(context).height * 0.25,
    width: MediaQuery.sizeOf(context).width * 0.435,
    decoration: BoxDecoration(
        color: AppColors.gray, borderRadius: BorderRadius.circular(12)),
    child: Column(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: room.fotoRuangan!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(
                          '${AppConstans.imageUrl}${room.fotoRuangan!.first.replaceAll('../../../api/assets/', '/')}'),
                      fit: BoxFit.cover)
                  : null,
              color: room.fotoRuangan!.isNotEmpty ? null : Colors.grey),
          child: Center(
            child: Icon(room.fotoRuangan!.isEmpty ? Icons.warning : null),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(room.namaRuangan),
              Row(
                children: [
                  const Icon(Icons.people),
                  Text(room.kapasitas.toString())
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}
