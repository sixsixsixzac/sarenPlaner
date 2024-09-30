import 'package:auto_size_text/auto_size_text.dart';
import 'package:sarenplaner/Functions/HexColor.dart';
import 'package:sarenplaner/Functions/Navigate.dart';
import 'package:sarenplaner/Functions/formater.dart';
import 'package:sarenplaner/screens/order/CartProvider.dart';
import 'package:sarenplaner/screens/payment/promtpay.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class cartPage extends StatefulWidget {
  const cartPage({super.key});

  @override
  State<cartPage> createState() => _cartPageState();
}

class _cartPageState extends State<cartPage> {
  double TotalPrice = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: HexColor('#ffffff'),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          size: 24,
                          color: HexColor('#0867db'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "ตะกร้า(${cartProvider.cartProducts.length})",
                          style: TextStyle(
                            fontFamily: 'thaifont',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: HexColor('#0867db'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: (cartProvider.cartProducts.isEmpty)
                      ? Center(
                          child: Image.asset('assets/img/empty-cart.png'),
                        )
                      : ListView.builder(
                          itemCount: cartProvider.cartProducts.length,
                          itemBuilder: (context, index) {
                            final item = cartProvider.cartProducts[index];
                            return Productitem(
                              key: ValueKey(item['name']),
                              imagePath: item['img'],
                              price: item['price'],
                              name: item['name'],
                              quantity: item['quantity'],
                              onQuantityChanged: (newQuantity) => cartProvider.updateQuantity(index, newQuantity),
                            );
                          },
                        ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          color: HexColor("#0867db"),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 10,
              offset: Offset(0, 0),
            ),
          ],
        ),
        height: 75,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          margin: EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Row(
            children: [
              Expanded(
                child: AutoSizeText(
                  '฿${formatPrice(cartProvider.totalPrice)}',
                  maxLines: 1,
                  minFontSize: 24,
                  maxFontSize: 30,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'thaifont', fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              (cartProvider.cartProducts.isEmpty)
                  ? const SizedBox.shrink()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      onPressed: () => navigateTo(
                          context: context,
                          toPage: Promptpay(
                            amount: cartProvider.totalPrice,
                          )),
                      child: AutoSizeText(
                        "สั่งซื้อ",
                        maxLines: 1,
                        minFontSize: 24,
                        maxFontSize: 30,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'thaifont', fontWeight: FontWeight.bold, color: HexColor('#0067db')),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class Productitem extends StatelessWidget {
  final String imagePath;
  final double price;
  final String name;
  final int quantity;
  final Function(int) onQuantityChanged;

  const Productitem({
    Key? key,
    required this.imagePath,
    required this.price,
    required this.name,
    required this.quantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalPrice = price * quantity;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Image.asset(
                    imagePath,
                    height: 100,
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      "฿${formatPrice(totalPrice)}",
                                      maxLines: 1,
                                      minFontSize: 18,
                                      maxFontSize: 20,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: HexColor('#0067db'),
                                        fontFamily: "thaifont",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      name,
                                      maxLines: 1,
                                      minFontSize: 18,
                                      maxFontSize: 20,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: HexColor('#1f1f1f'),
                                        fontFamily: "thaifont",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: QuantitySelector(
                            quantity: quantity,
                            onChanged: (newQuantity) {
                              if (newQuantity >= 0) {
                                onQuantityChanged(newQuantity);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[200],
          )
        ],
      ),
    );
  }
}

class QuantitySelector extends StatefulWidget {
  final int quantity;
  final Function(int) onChanged;

  const QuantitySelector({
    Key? key,
    required this.quantity,
    required this.onChanged,
  }) : super(key: key);

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  Timer? _timer;
  static const Duration _initialDelay = Duration(milliseconds: 300);
  int _changeRate = 1;
  int _changeCount = 0;

  void _startChanging(bool increment) {
    _timer = Timer(_initialDelay, () {
      _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
        _changeCount++;
        if (_changeCount % 10 == 0) {
          _changeRate = _changeRate * 2;
        }
        int newQuantity = increment ? widget.quantity + _changeRate : widget.quantity - _changeRate;
        newQuantity = newQuantity.clamp(1, double.infinity).toInt();
        widget.onChanged(newQuantity);

        if (!increment && newQuantity == 1) {
          _stopChanging();
        }
      });
    });
  }

  void _stopChanging() {
    _timer?.cancel();
    _timer = null;
    _changeRate = 1;
    _changeCount = 0;
  }

  @override
  void dispose() {
    _stopChanging();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTrash = widget.quantity == 1;
    final decrementColor = isTrash ? Colors.red : Colors.blue;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(isTrash ? Icons.delete : Icons.remove, () => widget.onChanged(widget.quantity - 1), false, Colors.transparent, decrementColor, decrementColor),
          SizedBox(
            child: Text(
              '${widget.quantity}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontFamily: 'thaifont'),
            ),
          ),
          _buildButton(Icons.add, () => widget.onChanged(widget.quantity + 1), true, Colors.blue, Colors.blue, Colors.white),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap, bool increment, Color bgColor, Color bordColor, Color iconColor) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: (_) => _startChanging(increment),
      onLongPressEnd: (_) => _stopChanging(),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
          border: Border.all(width: 1, color: bordColor),
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}
