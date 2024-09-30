import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sarenplaner/Config/URI.dart';
import 'dart:io';
import 'package:sarenplaner/Functions/HexColor.dart';
import 'package:sarenplaner/Functions/Toast.dart';
import 'package:sarenplaner/screens/order/CartProvider.dart';
import 'package:sarenplaner/screens/order/orderHistory.dart';
import 'package:sarenplaner/services/fetch.dart';
import 'package:sarenplaner/services/userProvider.dart';

class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({super.key});

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> uploadImage() async {
    if (_image == null) return;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cartItems = cartProvider.cartProducts;
    final bytes = await _image!.readAsBytes();
    final base64Image = base64Encode(bytes);

    final url = '$SystemURI/uploadSlip';
    final bodyData = {
      'userId': userProvider.userId,
      'image': base64Image,
      'filename': _image!.path.split('/').last,
      'cartItems': cartItems,
      'totalPrice': cartProvider.totalPrice,
    };

    try {
      final result = await post(url, bodyData);

      if (result['status'] == true) {
        cartProvider.clearCart();
        showToast(
          context,
          result['text'],
          icon: Icons.check,
          onClose: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Orderhistory()),
            );
          },
        );
      } else {
        print('Image upload failed: ${result['message']}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#223dfe"),
        title: const Center(
            child: Text(
          'อัพโหลดหลักฐานการชำระเงิน',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),
            Center(
              child: GestureDetector(
                onTap: getImage,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      width: 300,
                      height: 500,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(_image == null ? 50.0 : 10.0),
                          child: _image == null
                              ? Image.asset(
                                  'assets/img/uploader.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    CustomPaint(
                      painter: DottedBorderPainter(
                        color: const Color.fromARGB(255, 182, 182, 182),
                        strokeWidth: 1.0,
                        gap: 5.0,
                      ),
                      child: Container(
                        width: 300,
                        height: 500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("แตะเพื่อเลือกรูปหลักฐาน"),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            _image == null
                ? const SizedBox.shrink()
                : ElevatedButton(
                    onPressed: uploadImage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      backgroundColor: HexColor('#223dfe'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'ส่งหลักฐาน',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DottedBorderPainter({
    this.color = const Color.fromARGB(255, 182, 182, 182),
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    for (double i = 0; i < size.width; i += gap * 2) {
      path.moveTo(i, 0);
      path.lineTo(i + gap, 0);
    }
    for (double i = 0; i < size.height; i += gap * 2) {
      path.moveTo(size.width, i);
      path.lineTo(size.width, i + gap);
    }
    for (double i = size.width; i > 0; i -= gap * 2) {
      path.moveTo(i, size.height);
      path.lineTo(i - gap, size.height);
    }
    for (double i = size.height; i > 0; i -= gap * 2) {
      path.moveTo(0, i);
      path.lineTo(0, i - gap);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
