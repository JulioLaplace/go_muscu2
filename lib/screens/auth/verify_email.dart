import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_muscu2/components/loading.dart';
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/screens/home/home_page.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  Timer? timer;

  // is loading
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // user needs to verify email
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    // if user is not verified, send verification email
    if (!isEmailVerified) {
      sendEmailVerification();

      // check every 3 seconds if user has verified email
      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    }
  }

  sendEmailVerification() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      if (!mounted) return;
      Utils.errorPopUp(context, e.toString());
    }
  }

  checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.reload();
    if (user.emailVerified) {
      timer!.cancel();
      setState(() {
        isEmailVerified = true;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomePage()
      : Scaffold(
          appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(70.0), // here the desired height
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: AppBar(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                shadowColor: Colors.transparent,
                centerTitle: true,
                title: Text(
                  'Email verification',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 32,
                      ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'An email has been sent to you. Please verify your email.',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all<Size>(const Size(175, 0)),
                    ),
                    onPressed: () async {
                      // start loading
                      setState(() {
                        isLoading = true;
                      });

                      await FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      if (!context.mounted) return;
                      Utils.validationPopUp(context);

                      // stop loading
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: isLoading
                        ? Loading(
                            size: 20,
                          )
                        : Text(
                            'Resend email',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                  ),
                ],
              ),
            ),
          ));
}
