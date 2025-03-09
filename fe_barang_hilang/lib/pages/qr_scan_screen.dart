 import 'package:flutter/material.dart';
    import 'package:qr_code_scanner/qr_code_scanner.dart';
    import '../services/api_service.dart';
    import 'package:flutter_dotenv/flutter_dotenv.dart';

    class QrScanScreen extends StatefulWidget {
      @override
      _QrScanScreenState createState() => _QrScanScreenState();
    }

    class _QrScanScreenState extends State<QrScanScreen> {
      final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
      QRViewController? controller;
      String? qrText;
      ApiService? apiService;

      @override
      void initState() {
        super.initState();
        apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? '');
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('QR Scan')),
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: (qrText != null)
                      ? Text('Scanned Code: $qrText')
                      : Text('Scan a code!'),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (qrText != null) {
                    // Kirim data ke backend
                    final data = {
                      'found_item_id': qrText, // Pastikan ini adalah ID yang benar
                    };

                    try {
                      dynamic response = await apiService?.post('qr-codes/$qrText/scan', data);

                      if (response != null) {
                        // Berhasil
                        print('QR Code scanned successfully!');
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('QR Code scanned successfully!'))
                        );
                      } else {
                        // Gagal
                        print('Failed to scan QR code.');
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to scan QR code.'))
                        );
                      }
                    } catch (e) {
                      print('Error scanning QR code: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error scanning QR code: $e'))
                      );
                    }
                  }
                },
                child: Text('Submit QR Code'),
              ),
            ],
          ),
        );
      }

      void _onQRViewCreated(QRViewController controller) {
        this.controller = controller;
        controller.scannedDataStream.listen((scanData) {
          setState(() {
            qrText = scanData.code;
          });
        });
      }

      @override
      void dispose() {
        controller?.dispose();
        super.dispose();
      }
    }