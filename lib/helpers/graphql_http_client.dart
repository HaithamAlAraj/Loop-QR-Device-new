import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/secret.dart';

class GraphqlHttpException implements Exception {
  final int statusCode;
  final String body;
  GraphqlHttpException(this.statusCode, this.body);

  @override
  String toString() => 'GraphqlHttpException($statusCode): $body';
}

class GraphqlResponseException implements Exception {
  final List<dynamic> errors;
  final Map<String, dynamic>? data;
  GraphqlResponseException(this.errors, {this.data});

  @override
  String toString() => 'GraphqlResponseException(errors=${errors.length})';
}

class GraphqlHttpClient {
  GraphqlHttpClient({http.Client? client})
      : _client = client ?? http.Client(),
        _ownsClient = client == null;

  final http.Client _client;
  final bool _ownsClient;

  Future<Map<String, dynamic>> post({
    required String query,
    Map<String, dynamic>? variables,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    var session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      throw StateError('Not authenticated');
    }

    Future<http.Response> doRequest(String accessToken) {
      return _client
          .post(
            Uri.parse(graphqlUrl),
            headers: {
              'Content-Type': 'application/json',
              'apikey': anonKey,
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode({
              'query': query,
              'variables': variables ?? const <String, dynamic>{},
            }),
          )
          .timeout(timeout);
    }

    http.Response res;
    try {
      res = await doRequest(session.accessToken);
    } on TimeoutException {
      throw TimeoutException('GraphQL request timed out after $timeout');
    } on SocketException catch (e) {
      throw SocketException('Network error: ${e.message}');
    }

    if (res.statusCode == 401 || res.statusCode == 403) {
      final refreshRes = await Supabase.instance.client.auth.refreshSession();
      session = refreshRes.session;
      if (session == null) {
        throw StateError('Session expired and refresh failed');
      }
      res = await doRequest(session.accessToken);
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw GraphqlHttpException(res.statusCode, res.body);
    }

    final decoded = jsonDecode(res.body);
    if (decoded is! Map<String, dynamic>) {
      throw StateError('Unexpected GraphQL response shape');
    }

    final data = decoded['data'];
    final errors = decoded['errors'];

    if (errors is List && errors.isNotEmpty) {
      throw GraphqlResponseException(
        errors,
        data: data is Map<String, dynamic> ? data : null,
      );
    }

    if (data is Map<String, dynamic>) return data;

    return const <String, dynamic>{};
  }

  void close() {
    if (_ownsClient) _client.close();
  }
}
