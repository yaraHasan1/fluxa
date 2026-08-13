import 'package:dio/dio.dart';

import 'package:fluxa/api/token_store.dart';

/// Where the backend lives.
///
/// The ngrok host rotates, so this is the one line to change when it does.
abstract final class ApiConfig {
  static const String baseUrl =
      'https://happier-professor-aids.ngrok-free.dev/api';

  static const Duration timeout = Duration(seconds: 20);
}

/// Every request the app makes goes through here.
///
/// One place that knows the base URL, the headers and how a failure turns into
/// an [ApiException] — so no repository or cubit repeats any of it.
class ApiClient {
  ApiClient({Dio? dio, TokenStore? tokens})
    : _tokens = tokens,
      _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout: ApiConfig.timeout,
              receiveTimeout: ApiConfig.timeout,
              headers: <String, String>{
                // ngrok serves an HTML interstitial to anything that looks like
                // a browser; this header asks for the real response instead.
                'ngrok-skip-browser-warning': 'true',
              },
              // Let any status through so error bodies can be read rather than
              // thrown away as a DioException with no detail.
              validateStatus: (_) => true,
            ),
          ) {
    // One interceptor carries the session, so no endpoint builds an
    // Authorization header of its own.
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          final String? access = _tokens?.tokens?.access;
          if (access != null && access.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $access';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  final TokenStore? _tokens;

  /// POSTs [fields] as multipart form data, which is what the endpoints expect.
  ///
  /// Returns the decoded JSON object, or throws [ApiException].
  Future<Map<String, dynamic>> postForm(
    String path,
    Map<String, dynamic> fields,
  ) async {
    try {
      final Response<dynamic> res = await _dio.post<dynamic>(
        path,
        data: FormData.fromMap(fields),
      );
      return _unwrap<Map<String, dynamic>>(res);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// GETs a JSON array — the shape the list endpoints return.
  ///
  /// A paginated endpoint answers with `{"results": [...]}` instead, so both
  /// shapes are accepted here rather than at every call site.
  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final Response<dynamic> res = await _dio.get<dynamic>(
        path,
        queryParameters: query,
      );
      final dynamic body = _unwrap<dynamic>(res);

      if (body is List) return body;
      if (body is Map && body['results'] is List) return body['results'];
      throw const ApiException('The server sent a response we could not read.');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// GETs a JSON object — the shape the detail endpoints return.
  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final Response<dynamic> res = await _dio.get<dynamic>(
        path,
        queryParameters: query,
      );
      return _unwrap<Map<String, dynamic>>(res);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Checks the status, then hands back the body as [T].
  T _unwrap<T>(Response<dynamic> res) {
    final int status = res.statusCode ?? 0;
    final dynamic body = res.data;

    if (status >= 200 && status < 300) {
      if (body is T) return body as T;
      throw const ApiException('The server sent a response we could not read.');
    }

    throw ApiException(ApiException.messageFromBody(body, status), status);
  }
}

/// A failure worth showing a user.
class ApiException implements Exception {
  const ApiException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  /// Network-level failures, before any response arrived.
  factory ApiException.fromDio(DioException e) => switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => const ApiException(
      'The server took too long to answer. Please try again.',
    ),
    DioExceptionType.connectionError => const ApiException(
      'Could not reach the server. Check your connection.',
    ),
    _ => const ApiException('Something went wrong. Please try again.'),
  };

  /// Pulls a readable line out of a DRF error body.
  ///
  /// Django replies in several shapes — `{"detail": "..."}`, or a map of field
  /// names to lists of messages. Both are flattened to the first message, so
  /// callers never have to inspect the structure.
  static String messageFromBody(dynamic body, int status) {
    if (body is Map) {
      final dynamic detail = body['detail'];
      if (detail is String && detail.isNotEmpty) return detail;

      for (final dynamic value in body.values) {
        if (value is String && value.isNotEmpty) return value;
        if (value is List && value.isNotEmpty) return '${value.first}';
      }
    }
    if (body is String && body.isNotEmpty && body.length < 200) return body;

    return status == 401 || status == 400
        ? 'Those details did not match an account.'
        : 'Something went wrong. Please try again.';
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
