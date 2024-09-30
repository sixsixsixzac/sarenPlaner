import 'package:sarenplaner/Config/URI.dart';
import 'package:sarenplaner/Functions/HexColor.dart';
import 'package:sarenplaner/Functions/Navigate.dart';
import 'package:sarenplaner/screens/home/home.dart';
import 'package:sarenplaner/screens/order/CartProvider.dart';
import 'package:sarenplaner/screens/order/cart.dart';
import 'package:sarenplaner/screens/order/orderDetail.dart';
import 'package:sarenplaner/services/fetch.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> selectedFlavors = [];
  List<Map<String, dynamic>> cakeList = [];
  bool isLoading = false;
  bool isMounted = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isMounted = true;
    });
    fetch();
  }

  Future<void> fetch() async {
    setState(() {
      isLoading = true;
    });
    await getCakes();
  }

  Future<void> getCakes() async {
    if (!isMounted) return;
    String apiUrl = '$SystemURI/getCakes';
    // String filter = (selectedFlavors.isNotEmpty) ? selectedFlavors.join(',') : "all";
    try {
      Map<String, dynamic> requestData = {'filter': (selectedFlavors.isEmpty ? "all" : selectedFlavors), 'searchTerm': _searchController.text};
      final cakes = await fetchData(apiUrl, requestData);
      setState(() {
        cakeList = List<Map<String, dynamic>>.from(cakes);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        if (!isMounted) return;
        isLoading = false;
      });
    }
  }

  void _showFlavorSelectionModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FlavorSelectionModal(
          initialSelections: selectedFlavors,
          onConfirm: (List<String> flavors) {
            setState(() {
              selectedFlavors = flavors;
              fetch();
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: HexColor('#f5f6fd'),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          navigateTo(context: context, toPage: const HomePage(), replace: true);
                        },
                        child: Row(
                          children: [
                            FaIcon(
                              // ignore: deprecated_member_use
                              FontAwesomeIcons.homeAlt,
                              size: 24,
                              color: HexColor('#0067db'),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "ย้อนกลับ",
                              style: TextStyle(
                                fontFamily: 'thaifont',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: HexColor('#0067db'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const cartPage())),
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: FaIcon(
                                FontAwesomeIcons.cartShopping,
                                size: 24,
                                color: HexColor('#0067db'),
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
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      onEditingComplete: () => fetch,
                      onFieldSubmitted: (value) => fetch,
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                        fetch();
                      },
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "ค้นหาสินค้า",
                        filled: true,
                        fillColor: HexColor('#ffffff'),
                        prefixIcon: Icon(
                          Icons.search,
                          color: HexColor('#b6babe'),
                        ),
                        suffixIcon: Stack(
                          alignment: Alignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.filter_list,
                                color: HexColor('#b6babe'),
                              ),
                              onPressed: () => _showFlavorSelectionModal(),
                            ),
                            if (selectedFlavors.isNotEmpty)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '${selectedFlavors.length}',
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: (constraints.maxWidth / 2) / ((constraints.maxWidth / 2) * 1.2),
                              ),
                              itemCount: cakeList.length,
                              itemBuilder: (context, index) {
                                final cake = cakeList[index];
                                return GestureDetector(
                                  onTap: () {
                                    navigateTo(context: context, toPage: orderDetail(cake: cake));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 6,
                                          child: Center(
                                            child: Image.asset(
                                              'assets/Cakes/${cake['prdpic']}',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: Container(
                                            padding: const EdgeInsets.only(bottom: 5),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Flexible(
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      cake['prddesc'],
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      cake['prdtype'],
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            '\฿${cake['prdprice']}',
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.all(4),
                                                        decoration: BoxDecoration(
                                                          color: HexColor('#53b175'),
                                                          borderRadius: BorderRadius.circular(4),
                                                        ),
                                                        child: const Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}

class FlavorSelectionModal extends StatefulWidget {
  final Function(List<String>) onConfirm;
  final List<String> initialSelections;
  const FlavorSelectionModal({super.key, required this.onConfirm, required this.initialSelections});

  @override
  _FlavorSelectionModalState createState() => _FlavorSelectionModalState();
}

class _FlavorSelectionModalState extends State<FlavorSelectionModal> {
  late Map<String, bool> flavorSelections;

  @override
  void initState() {
    super.initState();
    flavorSelections = {
      'วนิลา': false,
      'กาแฟ': false,
      'ใบเตย': false,
      'คุ๊กกี้': false,
    };

    for (var flavor in widget.initialSelections) {
      flavorSelections[flavor] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'ตัวกรองการค้นหา',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            for (String flavor in flavorSelections.keys)
              CheckboxListTile(
                activeColor: Colors.green,
                title: Text(flavor),
                value: flavorSelections[flavor],
                onChanged: (bool? value) {
                  setState(() {
                    flavorSelections[flavor] = value!;
                  });
                },
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text(
                    'ยกเลิก',
                    style: const TextStyle(color: Colors.grey, fontFamily: 'thaifont', fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () async {
                    List<String> selectedFlavors = flavorSelections.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
                    widget.onConfirm(selectedFlavors);

                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'ค้นหา',
                    style: TextStyle(color: Colors.white, fontFamily: 'thaifont', fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
