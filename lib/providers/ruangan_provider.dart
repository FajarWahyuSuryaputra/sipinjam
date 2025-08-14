import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/models/ruangan_model.dart';

final ruanganStatusProvider = StateProvider.autoDispose((ref) => '');

setRuanganStatus(WidgetRef ref, String newStatus) {
  ref.read(ruanganStatusProvider.notifier).state = newStatus;
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

// ruangan page provider
final expandedRoomIdProvider = StateProvider<int?>((ref) => null);

void setExpandedRoomId(WidgetRef ref, int? id) {
  ref.read(expandedRoomIdProvider.notifier).state = id;
}

final imgSelectedProvider = StateProvider.family.autoDispose<String, int?>(
  (ref, index) => '',
);

setImgSelected(WidgetRef ref, int? index, String newStatus) {
  ref.read(imgSelectedProvider(index).notifier).state = newStatus;
}

// final widgetRoomItem = StateProvider.autoDispose<Widget>(

// );

// search ruangan provider
final heightContainerProvider = StateProvider.family.autoDispose<double, int>(
  (ref, index) => 175,
);

setNewHeight(WidgetRef ref, int index, double newStatus) {
  ref.read(heightContainerProvider(index).notifier).state = newStatus;
}

final indexSearchProvider = StateProvider.autoDispose<int?>(
  (ref) => null,
);

setIndexSearch(WidgetRef ref, int? idRuangan) {
  ref.read(indexSearchProvider.notifier).state = idRuangan;
}
