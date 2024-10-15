import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_muscu2/components/loading.dart';
import 'package:go_muscu2/components/home/my_textfield.dart';
import 'package:go_muscu2/components/authentication/square_tile.dart';
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/screens/auth/forgot_password.dart';
import 'package:go_muscu2/services/auth.dart';

class Login extends StatefulWidget {
  final Function setRegister;

  const Login({super.key, required this.setRegister});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  // ----- ATTRIBUTS ------
  final AuthService _auth = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();

  // is loading
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Add the WidgetsBindingObserver to the current state
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    // Remove the WidgetsBindingObserver when the state is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

// password confirmed function
  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

// is an integer function
  bool isNumeric(String s) {
    try {
      int.parse(s);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0), // here the desired height
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
              'Login',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 32,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: TextButton(
                  onPressed: () {
                    widget.setRegister();
                  },
                  style: const ButtonStyle(
                    overlayColor: MaterialStatePropertyAll(Colors.white24),
                  ),
                  child: Text(
                    "Register",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            ],
          ),
        ),
      ),

      // body
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside the text fields
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Icon(
                Icons.lock,
                size: 70,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 20,
              ),

              // Age textfield

              // Email textfield
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: MyTextfield(
                      controller: _emailController,
                      hintText: 'Email',
                      obscureText: false)),
              const SizedBox(
                height: 20,
              ),

              // Password textfield
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: MyTextfield(
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: true)),
              const SizedBox(
                height: 20,
              ),

              // Forgot password ?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ForgotPasswordPage();
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              // Login button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(
                      width: double.infinity,
                      height: 60,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        // sign in method
                        dynamic result = await _auth.signIn(
                            _emailController.text.trim(),
                            _passwordController.text.trim());
                        if (result is String) {
                          if (context.mounted) {
                            Utils.errorPopUp(context, result);
                          }
                        } else {
                          // signed in
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                      icon: isLoading
                          ? Loading(
                              size: 25,
                            )
                          : Icon(
                              Icons.lock_open,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      label: isLoading
                          ? const SizedBox.shrink() // empty widget
                          : Text(
                              'Login',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),

              // divider to separate the two parts with "or" text
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // apple and google logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google button
                  SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/images/google_logo.png'),

                  const SizedBox(
                    width: 40,
                  ),
                  // Apple button
                  // check if the user is using an apple device
                  if (Platform.isIOS)
                    SquareTile(
                        // onTap: () => AuthService().signInWithApple(),
                        onTap: () {},
                        imagePath: 'lib/images/apple_logo.png'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
