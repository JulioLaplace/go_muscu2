import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';

// ignore: must_be_immutable
class MyDropdownButton extends StatefulWidget {
  List<String> items;
  String dropdownTitle;
  String? selectedValue;
  Function(String?)? onChanged;
  MyDropdownButton({
    super.key,
    this.items = const [],
    this.dropdownTitle = 'Select Item',
    this.selectedValue,
    this.onChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  // create dropdown items from string list
  List<DropdownMenuItem<String>> getDropdownItems() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String item in widget.items) {
      var newItem = DropdownMenuItem(
        value: item,
        child: Text(item, style: Theme.of(context).textTheme.bodySmall),
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                widget.dropdownTitle,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: getDropdownItems(),
        value: widget.selectedValue,
        onChanged: widget.onChanged,
        buttonStyleData: ButtonStyleData(
          height: 60,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.grey.shade700,
            ),
            color: Colors.white,
          ),
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(
            Icons.arrow_forward_ios_outlined,
          ),
          iconSize: 14,
          iconEnabledColor: Theme.of(context).colorScheme.secondary,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          elevation: 0,
          useSafeArea: true,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade700,
            ),
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
