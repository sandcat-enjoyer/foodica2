import 'package:foodica/pages/productdetail.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:foodica/pages/productdetail.dart';

class ScannerWidget extends StatelessWidget {
  bool codeBeingProcessed = true;

  @override
  Widget build(BuildContext context) {
    if (codeBeingProcessed == true) {
      return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(
          allowDuplicates: false,
          controller: MobileScannerController(
            facing: CameraFacing.back, torchEnabled: true),
          onDetect: (barcode, args) {
            final String code = barcode.rawValue;
            debugPrint(code);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DetailPage()));
          }),
    );
    }
    else {
      
    }
    
  }
}

  