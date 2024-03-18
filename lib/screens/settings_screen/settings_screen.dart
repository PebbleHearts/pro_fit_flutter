import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pro_fit_flutter/components/custom_elevated_button/custom_elevated_button.dart';
import 'package:pro_fit_flutter/constants/google.dart';
import 'package:pro_fit_flutter/constants/theme.dart';
import 'package:pro_fit_flutter/screens/settings_screen/cta_item.dart';
import 'package:pro_fit_flutter/screens/settings_screen/profile_card.dart';
import 'package:pro_fit_flutter/states/user_state.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool isUploading = false;
  bool isImporting = false;

  void _handleGoogleSignIn() {
    signInHelper.handleSignIn();
  }

  void _handleSignOut() {
    signInHelper.handleSignOut();
  }

  void _startUpload() async {
    setState(() {
      isUploading = true;
    });
    await dataBackupService.upload();
        setState(() {
      isUploading = false;
    });
  }

  void _startImport() async {
    setState(() {
      isImporting = true;
    });
    await dataBackupService.import();
        setState(() {
      isImporting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = ref.watch(userNotifierProvider);
    final bool isLoggedIn = userDetails != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 70,
            color: purpleTheme.primary,
            width: double.infinity,
            child: const Center(
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: purpleTheme.primary,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          height: 400,
                          width: 100,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: purpleTheme.background,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (isLoggedIn)
                                Column(
                                  children: [
                                    ProfileCard(
                                        name: userDetails.displayName,
                                        email: userDetails.email,
                                        imageUrl: userDetails.photoUrl),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CTAItem(
                                      label: 'Export',
                                      icon: Icons.upload_rounded,
                                      description:
                                          'Save the local data to google drive',
                                      onTap: _startUpload,
                                      isLoading: isUploading,
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    CTAItem(
                                      label: 'Import',
                                      icon: Icons.download_rounded,
                                      description:
                                          'Import data from google drive',
                                      onTap: _startImport,
                                      isLoading: isImporting,
                                    ),
                                  ],
                                ),
                              SizedBox(
                                height: 40,
                                child: CustomElevatedButton(
                                  style: isLoggedIn
                                      ? const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.redAccent),
                                        )
                                      : null,
                                  onPressed: isLoggedIn
                                      ? _handleSignOut
                                      : _handleGoogleSignIn,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.logout),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(isLoggedIn ? 'Log Out' : 'Log In')
                                      ]),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
