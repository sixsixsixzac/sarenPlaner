import 'package:sarenplaner/Config/URI.dart';
import 'package:sarenplaner/Functions/HexColor.dart';
import 'package:sarenplaner/screens/home/home.dart';
import 'package:sarenplaner/services/fetch.dart';
import 'package:sarenplaner/services/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PinVerificationPage extends StatefulWidget {
  final String phoneNumber;

  PinVerificationPage({required this.phoneNumber});

  @override
  _PinVerificationPageState createState() => _PinVerificationPageState();
}

class _PinVerificationPageState extends State<PinVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _verifyPinCode() async {
    String enteredPin = _controllers.map((controller) => controller.text).join();
    if (enteredPin.length == 6) {
      setState(() {
        _isLoading = true;
      });

      try {
        Map<String, dynamic> bodyData = {
          'otp': enteredPin,
          'phoneNumber': widget.phoneNumber,
        };
        String url = '${SystemURI}/verify-pin';
        var response = await post(url, bodyData);
        if (response.isNotEmpty && response['status'] == true) {
          String userId = response['data']['userId'].toString();
          await Provider.of<UserProvider>(context, listen: false).login(userId);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('รหัส PIN ไม่ถูกต้อง โปรดลองอีกครั้ง')),
          );
        }
      } catch (e) {
        print('Error verifying PIN: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด โปรดลองอีกครั้งในภายหลัง')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> sendSMS() async {
    String url = '${SystemURI}/sendSMS';
    Map<String, dynamic> bodyData = {
      'phoneNumber': widget.phoneNumber,
    };

    try {
      var response = await post(url, bodyData);

      if (response.isNotEmpty && response['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ส่งรหัสยืนยันตัวตนสำเร็จกรุณาตรวจสอบ SMS')),
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error signing up: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor('#223dfe'),
          title: Text(
            'ยืนยันตัวตน',
            style: TextStyle(color: Colors.white, fontFamily: 'thaifont'),
          ),
        ),
        body: Material(
          color: HexColor('#ffffff'),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'รหัสยืนยันถูกส่งไปยังเบอร์ ${widget.phoneNumber}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontFamily: 'thaifont'),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 40,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                          if (index == 5 && value.length == 1) {
                            _verifyPinCode();
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    backgroundColor: HexColor('#223dfe'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _verifyPinCode,
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(color: Colors.white, fontFamily: 'thaifont'),
                  ),
                ),
                TextButton(
                  onPressed: sendSMS,
                  child: Text(
                    'ส่งรหัสยืนยันใหม่',
                    style: TextStyle(fontFamily: 'thaifont'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      if (_isLoading)
        Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          ),
        ),
    ]);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
