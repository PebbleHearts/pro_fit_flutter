import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget bottomSheetContent;
  const CustomBottomSheet({super.key, required this.bottomSheetContent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: bottomSheetContent,
    );
  }
}
