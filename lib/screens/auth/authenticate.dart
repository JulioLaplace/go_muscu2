import 'package:flutter/material.dart';
import 'package:go_muscu2/screens/auth/login.dart';
import 'package:go_muscu2/screens/auth/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void setSignIn() {
    setState(() {
      showSignIn = true;
    });
  }

  void setRegister() {
    setState(() {
      showSignIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Login(
        setRegister: setRegister,
      );
    } else {
      return Register(
        setSignIn: setSignIn,
      );
    }
  }
}
