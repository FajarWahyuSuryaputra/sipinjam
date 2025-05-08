import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/config/app_constans.dart';
import 'package:sipinjam/datasources/gedung_datasourcce.dart';
import 'package:sipinjam/models/gedung_model.dart';
import 'package:sipinjam/providers/gedung_provider.dart';

import '../../../config/failure.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  getGedung() {
    GedungDatasourcce.getAllGedung().then(
      (value) {
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure _:
                setGedungStatus(ref, 'Server Error');
                break;
              case NotFoundFailure:
                setGedungStatus(ref, 'Error Not Found');
                break;
              case ForbiddenFailure:
                setGedungStatus(ref, 'You don\'t have access');
                break;
              case BadRequestFailure:
                setGedungStatus(ref, 'Bad request');
                break;
              case UnauthorizedFailure:
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

  refresh() {
    getGedung();
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async => refresh(),
      child: ListView(
        children: [
          header(),
          const SizedBox(height: 20),
          Consumer(
            builder: (_, wiRef, __) {
              List<GedungModel> list = wiRef.watch(gedungProvider);
              if (list.isEmpty) {
                return Container(
                  height: 200,
                  color: Colors.amber,
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  GedungModel item = list[index];
                  return SizedBox(
                    height: 250,
                    child: GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        child: Column(
                          children: [
                            Container(
                              width: 300,
                              height: 300,
                              decoration: const BoxDecoration(
                                  color: Colors.amber
                                  // image: DecorationImage(
                                  //     image: NetworkImage(
                                  //         '${AppConstans.imageUrl}${item.fotoGedung.replaceAll('..../../../api/assets/', '/')}'))
                                  ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    ));
  }

  Padding header() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: "Search",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100))),
        ),
      ),
    );
  }
}
