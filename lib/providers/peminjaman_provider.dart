import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/models/peminjaman_model.dart';

final peminjamanStatusProvider = StateProvider.autoDispose(
  (ref) => '',
);

setPeminjamanStatus(WidgetRef ref, String newStatus) {
  ref.read(peminjamanStatusProvider.notifier).state = newStatus;
}

final peminjamanProvider =
    StateNotifierProvider.autoDispose<PeminjamanList, List<PeminjamanModel>>(
  (ref) => PeminjamanList([]),
);

class PeminjamanList extends StateNotifier<List<PeminjamanModel>> {
  PeminjamanList(super.state);

  setData(List<PeminjamanModel> newData) {
    state = newData;
  }
}
