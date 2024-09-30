import 'package:flutter/material.dart';

class payQr extends StatelessWidget {
  final double amount;

  payQr({required this.amount});
  genQrcode() {
    String url = "https://promptpay.io/0828523268/${amount}";
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      genQrcode(),
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    );
  }
}
