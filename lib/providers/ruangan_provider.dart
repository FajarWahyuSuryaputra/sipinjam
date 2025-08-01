import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/models/ruangan_model.dart';

final ruanganStatusProvider = StateProvider.autoDispose((ref) => '');
final expandedRoomProvider = StateProvider<int?>(
  (ref) => null,
);
final imgSelectedProvider = StateProvider.family.autoDispose<String, int?>(
  (ref, index) => '',
);

setRuanganStatus(WidgetRef ref, String newStatus) {
  ref.read(ruanganStatusProvider.notifier).state = newStatus;
}

setExpandedRoom(WidgetRef ref, int? newStatus) {
  ref.read(expandedRoomProvider.notifier).state = newStatus;
}

setImgSelected(WidgetRef ref, int? index, String newStatus) {
  ref.read(imgSelectedProvider(index).notifier).state = newStatus;
}

final ruanganProvider =
    StateNotifierProvider.autoDispose<RuanganList, List<RuanganModel>>(
  (ref) => RuanganList([]),
);

class RuanganList extends StateNotifier<List<RuanganModel>> {
  RuanganList(super.state);
  setData(List<RuanganModel> newData) {
    state = newData;
  }
}


// search ruangan provider

