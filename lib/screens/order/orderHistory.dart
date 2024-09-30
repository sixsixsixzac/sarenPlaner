import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sarenplaner/Config/URI.dart';
import 'package:sarenplaner/Functions/HexColor.dart';
import 'package:sarenplaner/Functions/Navigate.dart';
import 'package:sarenplaner/screens/home/home.dart';
import 'package:expandable/expandable.dart';
import 'package:sarenplaner/services/fetch.dart';
import 'package:sarenplaner/services/userProvider.dart';

class Orderhistory extends StatefulWidget {
  const Orderhistory({super.key});

  @override
  State<Orderhistory> createState() => _OrderhistoryState();
}

class _OrderhistoryState extends State<Orderhistory> {
  final TextEditingController _searchController = TextEditingController();
  late UserProvider userProvider;
  bool isLoading = false;
  bool isMounted = false;
  List<Map<String, dynamic>> myOrders = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      isMounted = true;
      userProvider = Provider.of<UserProvider>(context, listen: false);
    });
    fetch();
  }

  Future<void> fetch() async {
    setState(() {
      isLoading = true;
    });
    await getOrders();
  }

  Future<void> getOrders() async {
    if (!isMounted) return;
    String apiUrl = '$SystemURI/myOrder';
    try {
      String? userId = userProvider.userId;
      Map<String, dynamic> requestData = {
        'searchTerm': _searchController.text,
        'userId': userId,
      };
      final orders = await fetchData(apiUrl, requestData);
      setState(() {
        myOrders = orders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        if (!isMounted) return;
        isLoading = false;
      });
    }
  }

  String calculateTotal(List items) {
    double total = items.fold(0, (sum, item) => sum + (item['prdprice'] * item['prdqty']));
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#f4f5fc"),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 80,
            leading: GestureDetector(
              onTap: () {
                navigateTo(context: context, toPage: const HomePage(), replace: true);
              },
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  size: 24,
                  color: HexColor('#0067db'),
                ),
              ),
            ),
            title: Text(
              'ออเดอร์ของฉัน',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: HexColor('#0067db'),
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                    hintText: "ค้นหาเลขออเดอร์",
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.search,
                      color: HexColor('#b6babe'),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            Expanded(
              child: (isLoading == true)
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: myOrders.length,
                      itemBuilder: (context, index) {
                        var order = myOrders[index];
                        return Card(
                          color: Colors.white,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: ExpandablePanel(
                            theme: const ExpandableThemeData(
                              headerAlignment: ExpandablePanelHeaderAlignment.center,
                              tapBodyToExpand: true,
                              tapBodyToCollapse: true,
                            ),
                            header: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "ออเดอร์ #${order['ordno']}",
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          "รอจัดส่ง",
                                          style: TextStyle(fontSize: 14, color: Colors.orange, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            collapsed: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Text(
                                'รวม ${calculateTotal(order['items'])} บาท',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            expanded: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...order['items'].map((item) => ListTile(
                                      title: RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context).style,
                                          children: [
                                            TextSpan(text: item['prddesc']),
                                            TextSpan(text: " x${item['prdqty']}", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      trailing: Text(
                                        '฿ ${(item['prdprice'] * item['prdqty']).toStringAsFixed(2)}',
                                        style: const TextStyle(fontFamily: 'thaifont', fontSize: 16),
                                      ),
                                    )),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                                  ),
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  child: Center(
                                    child: Text(
                                      'รวม ${calculateTotal(order['items'])} บาท',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
