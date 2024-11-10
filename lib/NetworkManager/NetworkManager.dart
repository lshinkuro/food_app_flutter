// Import required packages
import 'dart:convert';
import 'package:http/http.dart' as http; // Import required packages

class NetworkManager {
  // Base URL untuk API
  static const String baseUrl = 'http://localhost:3001/api/v1';

  // Singleton pattern
  static final NetworkManager _instance = NetworkManager._internal();

  factory NetworkManager() {
    return _instance;
  }

  NetworkManager._internal();

  // Headers yang umum digunakan
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Tambahkan authorization header jika diperlukan
        // 'Authorization': 'Bearer $token',
      };

  // GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<dynamic> post(String endpoint, {dynamic body}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, {dynamic body}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Handle API response
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 400:
        throw BadRequestException(response.body);
      case 401:
      case 403:
        throw UnauthorizedException(response.body);
      case 404:
        throw NotFoundException(response.body);
      case 500:
      default:
        throw ServerException(
            'An error occurred while communicating with server');
    }
  }

  // Handle errors
  Exception _handleError(dynamic error) {
    if (error is Exception) {
      if (error is http.ClientException) {
        return NetworkException('Network error occurred');
      }
      return error;
    }
    return UnknownException('Unknown error occurred');
  }
}

// Custom Exceptions
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class UnknownException implements Exception {
  final String message;
  UnknownException(this.message);
}
