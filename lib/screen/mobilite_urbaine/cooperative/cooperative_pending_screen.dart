import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class CooperativePendingScreen extends StatefulWidget {
  final Map<String, dynamic> cooperative;

  const CooperativePendingScreen({Key? key, required this.cooperative}) : super(key: key);

  @override
  State<CooperativePendingScreen> createState() => _CooperativePendingScreenState();
}

class _CooperativePendingScreenState extends State<CooperativePendingScreen> {
  late String message;
  late bool hasDescenteDate;

  @override
  void initState() {
    super.initState();
    _setMessage();
  }

  void _setMessage() {
    final dateDescente = widget.cooperative['date_descente'];
    hasDescenteDate = dateDescente != null;
    
    if (dateDescente == null) {
      message = "Votre dossier est en cours d'analyse par nos administrateurs.";
    } else {
      final date = DateTime.parse(dateDescente);
      message = "${DateFormat('dd MMMM yyyy', 'fr_FR').format(date)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Background colour
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF131313)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Statut Coopérative",
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800, // ExtraBold
            color: const Color(0xFF131313),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Card principale avec statut
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Icône de statut
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: hasDescenteDate 
                            ? const Color(0xFF00C21C).withOpacity(0.1)
                            : const Color(0xFFE8B018).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        hasDescenteDate ? Icons.event_available : Icons.access_time,
                        size: 50,
                        color: hasDescenteDate 
                            ? const Color(0xFF00C21C)
                            : const Color(0xFFE8B018),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Titre principal
                    Text(
                      hasDescenteDate ? "Descente programmée" : "Validation en attente",
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w800, // ExtraBold
                        color: const Color(0xFF131313),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Message/Date
                    if (hasDescenteDate) ...[
                      Text(
                        "Date de descente",
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w400, // Regular
                          color: const Color(0xFF5D5D5D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF098E00).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF098E00),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          message,
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w800, // ExtraBold
                            color: const Color(0xFF098E00),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ] else ...[
                      Text(
                        message,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w400, // Regular
                          color: const Color(0xFF5D5D5D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Card étapes de validation
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Étapes de validation",
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w800, // ExtraBold
                        color: const Color(0xFF131313),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildStepItem(
                      "Dossier reçu",
                      true,
                      isFirst: true,
                    ),
                    _buildStepItem(
                      "Vérification",
                      true,
                    ),
                    _buildStepItem(
                      "Validation admin",
                      hasDescenteDate,
                    ),
                    _buildStepItem(
                      "Notification",
                      false,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Card notification
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF6653E5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF6653E5).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6653E5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.notifications_active,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Vous recevrez une notification dès validation.",
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w400, // Regular
                          color: const Color(0xFF131313),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(String title, bool isCompleted, {bool isFirst = false, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCompleted 
                    ? const Color(0xFF00C21C) 
                    : const Color(0xFFE8B018).withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted 
                      ? const Color(0xFF00C21C)
                      : const Color(0xFFE8B018),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  isCompleted ? Icons.check : Icons.access_time,
                  size: 16,
                  color: isCompleted 
                      ? Colors.white
                      : const Color(0xFFE8B018),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted 
                    ? const Color(0xFF00C21C).withOpacity(0.3)
                    : const Color(0xFFE8B018).withOpacity(0.2),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
                color: isCompleted 
                    ? const Color(0xFF131313)
                    : const Color(0xFF5D5D5D),
              ),
            ),
          ),
        ),
      ],
    );
  }
}