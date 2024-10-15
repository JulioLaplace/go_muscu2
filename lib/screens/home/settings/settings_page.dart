import 'package:flutter/material.dart';
import 'package:go_muscu2/components/loading.dart';
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/services/auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // ------------------ ATTRIBUTS ------------------
  final AuthService _auth = AuthService();
  // Loading state
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            'Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          // back button color
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        body: Column(
          children: [
            // Log out button
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
                      dynamic result = await _auth.signOut();
                      if (result is String) {
                        if (context.mounted) {
                          Utils.errorPopUp(context, result);
                        }
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pop(context);
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
                        ? const SizedBox.shrink() // empty widget
                        : Text(
                            'Log out',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
