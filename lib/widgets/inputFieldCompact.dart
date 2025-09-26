import 'package:flutter/material.dart';
import 'package:all_pnud/constantes/appColors.dart';

class InputFieldCompact extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;

  const InputFieldCompact({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.readOnly = false,
    this.onTap,
  });

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.vert, width: 1.5),
      ),
      prefixIcon: Icon(icon, color: AppColors.vert, size: 18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
        decoration: _buildInputDecoration(),
      ),
    );
  }
}