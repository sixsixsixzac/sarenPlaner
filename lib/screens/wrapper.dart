import 'package:sarenplaner/screens/auth/auth.dart';
import 'package:sarenplaner/screens/home/home.dart';
import 'package:sarenplaner/services/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.isLoggedIn) {
      return HomePage();
    } else {
      return Authenticate();
    }
  }
}
