import 'package:flutter/material.dart';
import 'package:all_pnud/constantes/appColors.dart';

class SelectInput extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? value;
  final Function(String?) onChanged;
  final IconData? icon; // <- Icône optionnelle

  const SelectInput({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.arrow_drop_down, color:AppColors.vert), // Flèche personnalisée
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color:AppColors.vert) : null, // Icône ajoutée
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color:AppColors.vert, width: 2),
        ),
      ),
      validator: (v) => v == null || v.isEmpty ? "Champ requis" : null,
      items: options.map((opt) {
        return DropdownMenuItem<String>(
          value: opt,
          child: Text(opt),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}