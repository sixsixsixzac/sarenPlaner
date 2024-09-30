import 'package:auto_size_text/auto_size_text.dart';
import 'package:sarenplaner/Config/URI.dart';
import 'package:sarenplaner/Functions/HexColor.dart';
import 'package:sarenplaner/screens/auth/sign_up.dart';
import 'package:sarenplaner/screens/home/home.dart';
import 'package:sarenplaner/services/fetch.dart';
import 'package:sarenplaner/services/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await post(
          '${SystemURI}/signin',
          {
            'phone': _phoneController.text,
            'password': _passwordController.text,
          },
        );

        setState(() {
          _isLoading = false;
        });

        if (response['status'] == true) {
          String userId = response['data']['userId'].toString();
          await Provider.of<UserProvider>(context, listen: false).login(userId);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: HexColor('#e5646e'), content: Center(child: Text(response['text'] ?? 'การเข้าสู่ระบบล้มเหลว กรุณาลองอีกครั้ง'))),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('มีข้อผิดพลาดเกิดขึ้นโปรดลองอีกครั้ง.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: HexColor('#223dfe'),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.only(top: 25),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: HexColor('#223dfe'),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: AutoSizeText(
                          "Saren Planer",
                          maxLines: 1,
                          minFontSize: 40,
                          maxFontSize: 55,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: HexColor('#f3f6ff'), fontFamily: "engfont", fontSize: 50),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Image.asset('assets/logo/logo.png'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    color: HexColor("#ffffff"),
                    boxShadow: [
                      BoxShadow(
                        color: HexColor('#2d2c29').withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, -3), // Negative y-offset for top shadow
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: AutoSizeText(
                            "เข้าสู่ระบบ",
                            maxLines: 1,
                            minFontSize: 36,
                            maxFontSize: 46,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: HexColor('#cccccc'), fontFamily: "thaifont", fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'เบอร์มือถือ',
                                    style: TextStyle(fontSize: 16, fontFamily: 'thaifont'),
                                  ),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: _phoneController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: HexColor('#f0f3f1'),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: Icon(Icons.phone),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'กรุณากรอกเบอร์มือถือ';

                                      String cleanedValue = value.replaceAll(RegExp(r'\s+'), '');
                                      if (!RegExp(r'^0[689]\d{8}$').hasMatch(cleanedValue)) return 'กรุณากรอกเบอร์มือถือที่ถูกต้อง (เช่น 08xxxxxxxx)';

                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'รหัสผ่าน Password',
                                    style: TextStyle(fontSize: 16, fontFamily: 'thaifont'),
                                  ),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: HexColor('#f0f3f1'),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: Icon(Icons.lock),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'กรุณากรอกรหัสผ่าน';
                                      }
                                      if (value.length < 6) {
                                        return 'รหัสผ่านต้องมีอย่างน้อย 6 หลัก';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 24),
                                  ElevatedButton(
                                    child: _isLoading
                                        ? CircularProgressIndicator(color: Colors.white)
                                        : Text(
                                            'เข้าสู่ระบบ',
                                            style: TextStyle(color: HexColor('#ffffff'), fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'thaifont'),
                                          ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: HexColor("#223dfe"),
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: _isLoading ? null : _login,
                                  ),
                                  SizedBox(height: 24),
                                  ElevatedButton(
                                    child: Text(
                                      'สมัครสมาชิก',
                                      style: TextStyle(color: HexColor('#223dfe'), fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'thaifont'),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(color: HexColor('#223dfe'), width: 2),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => SignUp()),
                                      );
                                    },
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ShakingImage extends StatefulWidget {
  final String imagePath;
  final int flex;

  ShakingImage({required this.imagePath, this.flex = 8});

  @override
  _ShakingImageState createState() => _ShakingImageState();
}

class _ShakingImageState extends State<ShakingImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -20, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_animation.value, 0),
            child: child,
          );
        },
        child: Image.asset(widget.imagePath),
      ),
    );
  }
}
