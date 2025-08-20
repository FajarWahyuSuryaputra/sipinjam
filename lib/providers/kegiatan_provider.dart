import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/models/kegiatan_model.dart';

final kegiatanStatusProvider = StateProvider.autoDispose(
  (ref) => '',
);

setKegiatanStatus(WidgetRef ref, String newStatus) {
  ref.read(kegiatanStatusProvider.notifier).state = newStatus;
}

final kegiatanProvider =
    StateNotifierProvider.autoDispose<KegiatanList, List<KegiatanModel>>(
  (ref) => KegiatanList([]),
);

class KegiatanList extends StateNotifier<List<KegiatanModel>> {
  KegiatanList(super.state);

  setData(List<KegiatanModel> newData) {
    state = newData;
  }
}

final kegiatanSelected = StateProvider.autoDispose<KegiatanModel?>(
  (ref) => null,
);

setKegiatanSelected(WidgetRef wiRef, KegiatanModel? kegiatan) {
  wiRef.read(kegiatanSelected.notifier).state = kegiatan;
}
