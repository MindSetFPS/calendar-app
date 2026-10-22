import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:calendar/core/config/api_config.dart';
import 'package:calendar/features/user/domain/entities/user.dart';

class AuthApiException implements Exception {
  const AuthApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

typedef AuthSession = ({String accessToken, User user});

/// Network calls against the FastAPI backend.
///
/// Contracts used:
/// - POST /auth/register { email, password } -> 201 UserPublic
/// - POST /auth/login    { email, password } -> { access_token, ... }
/// - GET  /auth/me       Bearer token        -> UserPublic
class AuthRemoteDataSource {
  AuthRemoteDataSource({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final http.Client _client;
  final String _baseUrl;

  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final accessToken = await _login(email: email, password: password);
    final user = await currentUser(accessToken);
    return (accessToken: accessToken, user: user);
  }

  Future<AuthSession> signUp({
    required String email,
    required String password,
  }) async {
    await _request(
      'POST',
      '/auth/register',
      body: {'email': email, 'password': password},
      expectedStatus: 201,
    );
    return signIn(email: email, password: password);
  }

  Future<User> currentUser(String accessToken) async {
    final body = await _request('GET', '/auth/me', accessToken: accessToken);
    return _userFromJson(body);
  }

  Future<String> _login({
    required String email,
    required String password,
  }) async {
    final body = await _request(
      'POST',
      '/auth/login',
      body: {'email': email, 'password': password},
    );
    final accessToken = body['access_token'];
    if (accessToken is! String || accessToken.isEmpty) {
      throw const AuthApiException('The server returned an invalid session.');
    }
    return accessToken;
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    String? accessToken,
    int expectedStatus = 200,
  }) async {
    final headers = <String, String>{'Accept': 'application/json'};
    if (body != null) headers['Content-Type'] = 'application/json';
    if (accessToken != null) headers['Authorization'] = 'Bearer $accessToken';

    final http.Response response;
    try {
      final request = http.Request(method, Uri.parse('$_baseUrl$path'))
        ..headers.addAll(headers);
      if (body != null) request.body = jsonEncode(body);
      final streamed =
          await _client.send(request).timeout(const Duration(seconds: 15));
      response = await http.Response.fromStream(streamed);
    } on TimeoutException {
      throw const AuthApiException('The server took too long to respond.');
    } on SocketException {
      throw const AuthApiException('Could not reach the server.');
    } on http.ClientException {
      throw const AuthApiException('Could not reach the server.');
    }

    final decoded = _decode(response.body);
    if (response.statusCode != expectedStatus) {
      throw AuthApiException(
        _messageFrom(decoded),
        statusCode: response.statusCode,
      );
    }
    return decoded;
  }

  Map<String, dynamic> _decode(String body) {
    if (body.isEmpty) return <String, dynamic>{};
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    } on FormatException {
      return <String, dynamic>{};
    }
  }

  String _messageFrom(Map<String, dynamic> body) {
    final detail = body['detail'];
    if (detail is String && detail.isNotEmpty) return detail;
    if (detail is List && detail.isNotEmpty) {
      final first = detail.first;
      if (first is Map && first['msg'] is String) return first['msg'] as String;
    }
    return 'Something went wrong. Please try again.';
  }

  User _userFromJson(Map<String, dynamic> json) {
    final email = (json['email'] as String? ?? '').trim();
    final id = json['id']?.toString() ?? email;
    return User(
      id: id,
      name: _nameFromEmail(email),
      handle: _handleFromEmail(email),
      bio: 'Pulse member',
    );
  }

  String _handleFromEmail(String email) {
    final local = email.split('@').first;
    final sanitized = local.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '');
    return sanitized.isEmpty ? 'pulseuser' : sanitized;
  }

  String _nameFromEmail(String email) {
    final parts = email
        .split('@')
        .first
        .split(RegExp(r'[._\-]+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'Pulse User';
    return parts
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }
}
