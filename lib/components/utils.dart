import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';
import 'package:go_muscu2/components/loading.dart';

class Utils {
  // Waiting Circle
  static void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: Text(
                "Loading...",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 32,
                    ),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // error Pop up
  static void errorPopUp(BuildContext context, String errorText) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(16),
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.all(
              Radius.circular(doubleRadius),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Oh!",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                    ),
              ),
              Text(
                errorText,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  // Validation pop up
  static void validationPopUp(BuildContext context,
      [String validationText = 'The email has been sended']) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(16),
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.all(
              Radius.circular(doubleRadius),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Perfect!",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                    ),
              ),
              Text(
                validationText,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  // Confirmation pop up : Are you sure? Yes/No
  static Future confirmationPopUp(
    BuildContext context,
    bool confirmation,
    String confirmationText,
    Function() onYes,
    Function() onNo,
  ) async {
    bool isLoading = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            // border radius
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(doubleRadius),
            ),
            title: Text(
              "Wait!",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            content: Text(
              confirmationText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: onNo,
                child: Text(
                  "No",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await onYes();
                  setState(() {
                    isLoading = false;
                  });
                },
                icon: isLoading
                    ? Loading(
                        color: Theme.of(context).colorScheme.primary,
                        size: 25,
                      )
                    : SizedBox.shrink(),
                label: isLoading
                    ? SizedBox.shrink()
                    : Text(
                        "Yes",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
