import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String _baseUrl = 'http://192.168.11.15:8080';
  static const _timeout = Duration(seconds: 15);

  String? _token;

  void setToken(String? token) => _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<http.Response> get(String path) => _wrap(
    http.get(Uri.parse('$_baseUrl$path'), headers: _headers),
  );

  Future<http.Response> post(String path, Map<String, dynamic> body) => _wrap(
    http.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    ),
  );

  Future<http.Response> delete(String path) => _wrap(
    http.delete(Uri.parse('$_baseUrl$path'), headers: _headers),
  );

  // Applies a timeout and converts platform exceptions (SocketException,
  // TimeoutException) into regular Dart exceptions so the debugger does not
  // pause on them when "break on all exceptions" is enabled.
  Future<http.Response> _wrap(Future<http.Response> call) async {
    try {
      return await call.timeout(_timeout);
    } on SocketException {
      throw Exception('No internet connection. Check that the server is reachable.');
    } on TimeoutException {
      throw Exception('Request timed out after ${_timeout.inSeconds}s.');
    }
  }
}
