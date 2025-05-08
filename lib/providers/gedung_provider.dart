import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/models/gedung_model.dart';

final gedungStatusProvider = StateProvider.autoDispose(
  (ref) => '',
);

setGedungStatus(WidgetRef ref, String newStatus) {
  ref.read(gedungStatusProvider.notifier).state = newStatus;
}

final gedungProvider =
    StateNotifierProvider.autoDispose<GedungList, List<GedungModel>>(
  (ref) => GedungList([]),
);

class GedungList extends StateNotifier<List<GedungModel>> {
  GedungList(super.state);

  setData(List<GedungModel> newData) {
    state = newData;
  }
}
