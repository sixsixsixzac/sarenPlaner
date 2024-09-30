import 'package:sarenplaner/Functions/HexColor.dart';
import 'package:sarenplaner/screens/auth/sign_in.dart';
import 'package:sarenplaner/services/sweetalert.dart';
import 'package:sarenplaner/services/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class profilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/img/user.png'),
              ),
              SizedBox(height: 16),
              Text(
                'Anantapong Laithong',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'example@email.com',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(fontFamily: 'thaifont', fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#ffe501"),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ),
              SizedBox(height: 24),
              ProfileMenuItem(icon: Icons.settings, title: 'ตั้งค่า'),
              ProfileMenuItem(icon: Icons.credit_card, title: 'รายละเอียดการเรียกเก็บเงิน'),
              ProfileMenuItem(icon: Icons.group, title: 'การจัดการผู้ใช้'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Divider(
                  height: 1,
                  color: Colors.grey[200],
                ),
              ),
              ProfileMenuItem(icon: Icons.info, title: 'ข้อมูล'),
              ProfileMenuItem(
                onTap: () => showCustomSweetAlert(
                  context: context,
                  icon: Icons.error,
                  iconColor: Colors.red,
                  title: "Warning",
                  text: "ต้องการออกจากระบบใช่หรือไม่่?",
                  onConfirm: () async {
                    final userProvider = Provider.of<UserProvider>(context, listen: false);
                    await userProvider.logout();

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Signin()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                icon: Icons.logout,
                title: 'ออกจากระบบ',
                titleColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? titleColor;
  final VoidCallback? onTap; // New parameter for the onTap function

  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    this.titleColor,
    this.onTap, // Add this parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: HexColor('#d8daf2'),
        ),
        child: Icon(
          icon,
          color: HexColor('#242fd0'),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(color: titleColor ?? Colors.black),
      ),
      trailing: (title != "ออกจากระบบ") ? Icon(Icons.chevron_right, color: Colors.grey) : null,
      onTap: onTap,
    );
  }
}
