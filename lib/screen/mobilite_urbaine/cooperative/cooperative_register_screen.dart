import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;

import 'package:all_pnud/providers/auth_provider.dart';
import 'package:all_pnud/services/cooperative_service.dart';

class CooperativeRegisterScreen extends StatefulWidget {
  const CooperativeRegisterScreen({Key? key}) : super(key: key);

  @override
  State<CooperativeRegisterScreen> createState() =>
      _CooperativeRegisterScreenState();
}

class _CooperativeRegisterScreenState extends State<CooperativeRegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  int _currentStep = 0;
  final int _totalSteps = 3;

  // Controllers
  final _nameController = TextEditingController();
  final _siegeController = TextEditingController();
  final _sloganController = TextEditingController();
  final _nifController = TextEditingController();
  final _stateController = TextEditingController();
  final _cnapsController = TextEditingController();
  final _droitAdhesionController = TextEditingController();

  // Services
  final CooperativeService _registrationService = CooperativeService();
  final TransportTypeService _transportTypeService = TransportTypeService();

  // État
  bool _isLoading = false;
  DateTime? _dateCreation;
  int? _selectedTypeTransportId;
  List<TransportType> _transportTypes = [];

  // Fichiers
  XFile? _regleInterneFile;
  XFile? _patenteFile;
  XFile? _accordMinFile;

  @override
  void initState() {
    super.initState();
    _loadTransportTypes();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  Future<void> _loadTransportTypes() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final municipalityId =
        int.parse(authProvider.decodedToken?['municipality_id'] ?? '0');

    if (municipalityId == 0) return;

    final types = await _transportTypeService
        .getTransportTypesByMunicipality(municipalityId);
    setState(() => _transportTypes = types);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _siegeController.dispose();
    _sloganController.dispose();
    _nifController.dispose();
    _stateController.dispose();
    _cnapsController.dispose();
    _droitAdhesionController.dispose();
    super.dispose();
  }

  // Fonctions de sélection des fichiers
  Future<void> _pickRegleInterne() async {
    final XFile? file = await openFile(
      acceptedTypeGroups: [XTypeGroup(label: 'PDF', extensions: ['pdf'])],
    );
    if (file != null) setState(() => _regleInterneFile = file);
  }

  Future<void> _pickPatente() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _patenteFile = image);
  }

  Future<void> _pickAccordMin() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _accordMinFile = image);
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _registerCooperative() async {
    if (!_formKey.currentState!.validate()) return;

    // Validation des fichiers
    if (_regleInterneFile == null) {
      _showSnackBar("Veuillez choisir le fichier de règle interne (PDF).", Colors.orange);
      return;
    }
    if (_patenteFile == null) {
      _showSnackBar("Veuillez choisir le fichier de la patente.", Colors.orange);
      return;
    }
    if (_accordMinFile == null) {
      _showSnackBar("Veuillez choisir le fichier de l'accord ministériel.", Colors.orange);
      return;
    }
    
    if (_selectedTypeTransportId == null || _dateCreation == null) {
      _showSnackBar("Veuillez remplir tous les champs obligatoires.", Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final citizenId = authProvider.decodedToken?['id_citizen'];
    final municipalityId = int.parse(authProvider.decodedToken?['municipality_id'] ?? '0');

    if (citizenId == null || municipalityId == 0) {
      if (mounted) context.goNamed('dashboard');
      return;
    }

    final success = await _registrationService.registerCooperative(
      name: _nameController.text,
      siege: _siegeController.text,
      slogan: _sloganController.text,
      citizenId: citizenId,
      typeTransportId: _selectedTypeTransportId!,
      municipalityId: municipalityId,
      nif: _nifController.text,
      state: _stateController.text,
      numCnaps: _cnapsController.text,
      dateCreation: _dateCreation!.toIso8601String().split("T").first,
      droitAdhesion: double.parse(_droitAdhesionController.text),
      regleInterneFile: _regleInterneFile,
      patenteFile: _patenteFile,
      accordMinFile: _accordMinFile,
    );

    if (mounted) {
      setState(() => _isLoading = false);
     if (success) {
  _showSnackBar('Inscription réussie!', const Color(0xFF00C21C));

  // Exemple si tu veux passer des données (optionnel)
  final cooperativeData = {
    'date_descente': null, // ou la vraie date
    'nom': _nameController.text,
  };

  context.goNamed(
    'cooperative_pending',
    extra: cooperativeData,
  );
}
 else {
        _showSnackBar("Échec de l'inscription. Veuillez réessayer.", Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == const Color(0xFF00C21C) ? Icons.check_circle : Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF030712),
        title: const Text(
          'Inscription Coopérative',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Indicateur de progression
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: List.generate(_totalSteps, (index) {
                  final isActive = index <= _currentStep;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index < _totalSteps - 1 ? 8 : 0),
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: isActive 
                          ? const Color(0xFF00C21C)
                          : const Color(0xFF131313).withOpacity(0.2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            
            // Titre de l'étape
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                _getStepTitle(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF030712),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Sous-titre
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _getStepSubtitle(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF131313),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Contenu du formulaire
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF030712).withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentStep = index),
                    children: [
                      _buildBasicInfoStep(),
                      _buildDetailsStep(),
                      _buildDocumentsStep(),
                    ],
                  ),
                ),
              ),
            ),
            
            // Boutons de navigation
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF00C21C),
                          side: const BorderSide(color: Color(0xFF00C21C), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Précédent',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  
                  if (_currentStep > 0) const SizedBox(width: 16),
                  
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : (_currentStep < _totalSteps - 1 ? _nextStep : _registerCooperative),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C21C),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: const Color(0xFF00C21C).withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              _currentStep < _totalSteps - 1 ? 'Suivant' : 'Créer ma coopérative',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0: return 'Informations générales';
      case 1: return 'Détails administratifs';
      case 2: return 'Documents requis';
      default: return '';
    }
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0: return 'Renseignez les informations de base de votre coopérative';
      case 1: return 'Complétez les détails administratifs et financiers';
      case 2: return 'Joignez les documents officiels requis';
      default: return '';
    }
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildModernTextField(
            controller: _nameController,
            label: 'Nom de la coopérative',
            icon: Icons.business_rounded,
            validator: (v) => (v == null || v.isEmpty) ? 'Veuillez entrer le nom' : null,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: _siegeController,
            label: 'Siège de la coopérative',
            icon: Icons.location_on_rounded,
            validator: (v) => (v == null || v.isEmpty) ? 'Veuillez entrer le siège' : null,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: _sloganController,
            label: 'Slogan',
            icon: Icons.format_quote_rounded,
            validator: (v) => (v == null || v.isEmpty) ? 'Veuillez entrer un slogan' : null,
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          _buildTransportTypeDropdown(),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildModernTextField(
            controller: _nifController,
            label: 'Numéro NIF',
            icon: Icons.numbers_rounded,
            validator: (v) => (v == null || v.isEmpty) ? 'Veuillez entrer le NIF' : null,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: _cnapsController,
            label: 'Numéro CNAPS',
            icon: Icons.assignment_rounded,
            validator: (v) => (v == null || v.isEmpty) ? 'Veuillez entrer le CNAPS' : null,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: _stateController,
            label: 'Numéro state',
            icon: Icons.assignment_rounded,
            validator: (v) => (v == null || v.isEmpty) ? 'Veuillez entrer le numeros statistiques' : null,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: _droitAdhesionController,
            label: 'Droit d\'adhésion (Ar)',
            icon: Icons.payments_rounded,
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Veuillez entrer le droit d\'adhésion';
              if (double.tryParse(v) == null) return 'Veuillez entrer un nombre valide';
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildDatePicker(),
        ],
      ),
    );
  }

  Widget _buildDocumentsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildFilePickerCard(
            title: 'Règle interne',
            subtitle: 'Fichier PDF requis',
            icon: Icons.description_rounded,
            file: _regleInterneFile,
            onTap: _pickRegleInterne,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildFilePickerCard(
            title: 'Patente',
            subtitle: 'Image de la patente',
            icon: Icons.image_rounded,
            file: _patenteFile,
            onTap: _pickPatente,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildFilePickerCard(
            title: 'Accord ministériel',
            subtitle: 'Image de l\'accord',
            icon: Icons.verified_rounded,
            file: _accordMinFile,
            onTap: _pickAccordMin,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Color(0xFF030712)),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF00C21C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF00C21C),
            size: 20,
          ),
        ),
        labelStyle: const TextStyle(color: Color(0xFF131313)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFF131313).withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFF131313).withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF00C21C), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildTransportTypeDropdown() {
    return DropdownButtonFormField<int>(
      value: _selectedTypeTransportId,
      validator: (v) => v == null ? "Veuillez choisir un type de transport" : null,
      decoration: InputDecoration(
        labelText: "Type de transport",
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF00C21C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.directions_bus_rounded,
            color: Color(0xFF00C21C),
            size: 20,
          ),
        ),
        labelStyle: const TextStyle(color: Color(0xFF131313)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFF131313).withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFF131313).withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF00C21C), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: _transportTypes
          .map((type) => DropdownMenuItem(
                value: type.id,
                child: Text(type.name),
              ))
          .toList(),
      onChanged: (v) => setState(() => _selectedTypeTransportId = v),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) setState(() => _dateCreation = picked);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF131313).withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF00C21C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                color: Color(0xFF00C21C),
                size: 20,
              ),
            ),
            Expanded(
              child: Text(
                _dateCreation == null
                    ? "Date de création"
                    : "${_dateCreation!.toIso8601String().split("T").first}",
                style: TextStyle(
                  fontSize: 16,
                  color: _dateCreation == null 
                    ? const Color(0xFF131313).withOpacity(0.6)
                    : const Color(0xFF030712),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF131313),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePickerCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required XFile? file,
    required VoidCallback onTap,
    required Color color,
  }) {
    final hasFile = file != null;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: hasFile ? color.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasFile ? color : const Color(0xFF131313).withOpacity(0.2),
            width: hasFile ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: hasFile ? color : const Color(0xFF131313).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                hasFile ? Icons.check_circle_rounded : icon,
                color: hasFile ? Colors.white : const Color(0xFF131313).withOpacity(0.6),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: hasFile ? color : const Color(0xFF030712),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasFile ? file.name : subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: hasFile ? color.withOpacity(0.8) : const Color(0xFF131313).withOpacity(0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              hasFile ? Icons.edit_rounded : Icons.upload_rounded,
              color: hasFile ? color : const Color(0xFF131313).withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
}