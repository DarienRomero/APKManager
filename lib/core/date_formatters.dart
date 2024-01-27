import 'package:intl/intl.dart';

String formatDate(DateTime date){
  String formattedDateTime = DateFormat('dd/MM/yyyy hh:mm a').format(date);
  return formattedDateTime;
}