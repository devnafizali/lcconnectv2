import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<dynamic> apipost(enpoint, body) async {
  String ip = "192.168.4.1";
  Map<String, String> customHeaders = {"content-type": "application/json"};
  final response = await http.post(
    Uri.parse('http://$ip/$enpoint'),
    body: json.encode(body),
    headers: customHeaders,
  );
  return response.body;
}
