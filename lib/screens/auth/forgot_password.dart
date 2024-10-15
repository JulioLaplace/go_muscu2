import 'package:flutter/material.dart';
import 'package:go_muscu2/components/home/my_textfield.dart';
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/services/auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with WidgetsBindingObserver {
  // ----- ATTRIBUTS ------
  final AuthService _auth = AuthService();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Add the WidgetsBindingObserver to the current state
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    // Remove the WidgetsBindingObserver when the state is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

          // appbar
          child: AppBar(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Text(
                'Reset password',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 32,
                    ),
              ),
              iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.secondary,
              )),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside the text fields
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            // Enter your email and we will send you a password reset link
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Enter your email and we will send you a password reset link:',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MyTextfield(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false)),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, right: 20.0, left: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(
                      width: double.infinity, height: 60),
                  child: MaterialButton(
                    onPressed: () async {
                      // waiting circle
                      Utils.showLoaderDialog(context);
                      // reset password method
                      dynamic result = await _auth
                          .resetPassword(_emailController.text.trim());
                      if (result is String) {
                        if (context.mounted) Utils.errorPopUp(context, result);
                        print(result);
                      } else {
                        if (context.mounted) Utils.validationPopUp(context);
                        _emailController.clear();
                        print(result);
                      }
                      // end of the waiting circle
                      if (context.mounted) Navigator.pop(context);
                    },
                    color: Theme.of(context).colorScheme.primary,
                    elevation: 0,
                    child: Text(
                      'Send email',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                child: Container(
              height: double.infinity,
              color: Colors.transparent,
            ))
          ],
        ),
      ),
    );
  }
}
