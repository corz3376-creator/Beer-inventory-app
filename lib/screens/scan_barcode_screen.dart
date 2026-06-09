import 'package:flutter/material.dart';

class ScanBarcodeScreen extends StatelessWidget {
  const ScanBarcodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        backgroundColor: const Color(0xFF8B4513),
      ),
      body: const Center(
        child: Text('Scan Barcode page'),
      ),
    );
  }
}
