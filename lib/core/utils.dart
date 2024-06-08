import 'package:flutter/material.dart';

double mqHeigth(BuildContext context, double percentage){
  return MediaQuery.of(context).size.height * (percentage/100);
}
double mqWidth(BuildContext context, double percentage){
  return MediaQuery.of(context).size.width * (percentage/100);
}

const String notFoundImage = "assets/images/not_found.jpg";
const String loadingImage = "assets/images/loading_image.gif";

bool compareStringLists(List<String> list1, List<String> list2) {
  // Check if both lists have the same length
  if (list1.length != list2.length) {
    return false;
  }

  // Compare each element in the lists
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) {
      return false;
    }
  }

  // If all elements are the same, return true
  return true;
}