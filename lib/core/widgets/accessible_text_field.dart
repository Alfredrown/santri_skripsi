import 'package:material_ui/material_ui.dart';
import '../constants/app_sizes.dart';
import '../theme/app_text_styles.dart';

/// Accessible form field with explicit visible label and live-region error announcement
/// for Android TalkBack and iOS VoiceOver.
class AccessibleTextField extends StatelessWidget {
  const AccessibleTextField({
    super.key,
    required this.label,
    this.hintText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
  });

  final String label;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
        ),
        const SizedBox(height: AppSizes.p8),
        Semantics(
          textField: true,
          label: label,
          hint: hintText,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            onChanged: onChanged,
            style: AppTextStyles.bodyLarge,
            decoration: InputDecoration(
              hintText: hintText,
              errorText: errorText,
            ),
          ),
        ),
      ],
    );
  }
}
