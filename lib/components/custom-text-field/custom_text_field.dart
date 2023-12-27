import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueSetter<String>? onChanged;
  const CustomTextField({super.key, this.controller, this.onChanged,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.3)),
          ),
          filled: true,
          fillColor: Colors.deepPurple.withOpacity(0.1),
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
