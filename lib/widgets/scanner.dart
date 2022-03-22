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
                facing: CameraFacing.back, torchEnabled: false),
            onDetect: (barcode, args) {
              final String code = barcode.rawValue;
              debugPrint(code);
              debugPrint(barcode.rawValue);
              debugPrint(barcode.toString());
              codeBeingProcessed = false;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(barcode: code)));
            }),
      );
    } else {}
  }
}
