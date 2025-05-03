import 'package:flutter/material.dart';
import 'package:sipinjam/config/app_colors.dart';
import 'package:sipinjam/config/app_session.dart';
import 'package:sipinjam/models/peminjam_model.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PeminjamModel?>(
      future: AppSession.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Masih loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Ada error
          return Center(
            child: Text('Terjadi error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Tidak ada data user
          return const Center(
            child: Text('User belum login'),
          );
        }

        // Kalau sudah dapat data user
        PeminjamModel peminjam = snapshot.data!;

        return ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.biruMuda,
              ),
              child: Text(
                peminjam.namaPeminjam,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
