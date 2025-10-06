import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../backend-api/dtos.dart';

final authUserProvider = StateNotifierProvider<AuthUserNotifier, AuthUserRes?>((
  _,
) {
  return AuthUserNotifier();
});

class AuthUserNotifier extends StateNotifier<AuthUserRes?> {
  AuthUserNotifier() : super(null) {
    state = Hive.box("session").get("authUser");
  }

  void set(AuthUserRes authUser) {
    Hive.box("session").put("authUser", authUser);
    state = authUser;
  }

  void destroy() {
    Hive.box("session").delete("authUser");
    state = null;
  }
}
