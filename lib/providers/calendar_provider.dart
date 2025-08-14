import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipinjam/models/gedung_model.dart';
import 'package:sipinjam/models/ruangan_model.dart';

final gedungCalendarProvider = StateProvider.autoDispose<GedungModel?>(
  (ref) => null,
);

setGedungCalendar(WidgetRef ref, GedungModel? gedung) {
  ref.read(gedungCalendarProvider.notifier).state = gedung;
}

final ruanganCalendarProvider = StateProvider.autoDispose<RuanganModel?>(
  (ref) => null,
);

setRuanganCalendar(WidgetRef ref, RuanganModel? ruangan) {
  ref.read(ruanganCalendarProvider.notifier).state = ruangan;
}
