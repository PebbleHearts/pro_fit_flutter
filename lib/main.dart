import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pro_fit_flutter/constants/google.dart';
import 'package:pro_fit_flutter/firebase_options.dart';
import 'package:pro_fit_flutter/navigators/tab-navigator/tab_navigator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pro_fit_flutter/states/user_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  void _handleCurrentUserChangeCallback(GoogleSignInAccount? accountData) {
    ref.read(userNotifierProvider.notifier).setUserDetails(accountData);
  }

  @override
  void initState() {
    super.initState();
    signInHelper.handleOnCurrentUserChanged(_handleCurrentUserChangeCallback);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ProFit Flutter',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const TabNavigator(),
    );
  }
}
