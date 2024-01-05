import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

const List<String> scopes = <String>[
  'profile',
  'email',
  'https://www.googleapis.com/auth/drive',
];

class GoogleSignInHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopes,
  );

  DriveApi? driveApi;

  Future<void> handleSignIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        final authenticatedClient =
            await _googleSignIn.authenticatedClient() as dynamic;
        driveApi = DriveApi(authenticatedClient);
      }
    } catch (error) {
      print(error);
    }
  }

  void handleOnCurrentUserChanged(
      void Function(GoogleSignInAccount? accountData) callback) {
    _googleSignIn.signInSilently();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      callback(account);
    });
  }

  Future<void> handleSignOut() => _googleSignIn.disconnect();
}
