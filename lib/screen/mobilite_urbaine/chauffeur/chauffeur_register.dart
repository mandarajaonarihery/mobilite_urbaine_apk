// lib/screen/chauffeur/chauffeur_register.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:all_pnud/services/chauffeur_service.dart';
import 'package:all_pnud/providers/auth_provider.dart';
import 'package:all_pnud/models/chauffeur.dart';
import 'package:go_router/go_router.dart';

class ChauffeurRegisterScreen extends StatefulWidget {
  const ChauffeurRegisterScreen({Key? key}) : super(key: key);

  @override
  State<ChauffeurRegisterScreen> createState() => _ChauffeurRegisterScreenState();
}

class _ChauffeurRegisterScreenState extends State<ChauffeurRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _permisController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? _permisImage;
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _permisImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final citizenId = authProvider.decodedToken?['id_citizen'];
      final municipalityId = authProvider.decodedToken?['municipality_id'];
      final token = authProvider.token;

      if (citizenId == null || municipalityId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur: informations utilisateur manquantes")),
        );
        setState(() => _loading = false);
        return;
      }

      final chauffeurService = ChauffeurService();
      final chauffeur = await chauffeurService.createChauffeur(
        numPhone: _phoneController.text,
        email: _emailController.text,
        municipalityId: municipalityId.toString(),
        citizenId: citizenId.toString(),
        numPermis: _permisController.text,
        categoriePermis: _categorieController.text,
        permisImage: _permisImage,
        token: token,
      );

      setState(() => _loading = false);

      if (chauffeur != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Chauffeur enregistré avec succès")),
        );

        // Rediriger vers le dashboard
        context.goNamed("chauffeur_dashboard", extra: {"chauffeur": chauffeur});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Erreur lors de l'enregistrement")),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enregistrement Chauffeur"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Numéro de téléphone *",
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Obligatoire" : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email *",
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Obligatoire" : null,
                    ),
                    TextFormField(
                      controller: _permisController,
                      decoration: const InputDecoration(
                        labelText: "Numéro du permis",
                      ),
                    ),
                    TextFormField(
                      controller: _categorieController,
                      decoration: const InputDecoration(
                        labelText: "Catégorie du permis",
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.image),
                          label: const Text("Choisir permis"),
                        ),
                        const SizedBox(width: 12),
                        if (_permisImage != null)
                          Expanded(
                            child: Text(
                              _permisImage!.path.split("/").last,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Enregistrer"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
