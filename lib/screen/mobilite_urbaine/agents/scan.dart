import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:all_pnud/constantes/appColors.dart';
import 'package:all_pnud/constantes/api.dart';
import 'package:all_pnud/services/scanService.dart';
import 'scannerResultat.dart';

class ScanPage extends StatefulWidget {
  final String idCitizen;

  const ScanPage({super.key, required this.idCitizen});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    print("✅ id_citizen reçu : ${widget.idCitizen}");
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner un QR Code"),
      ),
      body: Column(
        children: [
          // Zone de scan QR
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: AppColors.vert,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),

          // Instructions pour l'utilisateur
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Placez le QR code dans la zone",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Méthode appelée lorsque le QR scanner est créé
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing) return; // Évite le traitement multiple
      isProcessing = true;

      controller.pauseCamera();

      try {
        final decoded = jsonDecode(scanData.code ?? "{}");

        if (decoded is! Map ||
            !decoded.containsKey("immatriculation") ||
            !decoded.containsKey("municipality_id")) {
          throw Exception("QR code incomplet");
        }

        final String endpoint = Api.vehiculeDocumentation
            .replaceFirst("{immatriculation}", decoded["immatriculation"].toString().trim())
            .replaceFirst("{municipality_id}", decoded["municipality_id"].toString().trim());
        final String fullUrl = "${Api.baseUrl}$endpoint";
        print("🔗 URL finale: $fullUrl");

        // On récupère les données véhicule + agentId
        final scanService = ScanService();
        final result = await scanService.getVehiculeWithCode(
          Map<String, dynamic>.from(decoded),
          idCitizen: widget.idCitizen,
        );

        if (!mounted) return;

        if (result == null || result.containsKey("error")) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result?["error"] ?? "Erreur inconnue")),
          );
          controller.resumeCamera();
        } else {
          final agentId = result['agentId'];
          final vehiculeData = result['vehiculeData'];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ScannerResultat(
                result: vehiculeData,
                agentId: agentId,
              ),
            ),
          );
        }
      } catch (e) {
        print("Erreur parsing QR: $e");
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("QR code invalide")),
        );
        controller.resumeCamera();
      } finally {
        isProcessing = false;
      }
    });
  }
}
