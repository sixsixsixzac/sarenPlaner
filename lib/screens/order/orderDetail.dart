import 'package:auto_size_text/auto_size_text.dart';
import 'package:sarenplaner/Functions/HexColor.dart';
import 'package:sarenplaner/Functions/Navigate.dart';
import 'package:sarenplaner/Functions/Toast.dart';
import 'package:sarenplaner/screens/order/cart.dart';
import 'package:sarenplaner/screens/order/CartProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class orderDetail extends StatefulWidget {
  final Map<String, dynamic> cake;
  const orderDetail({super.key, required this.cake});

  @override
  State<orderDetail> createState() => _orderDetailState();
}

class _orderDetailState extends State<orderDetail> {
  String selectedOption = '1 ปอนด์';
  int qty = 1;

  void addItem(BuildContext context, CartProvider cartProvider, Map<String, dynamic> newItem) {
    Map<String, dynamic> newProduct = {
      'prdcode': newItem['prdcode'],
      'name': newItem['prddesc'],
      'price': double.tryParse(newItem['prdprice'].toString()) ?? 0.0,
      'unit': newItem['prdcate'],
      'quantity': num.tryParse(qty.toString()) ?? 1,
      'img': 'assets/Cakes/' + newItem['prdpic'],
    };
    cartProvider.addProduct(newProduct);

    setState(() {
      showToast(
        context,
        "เพิ่มสินค้าลงตะกร้าแล้ว",
        icon: Icons.check,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showToast(
        context,
        "เพิ่มสินค้าลงตะกร้าแล้ว",
        icon: Icons.check,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: HexColor('#f7f8fa'),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            color: HexColor('#f7f8fa'),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/Cakes/' + widget.cake['prdpic'],
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.6,
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 15,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FaIcon(
                        FontAwesomeIcons.arrowLeft,
                        color: HexColor('#0067db'),
                        size: 24,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 15,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () => navigateTo(context: context, toPage: const cartPage()),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FaIcon(
                            FontAwesomeIcons.cartShopping,
                            size: 24,
                            color: HexColor('#0067db'),
                          ),
                        ),
                      ),
                      if (cartProvider.cartProducts.isNotEmpty)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${cartProvider.cartProducts.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 0),
                  )
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                )),
            child: Container(
              margin: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              widget.cake['prddesc'],
                              maxLines: 1,
                              minFontSize: 32,
                              maxFontSize: 45,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontFamily: 'thaifont', fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              widget.cake['prddesc'],
                              maxLines: 3,
                              minFontSize: 20,
                              maxFontSize: 24,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'thaifont', color: HexColor("#98989e")),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 20),
                      // buildSelectionButtons(),
                      const SizedBox(height: 20),
                      QuantitySelector(
                        onChanged: (value) {
                          setState(() {
                            qty = value;
                          });
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => addItem(context, cartProvider, widget.cake),
                    child: Container(
                      decoration: BoxDecoration(color: HexColor('#53b175'), borderRadius: const BorderRadius.all(Radius.circular(15))),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "เพิ่มลงตะกร้า",
                            style: TextStyle(color: Colors.white, fontFamily: 'thaifont', fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSelectionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['1 ปอนด์', '2 ปอนด์'].map((option) {
        return InkWell(
          onTap: () {
            setState(() {
              selectedOption = option;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: selectedOption == option ? Colors.orange : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.orange),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: selectedOption == option ? Colors.white : Colors.orange,
                fontFamily: 'thaifont',
                fontSize: 16,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class QuantitySelector extends StatefulWidget {
  final Function(int) onChanged;
  final int initialValue;

  const QuantitySelector({
    super.key,
    required this.onChanged,
    this.initialValue = 1,
  });

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialValue;
  }

  void _increment() {
    setState(() {
      quantity++;
      widget.onChanged(quantity);
    });
  }

  void _decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        widget.onChanged(quantity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(Icons.remove, _decrement),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              'จำนวน $quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontFamily: 'thaifont'),
            ),
          ),
          _buildButton(Icons.add, _increment),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: HexColor('#53b175'),
        ),
        child: Icon(icon, size: 20, color: Colors.white),
      ),
    );
  }
}
