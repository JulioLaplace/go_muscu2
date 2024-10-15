import 'package:flutter/material.dart';
import 'package:go_muscu2/components/loading.dart';
import 'package:go_muscu2/components/home/my_textfield.dart';
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/services/auth.dart';

class Register extends StatefulWidget {
  final Function setSignIn;

  const Register({super.key, required this.setSignIn});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with WidgetsBindingObserver {
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
              'Register',
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
                    widget.setSignIn();
                  },
                  style: const ButtonStyle(
                    overlayColor: MaterialStatePropertyAll(Colors.white24),
                  ),
                  child: Text(
                    "Sign in",
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
              Row(
                children: <Widget>[
                  // First name textfield
                  Flexible(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: MyTextfield(
                            controller: _firstNameController,
                            hintText: 'First name',
                            obscureText: false)),
                  ),

                  // Last name textfield
                  Flexible(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: MyTextfield(
                            controller: _lastNameController,
                            hintText: 'Last name',
                            obscureText: false)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              // Age textfield
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 120,
                  ),
                  Flexible(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: MyTextfield(
                            controller: _ageController,
                            hintText: 'Age',
                            obscureText: false)),
                  ),
                  const SizedBox(
                    width: 120,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

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

              // Confirm password textfield
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: MyTextfield(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm password',
                    obscureText: true,
                  )),
              const SizedBox(
                height: 20,
              ),

              // Register button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(
                        width: double.infinity, height: 60),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // is loading
                        if (context.mounted) {
                          setState(() {
                            isLoading = true;
                          });
                        }

                        // check if the two given passwords are the same
                        if (passwordConfirmed()) {
                          // register method
                          if (isNumeric(_ageController.text.trim())) {
                            dynamic result = await _auth.register(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              _firstNameController.text.trim(),
                              _lastNameController.text.trim(),
                              int.parse(_ageController.text.trim()),
                            );
                            if (result is String) {
                              if (context.mounted) {
                                Utils.errorPopUp(context, result);
                              }
                            } else {}
                          } else {
                            Utils.errorPopUp(
                                context, "The age is not an integer");
                          }
                        } else {
                          Utils.errorPopUp(context, "Passwords don't match!");
                        }
                        // end of loading
                        if (context.mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
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
                          ? const SizedBox.shrink()
                          : Text('Register',
                              style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
