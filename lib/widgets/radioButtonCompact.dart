import 'package:flutter/material.dart';
import 'package:all_pnud/constantes/appColors.dart';

class RadioButtonCompact extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool value;
  final bool groupValue;
  final ValueChanged<bool?> onChanged;
  final String? Function(bool?)? validator;

  const RadioButtonCompact({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.validator,
  });

  BoxDecoration _buildContainerDecoration(bool isSelected) {
    return BoxDecoration(
      border: Border.all(
        color: isSelected ? AppColors.vert : Colors.grey.shade300,
        width: isSelected ? 1.5 : 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
      color: isSelected ? AppColors.vert.withOpacity(0.1) : Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    
    return SizedBox(
      height: 45,
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: _buildContainerDecoration(isSelected),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(icon, color: AppColors.vert, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.vert : Colors.grey.shade700,
                ),
              ),
              const Spacer(),
              Radio<bool>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: AppColors.vert,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}