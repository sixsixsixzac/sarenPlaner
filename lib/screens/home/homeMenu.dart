import 'package:auto_size_text/auto_size_text.dart';
import 'package:sarenplaner/Functions/HexColor.dart';
import 'package:sarenplaner/screens/order/order.dart';
import 'package:flutter/material.dart';
import 'package:sarenplaner/screens/order/orderHistory.dart';

class DeviceType {
  static bool isTablet(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;

    // A common threshold for tablets is 600dp for the shortest side
    // We also check the pixel ratio to ensure it's not just a large phone
    return shortestSide > 600 && pixelRatio < 2.5;
  }

  static bool isMobile(BuildContext context) {
    return !isTablet(context);
  }
}

class Homemenu extends StatefulWidget {
  const Homemenu({super.key});

  @override
  State<Homemenu> createState() => _HomemenuState();
}

class _HomemenuState extends State<Homemenu> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: HexColor('#f3f6ff'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              decoration: BoxDecoration(
                  color: HexColor('#223dfe'),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Image.asset(
                              'assets/logo/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: AutoSizeText(
                                          "W e l c o m e",
                                          maxLines: 1,
                                          minFontSize: 24,
                                          maxFontSize: 26,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "thaifont"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: AutoSizeText(
                                          "SAREN Planner",
                                          maxLines: 1,
                                          minFontSize: 22,
                                          maxFontSize: 24,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.white, fontFamily: "thaifont"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                      width: double.infinity,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'ค้นหาสินค้า',
                          hintStyle: TextStyle(color: HexColor('#c2c2c2'), fontSize: 20),
                          suffixIcon: Icon(
                            Icons.search,
                            color: HexColor('#dedede'),
                            size: 36,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 10),
              width: double.infinity,
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CategoriesWidget(),
                    TopProductWidget(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = DeviceType.isTablet(context);
    final Size screenSize = MediaQuery.of(context).size;

    final double baseItemWidth = isTablet ? 150 : 120;
    final int minColumns = isTablet ? 4 : 2;
    final int maxColumns = isTablet ? 8 : 4;

    final int crossAxisCount = (screenSize.width / baseItemWidth).floor().clamp(minColumns, maxColumns);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  "Categories",
                  maxLines: 1,
                  minFontSize: 20,
                  maxFontSize: 24,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontFamily: "thaifont", fontWeight: FontWeight.bold),
                ),
                AutoSizeText(
                  "Show All",
                  maxLines: 1,
                  minFontSize: 20,
                  maxFontSize: 24,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontFamily: "thaifont", fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.0,
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            mainAxisSpacing: isTablet ? 24 : 16,
            crossAxisSpacing: isTablet ? 24 : 16,
            children: const [
              CategoryItem(img: "assets/menu/talk.png", label: 'Customer'),
              CategoryItem(img: "assets/menu/cupcake.png", label: 'Order\nProducts', page: OrderPage()),
              CategoryItem(img: "assets/menu/cart.png", label: 'My Orders', page: Orderhistory()),
              CategoryItem(img: "assets/menu/grocery-store.png", label: 'Stores'),
              CategoryItem(img: "assets/menu/delivery.png", label: 'Delivery'),
              CategoryItem(img: "assets/menu/promotion.png", label: 'Promotion'),
            ],
          ),
        ],
      ),
    );
  }
}

class TopProductWidget extends StatelessWidget {
  const TopProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Top Product',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "thaifont"),
          ),
        ),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: const [
            ProductItem(
              image: 'assets/img/cake.png',
              name: 'เค้กส้ม - Jam Cake',
              description: 'บัตเตอร์เค้กหน้าเนยส้ม',
              rating: 4.9,
              reviews: 57,
            ),
            ProductItem(
              image: 'assets/img/cookies.png',
              name: 'คุกกี้คอร์นเฟลก - Cornflake Cookies',
              description: 'คุกกี้เนยสด ผสมคอร์นเฟลก และกลิ่นเนย',
              rating: 4.9,
              reviews: 57,
            ),
          ],
        )
      ],
    );
  }
}

class ProductItem extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final double rating;
  final int reviews;

  const ProductItem({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        color: HexColor('#ffffff'),
      ),
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, color: HexColor('#2bb376'), fontFamily: "thaifont"),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    description,
                    style: TextStyle(color: HexColor('#7377e2'), fontSize: 12, fontFamily: "thaifont"),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$rating',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: HexColor('#aeaeae'), fontFamily: "thaifont"),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '($reviews Reviews)',
                        style: TextStyle(color: HexColor('#aeaeae'), fontSize: 12, fontFamily: "thaifont"),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatefulWidget {
  final String img;
  final String label;
  final Widget? page;

  const CategoryItem({
    Key? key,
    required this.img,
    required this.label,
    this.page,
  }) : super(key: key);

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.page == null) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => widget.page!),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                child: Image.asset(
                  widget.img,
                ),
              ),
            ),
            AutoSizeText(
              widget.label,
              maxLines: 2,
              minFontSize: 12,
              maxFontSize: 16,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HexColor("#a1a1a1"),
                fontWeight: FontWeight.bold,
                fontFamily: "thaifont",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
