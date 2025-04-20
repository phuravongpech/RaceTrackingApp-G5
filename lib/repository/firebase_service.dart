import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class FirebaseService {
  final String baseUrl;
  final http.Client httpClient;
  final Logger logger = Logger();

  FirebaseService({required this.baseUrl, required this.httpClient});

  Future<http.Response> get(String endpoint, {String? id}) async {
    final url =
        id != null ? '$baseUrl/$endpoint/$id.json' : '$baseUrl/$endpoint.json';

    logger.d("GET request to: $url");
    final response = await httpClient.get(Uri.parse(url));
    logger.d("Response status: ${response.statusCode}");
    logger.d("Response body: ${response.body}");
    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = '$baseUrl/$endpoint.json';
    logger.d("POST request to: $url with data: $data");

    final response = await httpClient.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    logger.d("Response status: ${response.statusCode}");
    logger.d("Response body: ${response.body}");
    return response;
  }

  Future<http.Response> put(
    String endpoint,
    String id,
    Map<String, dynamic> data,
  ) async {
    final url = '$baseUrl/$endpoint/$id.json';
    logger.d("PUT request to: $url with data: $data");

    final response = await httpClient.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    logger.d("Response status: ${response.statusCode}");
    logger.d("Response body: ${response.body}");
    return response;
  }

  Future<http.Response> delete(String endpoint, String id) async {
    final url = '$baseUrl/$endpoint/$id.json';
    logger.d("DELETE request to: $url");

    final response = await httpClient.delete(Uri.parse(url));

    logger.d("Response status: ${response.statusCode}");
    logger.d("Response body: ${response.body}");
    return response;
  }
}
