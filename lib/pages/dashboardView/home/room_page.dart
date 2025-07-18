import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
          children: [header(context), roomList()],
        ),
      ),
    );
  }

  Expanded roomList() {
    return Expanded(
      child: Consumer(
        builder: (_, wiRef, __) {
          List<RuanganModel> ruanganList = wiRef.watch(ruanganProvider);
          final expandedIndex = wiRef.watch(expandedRoomProvider);
          return StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: List.generate(
                ruanganList.length,
                (index) {
                  RuanganModel ruangan = ruanganList[index];
                  final isExpanded = index == expandedIndex;
                  final imgSelected = wiRef.watch(imgSelectedProvider(index));
                  if (imgSelected.isEmpty && ruangan.fotoRuangan!.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setImgSelected(ref, index,
                          '${AppConstans.imageUrl}${ruangan.fotoRuangan!.first.replaceAll('../../../api/assets/', '/')}');
                    });
                  }

                  return StaggeredGridTile.count(
                      crossAxisCellCount: isExpanded ? 2 : 1,
                      mainAxisCellCount: isExpanded ? 2 : 1,
                      child: GestureDetector(
                          onTap: () {
                            setExpandedRoom(ref, isExpanded ? null : index);
                          },
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            switchInCurve: Curves.easeInOut,
                            switchOutCurve: Curves.easeInOut,
                            child: Container(
                              key: ValueKey(isExpanded
                                  ? 'expanded_$index'
                                  : 'default_$index'),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                isExpanded &&
                                                        imgSelected.isNotEmpty
                                                    ? imgSelected.replaceAll(
                                                        '../../../api/assets/',
                                                        '/')
                                                    : '${AppConstans.imageUrl}${ruangan.fotoRuangan!.first.replaceAll('../../../api/assets/', '/')}',
                                              ))),
                                    ),
                                  ),
                                  isExpanded
                                      ? roomExpandedInformation(
                                          ruangan,
                                          wiRef,
                                          expandedIndex,
                                          isExpanded,
                                          imgSelected)
                                      : roomDefaultInformation(ruangan)
                                ],
                              ),
                            ),
                          )));
                },
              ));
        },
      ),
    );
  }

  Padding roomExpandedInformation(RuanganModel ruangan, WidgetRef wiRef,
      int? expandedIndex, bool isExpaded, String imgSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ruangan.namaRuangan,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: isExpaded ? 18 : 12, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.people,
                  ),
                  Text(
                    ruangan.kapasitas.toString(),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              )
            ],
          ),
          Text(
            ruangan.namaGedung,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ruangan.namaFasilitas!.split(',').map((fasilitas) {
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
                    style: TextStyle(fontSize: isExpaded ? 16 : 12),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(
            height: 2,
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: ruangan.fotoRuangan!.length,
              itemBuilder: (context, index) {
                final foto = ruangan.fotoRuangan![index];
                final selected =
                    wiRef.watch(imgSelectedProvider(expandedIndex));
                final imgUrl =
                    '${AppConstans.imageUrl}${foto.replaceAll('../../../api/assets/', '/')}';

                return GestureDetector(
                  onTap: () {
                    setImgSelected(ref, expandedIndex, imgUrl);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.biruMuda,
                        width: selected == imgUrl ? 2 : 0,
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
          )
        ],
      ),
    );
  }

  Row roomDefaultInformation(RuanganModel ruangan) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          ruangan.namaRuangan,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
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
    );
  }

  TextButton header(BuildContext context) {
    return TextButton.icon(
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
        ));
  }
}
