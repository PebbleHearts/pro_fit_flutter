import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/constants/theme.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final Widget child;
  const CustomElevatedButton({
    super.key,
    this.style,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: style != null && style?.foregroundColor != null
            ? style?.foregroundColor
            : const MaterialStatePropertyAll(Colors.white),
        backgroundColor: style != null && style?.backgroundColor != null
            ? style?.backgroundColor
            : MaterialStatePropertyAll(purpleTheme.primary),
        overlayColor: style != null && style?.overlayColor != null
            ? style?.overlayColor
            : MaterialStatePropertyAll(purpleTheme.primary.withOpacity(0.5)),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))
      ),
      child: child,
    );
  }
}
