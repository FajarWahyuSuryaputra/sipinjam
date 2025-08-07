import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/config/app_colors.dart';
import 'package:sipinjam/config/app_constans.dart';
import 'package:sipinjam/models/ruangan_model.dart';
import 'package:sipinjam/providers/ruangan_provider.dart';

Widget expandRoomItem(
    RuanganModel room, BuildContext context, WidgetRef wiref) {
  final selectedImage = wiref.watch(imgSelectedProvider(room.idRuangan));
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
                      image: NetworkImage(selectedImage.isNotEmpty
                          ? selectedImage
                          : '${AppConstans.imageUrl}${room.fotoRuangan!.first.replaceAll('../../../api/assets/', '/')}'))
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
                final imgUrl =
                    '${AppConstans.imageUrl}${foto.replaceAll('../../../api/assets/', '/')}';

                return GestureDetector(
                  onTap: () {
                    setImgSelected(wiref, room.idRuangan, imgUrl);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.biruMuda,
                        width: selectedImage == imgUrl ? 2 : 0,
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

Widget defaultRoomItem(RuanganModel room, double width, BuildContext context) {
  return Container(
    key: const ValueKey('default'),
    height: MediaQuery.sizeOf(context).height * 0.25,
    width: MediaQuery.sizeOf(context).width * width,
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
