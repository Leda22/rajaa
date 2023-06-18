import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:test01/screens/check_in.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey _gLobalkey = GlobalKey();
  QRViewController? controller;
  Barcode? result;
  void qr(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        verifyData();
      });
    });
  }

  void verifyData() async {
    String collectionName = 'students';
    String documentId = result?.code ?? '';

    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection(collectionName).doc(documentId);

      DocumentSnapshot snapshot = await docRef.get();

      // Perform your verification logic here based on the value of documentExists
      if (snapshot.exists) {
        // Document exists in the collection
        print('Document exists');

        // Add the document to the collection
        await docRef.update({
          'verification': 'present',
        });

        print('value added');
      } else {
        // Document does not exist in the collection
        print('Document does not exist');
      }
    } catch (e) {
      print('Error verifying document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 400,
              width: 400,
              child: QRView(key: _gLobalkey, onQRViewCreated: qr),
            ),
            Center(child: (result != null) ? Text('${result!.code}') : Text(''))
          ],
        ),
      ),
    );
  }
}
