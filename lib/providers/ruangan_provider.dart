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
