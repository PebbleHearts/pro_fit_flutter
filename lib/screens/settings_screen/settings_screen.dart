import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/constants/theme.dart';
import 'package:pro_fit_flutter/screens/settings_screen/cta_item.dart';
import 'package:pro_fit_flutter/screens/settings_screen/profile_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                              Column(
                                children: [
                                  const ProfileCard(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CTAItem(
                                    label: 'Upload',
                                    icon: Icons.upload_rounded,
                                    description:
                                        'Save the local data to google drive',
                                    onTap: () {},
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  CTAItem(
                                    label: 'Download',
                                    icon: Icons.download_rounded,
                                    description:
                                        'Import data from google drive',
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          const MaterialStatePropertyAll(
                                              Colors.white),
                                      backgroundColor: MaterialStatePropertyAll(
                                          purpleTheme.primary),
                                      overlayColor: MaterialStatePropertyAll(
                                          purpleTheme.primary
                                              .withOpacity(0.5))),
                                  onPressed: () {},
                                  child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.logout),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Log Out')
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
