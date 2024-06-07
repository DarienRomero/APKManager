import 'dart:io';

import 'package:apk_manager/features/common/models/error_response.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class FilesController {

  FilesController._privateConstructor();
  static final FilesController _instance = FilesController._privateConstructor();
  factory FilesController() => _instance;

  Future<dynamic> downloadFile(String url, String fileName) async {
    try {
      // Send an HTTP GET request to the URL
      var response = await http.get(Uri.parse(url));

      // Get the application documents directory
      var dir = await getApplicationDocumentsDirectory();

      // The path where the APK will be saved
      String filePath = "${dir.path}/$fileName";

      // Create a file at the specified path
      File file = File(filePath);

      // Write the response body to the file
      await file.writeAsBytes(response.bodyBytes);

      print("File downloaded to $filePath");
      return filePath;
    } catch (e) {
      return ErrorResponse.unknown;
    }
  }
}