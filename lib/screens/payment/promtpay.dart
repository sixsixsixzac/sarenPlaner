import 'dart:io';
import 'dart:typed_data';
import 'package:sarenplaner/Functions/HexColor.dart';
import 'package:sarenplaner/Functions/formater.dart';
import 'package:sarenplaner/screens/payment/uploader.dart';
import 'package:sarenplaner/services/thaiQr.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class Promptpay extends StatefulWidget {
  final double amount;

  const Promptpay({super.key, required this.amount});

  @override
  State<Promptpay> createState() => _PromptpayState();
}

class _PromptpayState extends State<Promptpay> {
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var storageStatus = await Permission.storage.request();
      var photosStatus = await Permission.photos.request();
      var manageExternalStatus = await Permission.manageExternalStorage.request();
      if (storageStatus.isPermanentlyDenied || photosStatus.isPermanentlyDenied || manageExternalStatus.isPermanentlyDenied) {
        openAppSettings();
        return false;
      }
      return storageStatus.isGranted && photosStatus.isGranted && manageExternalStatus.isGranted;
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.photos,
      ].request();
      return statuses[Permission.storage]!.isGranted && statuses[Permission.photos]!.isGranted;
    }
  }

  Future<void> _saveQrCode() async {
    try {
      bool hasPermission = await requestStoragePermission();
      if (hasPermission) {
        // Generate QR code URL
        String qrCodeUrl = "https://promptpay.io/0828523268/${widget.amount}";
        // Download the image
        final response = await http.get(Uri.parse(qrCodeUrl));
        // Save to gallery
        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.bodyBytes),
          quality: 100,
          name: "QR_Code_${DateTime.now().millisecondsSinceEpoch}",
        );
        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('บันทึก QR Code ลงในแกลเลอรี่แล้ว')),
          );
        } else {
          throw Exception('ไม่สามารถบันทึกรูปภาพลงในแกลเลอรี่ได้');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: HexColor("#dd2529"), content: const Text('การอนุญาตถูกปฏิเสธ')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#ffffff'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      color: HexColor('#113566'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/img/promtpay.png',
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 250,
                child: Column(
                  children: [
                    payQr(amount: widget.amount),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.62,
                      color: HexColor('#d1d1d1'),
                      height: 25,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "THB ${formatPrice(widget.amount)}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: 'thaifont', fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 2, color: Colors.deepOrange),
                              borderRadius: BorderRadius.circular(5),
                            )),
                        onPressed: _saveQrCode,
                        child: const Text(
                          "บันทึก QR-Code",
                          style: TextStyle(fontFamily: 'thaifont', color: Colors.deepOrange),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: Colors.grey[300],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Image.asset(
                  'assets/img/howtopay.png',
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: Colors.grey[300],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => ImageUploadPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text(
                    "ถัดไป",
                    style: TextStyle(fontFamily: 'thaifont', color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
