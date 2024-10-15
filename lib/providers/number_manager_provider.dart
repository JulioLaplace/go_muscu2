import 'dart:developer';

import 'package:flutter/material.dart';

class NumberManagerProvider with ChangeNotifier {
  // replace coma with dot
  String replaceComaWithDot(String value) {
    return value.replaceAll(RegExp(r','), '.');
  }

  // Check number format
  String checkNumberFormat(String value) {
    // Classic number
    // x
    if (RegExp(r'^[0-9]+$').hasMatch(value)) {
      return value;
    }
    // or x.
    if (RegExp(r'^[0-9]+[.,]$').hasMatch(value)) {
      return value.replaceAll(RegExp(r','), '.');
    }
    // or x.y with y different from 0
    if (RegExp(r'^[0-9]+[.][1-9]+$').hasMatch(value)) {
      return value;
    }
    // or x.y with y equal to 0
    if (RegExp(r'^[0-9]+[.]0$').hasMatch(value)) {
      // return value without .0
      return value.substring(0, value.length - 2);
    }
    // Number of type :
    // or x.y+ with y different from 0
    if (RegExp(r'^[0-9]+[.][1-9]+[+]$').hasMatch(value)) {
      return value;
    }
    // or x.y+x
    if (RegExp(r'^[0-9]+[.][1-9]+[+][0-9]+$').hasMatch(value)) {
      return value;
    }
    // or x.y+x.
    if (RegExp(r'^[0-9]+[.][1-9]+[+][0-9]+[.,]$').hasMatch(value)) {
      return value.replaceAll(RegExp(r','), '.');
    }
    // or x.y+x.y with y different from 0
    if (RegExp(r'^[0-9]+[.][1-9]+[+][0-9]+[.][1-9]+$').hasMatch(value)) {
      return value;
    }
    // or x.y+x.y with y equal to 0
    if (RegExp(r'^[0-9]+[.][1-9]+[+][0-9]+[.]0$').hasMatch(value)) {
      // return value without .0
      return value.substring(0, value.length - 2);
    }
    // or x+
    if (RegExp(r'^[0-9]+[+]$').hasMatch(value)) {
      return value;
    }
    // or x+x
    if (RegExp(r'^[0-9]+[+][0-9]+$').hasMatch(value)) {
      return value;
    }
    // or x+x.
    if (RegExp(r'^[0-9]+[+][0-9]+[.,]$').hasMatch(value)) {
      return value.replaceAll(RegExp(r','), '.');
    }
    // or x+x.y with y different from 0
    if (RegExp(r'^[0-9]+[+][0-9]+[.][1-9]+$').hasMatch(value)) {
      return value;
    }
    // or x+x.y with y equal to 0
    if (RegExp(r'^[0-9]+[+][0-9]+[.]0$').hasMatch(value)) {
      // return value without .0
      return value.substring(0, value.length - 2);
    }
    return value.isEmpty ? '' : value.substring(0, value.length - 1);
  }

  // Valid format
  String validNumberFormat(String value) {
    // Classic number
    // x
    if (RegExp(r'^[0-9]+$').hasMatch(value)) {
      return value;
    }
    // or x.
    if (RegExp(r'^[0-9]+.$').hasMatch(value)) {
      return value.substring(0, value.length - 1);
    }
    // or x.y with y different from 0
    if (RegExp(r'^[0-9]+.[1-9]+$').hasMatch(value)) {
      return value;
    }
    // or x.y with y equal to 0
    if (RegExp(r'^[0-9]+.0$').hasMatch(value)) {
      // return value without .0
      return value.substring(0, value.length - 2);
    }
    // Number of type :
    // or x.y+ with y different from 0
    if (RegExp(r'^[0-9]+.[1-9]+[+]$').hasMatch(value)) {
      return value.substring(0, value.length - 1);
    }
    // or x.y+x
    if (RegExp(r'^[0-9]+.[1-9]+[+][0-9]+$').hasMatch(value)) {
      return value;
    }
    // or x.y+x.
    if (RegExp(r'^[0-9]+.[1-9]+[+][0-9]+.$').hasMatch(value)) {
      return value.substring(0, value.length - 1);
    }
    // or x.y+x.y with y different from 0
    if (RegExp(r'^[0-9]+.[1-9]+[+][0-9]+.[1-9]+$').hasMatch(value)) {
      return value;
    }
    // or x.y+x.y with y equal to 0
    if (RegExp(r'^[0-9]+.[1-9]+[+][0-9]+.0$').hasMatch(value)) {
      // return value without .0
      return value.substring(0, value.length - 2);
    }
    // or x+
    if (RegExp(r'^[0-9]+[+]$').hasMatch(value)) {
      return value;
    }
    // or x+x
    if (RegExp(r'^[0-9]+[+][0-9]+$').hasMatch(value)) {
      return value;
    }
    // or x+x.
    if (RegExp(r'^[0-9]+[+][0-9]+.$').hasMatch(value)) {
      return value.substring(0, value.length - 1);
    }
    // or x+x.y with y different from 0
    if (RegExp(r'^[0-9]+[+][0-9]+.[1-9]+$').hasMatch(value)) {
      return value;
    }
    // or x+x.y with y equal to 0
    if (RegExp(r'^[0-9]+[+][0-9]+.0$').hasMatch(value)) {
      // return value without .0
      return value.substring(0, value.length - 2);
    }
    return value.isEmpty ? '' : value.substring(0, value.length - 1);
  }
}
