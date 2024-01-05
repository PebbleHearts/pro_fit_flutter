import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_state.g.dart';

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  @override
  GoogleSignInAccount? build() {
    return null;
  }

  void setUserDetails(GoogleSignInAccount? account) {
    state = account;
  }
}