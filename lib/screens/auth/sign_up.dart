import 'package:auto_size_text/auto_size_text.dart';
import 'package:sarenplaner/Config/URI.dart';
import 'package:sarenplaner/Functions/HexColor.dart';
import 'package:sarenplaner/screens/auth/confirmPin.dart';
import 'package:sarenplaner/services/fetch.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<bool> validateSinUp(String firstName, String lastName, String phone, String password) async {
    String url = '${SystemURI}/signup';
    Map<String, dynamic> bodyData = {
      'f_name': firstName,
      'l_name': lastName,
      'phone': phone,
      'password': password,
    };

    try {
      var response = await post(url, bodyData);

      if (response.isNotEmpty && response['status'] == true) {
        return true;
      } else {
        print('Failed to sign up: ${response['message']}');
        return false;
      }
    } catch (e) {
      print('Error signing up: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor('#223dfe'),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: HexColor('#223dfe'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: AutoSizeText(
                                "สมัครสมาชิก",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                maxFontSize: 60,
                                minFontSize: 50,
                                style: TextStyle(color: Colors.white, fontFamily: "thaifont"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -50,
                    right: -100,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: 40,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    )),
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 10),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'ชื่อ',
                              filled: true,
                              prefixIcon: Icon(Icons.person),
                              fillColor: Colors.grey[200],
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกชื่อ';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: 'สกุล',
                              prefixIcon: Icon(Icons.person),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกนามสกุล';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'เบอร์มือถือ',
                              prefixIcon: Icon(Icons.phone),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'กรุณากรอกเบอร์มือถือ';

                              String cleanedValue = value.replaceAll(RegExp(r'\s+'), '');
                              if (!RegExp(r'^0[689]\d{8}$').hasMatch(cleanedValue)) return 'กรุณากรอกเบอร์มือถือที่ถูกต้อง (เช่น 08xxxxxxxx)';

                              return null;
                            },
                          ),
                          SizedBox(height: 24),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'รหัสผ่าน',
                              prefixIcon: Icon(Icons.lock),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            obscureText: true,
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
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'ยืนยันรหัสผ่าน',
                              prefixIcon: Icon(Icons.lock),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณายืนยันรหัสผ่าน';
                              }
                              if (value != _passwordController.text) return "รหัสผ่านไม่ถูกต้อง";
                              return null;
                            },
                          ),
                          SizedBox(height: 24),
                          Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    bool signUpSuccess = await validateSinUp(
                                      _firstNameController.text,
                                      _lastNameController.text,
                                      _phoneController.text,
                                      _passwordController.text,
                                    );

                                    if (signUpSuccess) {
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //   SnackBar(content: Text('สมัครสมาชิกเรียบร้อยแล้ว')),
                                      // );
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => PinVerificationPage(phoneNumber: _phoneController.text)),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('การสมัครสมาชิกล้มเหลว กรุณาลองอีกครั้ง')),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(width: 2, color: HexColor('#223dfe')),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "สมัครสมาชิก",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: HexColor('#223dfe'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              InkWell(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    bool signUpSuccess = await validateSinUp(
                                      _firstNameController.text,
                                      _lastNameController.text,
                                      _phoneController.text,
                                      _passwordController.text,
                                    );
                                    print(signUpSuccess);
                                    if (signUpSuccess) {
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //   SnackBar(content: Text('สมัครสมาชิกเรียบร้อยแล้ว')),
                                      // );
                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => Signin()),
                                      // );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('การสมัครสมาชิกล้มเหลว กรุณาลองอีกครั้ง')),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  "มีบัญชีอยู่แล้ว?",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
