// Datetime converter class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Convert datetime to string

// 'dd-MM-yyyy HH:mm'
String convertDatetimeToString(DateTime datetime) {
  return DateFormat('dd-MM-yyyy HH:mm').format(datetime);
}

// 'dd-MM-yyyy'
String convertDatetimeToStringWithoutTime(DateTime datetime) {
  return DateFormat('dd-MM-yyyy').format(datetime);
}

// HH:mm
String convertDatetimeToTime(DateTime datetime) {
  return DateFormat('HH:mm').format(datetime);
}

DateTime convertStringToDatetime(String datetime) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').parse(datetime);
}

// convert Timestamp to DateTime
DateTime convertTimestampToDatetime(Timestamp timestamp) {
  return timestamp.toDate();
}

// convert Duration to String
String convertDurationToString(Duration duration) {
  return duration.toString().split('.').first.padLeft(8, "0");
}
