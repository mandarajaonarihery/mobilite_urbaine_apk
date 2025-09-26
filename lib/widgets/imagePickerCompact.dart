import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:all_pnud/constantes/appColors.dart';

class ImagePickerCompact extends StatefulWidget {
  final String label;
  final Function(XFile?) onPicked;

  const ImagePickerCompact({
    super.key,
    required this.label,
    required this.onPicked,
  });

  @override
  State<ImagePickerCompact> createState() => _ImagePickerCompactState();
}

class _ImagePickerCompactState extends State<ImagePickerCompact> {
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery, // 👈 Galerie (peut être remplacé par camera)
      imageQuality: 85, // compression optionnelle
    );

    if (picked != null) {
      setState(() => _image = picked);
      widget.onPicked(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
              color: _image == null
                  ? Colors.transparent
                  : AppColors.vert.withOpacity(0.08),
            ),
            child: Row(
              children: [
                Icon(Icons.image, color: AppColors.vert, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _image != null ? _image!.name : "Choisir une image",
                    style: TextStyle(
                        color: _image == null
                            ? Colors.grey.shade600
                            : Colors.black87,
                        fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down,
                    color: Colors.grey, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}   