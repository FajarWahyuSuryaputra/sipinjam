import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:sipinjam/config/app_colors.dart';
import 'package:sipinjam/config/app_session.dart';
import 'package:sipinjam/config/nav.dart';
import 'package:sipinjam/models/peminjam_model.dart';
import 'package:sipinjam/pages/login_page.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  logout(BuildContext context) {
    DInfo.dialogConfirmation(context, 'Logout', 'Anda yakin ingin keluar?',
            textNo: 'Kembali')
        .then(
      (yes) {
        if (yes ?? false) {
          AppSession.removeUser();
          Nav.replace(context, const LoginPage());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PeminjamModel?>(
      future: AppSession.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        PeminjamModel peminjam = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          children: [
            Container(
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.biruTua,
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: Icon(
                        Icons.person_outline_outlined,
                        size: 40,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: const Text(
                              'Username',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ),
                          Text(
                            peminjam.namaLengkap,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: const Text(
                              'Email',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ),
                          Text(
                            peminjam.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: 5,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {},
                      dense: true,
                      horizontalTitleGap: 14,
                      iconColor: Colors.black,
                      textColor: Colors.black,
                      leading: const Icon(Icons.edit),
                      title: const Text('Edit Profile'),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () {},
                      dense: true,
                      horizontalTitleGap: 14,
                      iconColor: Colors.black,
                      textColor: Colors.black,
                      leading: const Icon(Icons.notifications),
                      title: const Text('Notification'),
                      trailing: Switch.adaptive(
                        value: false,
                        inactiveThumbColor: AppColors.putih,
                        inactiveTrackColor: AppColors.biruMuda,
                        trackOutlineColor:
                            const WidgetStatePropertyAll(Colors.transparent),
                        onChanged: (value) {},
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      dense: true,
                      horizontalTitleGap: 14,
                      iconColor: Colors.black,
                      textColor: Colors.black,
                      leading: const Icon(Icons.language),
                      title: const Text('Bahasa'),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () {},
                      dense: true,
                      horizontalTitleGap: 14,
                      iconColor: Colors.black,
                      textColor: Colors.black,
                      leading: const Icon(Icons.question_answer),
                      title: const Text('Edit Profile'),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => logout(context),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 167, 45, 36)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
