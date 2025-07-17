import 'package:flutter/material.dart';
import 'package:sipinjam/models/ruangan_model.dart';

import '../../../config/app_constans.dart';

class RoomDetailPage extends StatelessWidget {
  const RoomDetailPage({super.key, required this.room});
  final RuanganModel room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.65,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      '${AppConstans.imageUrl}${room.fotoRuangan!.first.replaceAll('../../../api/assets/', '/')}'))),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(128, 158, 158, 158)),
                ),
              )
            ],
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(room.namaGedung), Text(room.namaRuangan)],
                ),
                Text(room.namaRuangan),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: room.namaFasilitas!.split(',').map((fasilitas) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 16,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fasilitas.trim(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        )
      ],
    ));
  }
}
