import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginStatusProvider = StateProvider.autoDispose(
  (ref) => '',
);

setLoginStatus(WidgetRef ref, String newStatus) {
  ref.read(loginStatusProvider.notifier).state = newStatus;
}
