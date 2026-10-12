import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/app_storage.dart';

/// HTTP API Client with authentication, error handling, and interceptors
/// Provides a centralized way to communicate with the backend API
class ApiClient {
  late final Dio _dio;
  
  // API Configuration
  static const String _baseUrl = 'https://api.workforces.com/v1';
  static const int _connectTimeout = 30000; // 30 seconds
  static const int _receiveTimeout = 30000; // 30 seconds
  static const int _sendTimeout = 30000; // 30 seconds

  // Singleton instance
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  
  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(milliseconds: _connectTimeout),
      receiveTimeout: const Duration(milliseconds: _receiveTimeout),
      sendTimeout: const Duration(milliseconds: _sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  /// Setup interceptors for authentication, logging, and error handling
  void _setupInterceptors() {
    // Request interceptor - Add auth token to headers
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authentication token to requests
          final token = await AppStorage.getAuthToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Add additional headers
          options.headers['X-Client-Platform'] = Platform.operatingSystem;
          options.headers['X-Client-Version'] = '1.0.0'; // App version
          options.headers['X-Request-ID'] = DateTime.now().millisecondsSinceEpoch.toString();

          if (kDebugMode) {
            print('🚀 API Request: ${options.method} ${options.uri}');
            print('📋 Headers: ${options.headers}');
            if (options.data != null) {
              print('📤 Data: ${options.data}');
            }
          }

          handler.next(options);
        },
        
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('✅ API Response: ${response.statusCode} ${response.requestOptions.uri}');
            print('📥 Data: ${response.data}');
          }
          handler.next(response);
        },
        
        onError: (error, handler) async {
          if (kDebugMode) {
            print('❌ API Error: ${error.response?.statusCode} ${error.requestOptions.uri}');
            print('📛 Message: ${error.message}');
            print('📋 Response: ${error.response?.data}');
          }

          // Handle 401 Unauthorized - Token expired
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshAuthToken();
            if (refreshed) {
              // Retry the original request with new token
              final options = error.requestOptions;
              final token = await AppStorage.getAuthToken();
              options.headers['Authorization'] = 'Bearer $token';
              
              try {
                final response = await _dio.fetch(options);
                handler.resolve(response);
                return;
              } catch (e) {
                // If retry fails, proceed with original error
              }
            }
            
            // If refresh failed or no refresh token, logout user
            await _handleAuthenticationFailure();
          }

          handler.next(error);
        },
      ),
    );

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ));
    }
  }

  /// Refresh authentication token
  Future<bool> _refreshAuthToken() async {
    try {
      final refreshToken = await AppStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Authorization': null}, // Don't include expired token
        ),
      );

      if (response.statusCode == 200) {
        final newToken = response.data['access_token'] as String;
        final newRefreshToken = response.data['refresh_token'] as String?;
        
        await AppStorage.storeAuthToken(newToken);
        if (newRefreshToken != null) {
          await AppStorage.storeRefreshToken(newRefreshToken);
        }
        
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔄 Token refresh failed: $e');
      }
    }
    
    return false;
  }

  /// Handle authentication failure - logout user
  Future<void> _handleAuthenticationFailure() async {
    await AppStorage.clearAuthData();
    
    // TODO: Navigate to login screen
    // This should be handled by the app's navigation service or router
    if (kDebugMode) {
      print('🚪 Authentication failed - User logged out');
    }
  }

  // ===== HTTP METHODS =====

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// Upload file
  Future<Response<T>> upload<T>(
    String path,
    String filePath, {
    String? fileName,
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        if (data != null) ...data,
      });

      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// Download file
  Future<Response> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  // ===== ERROR HANDLING =====

  /// Handle and transform API errors into application-specific exceptions
  ApiException _handleApiError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const ApiException(
            message: 'Connection timeout. Please check your internet connection.',
            statusCode: 408,
            type: ApiExceptionType.timeout,
          );
          
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode ?? 0;
          final message = _extractErrorMessage(error.response?.data) ?? 
                         'An error occurred while processing your request.';
          
          return ApiException(
            message: message,
            statusCode: statusCode,
            type: _getExceptionType(statusCode),
            data: error.response?.data,
          );
          
        case DioExceptionType.cancel:
          return const ApiException(
            message: 'Request was cancelled.',
            statusCode: 0,
            type: ApiExceptionType.cancelled,
          );
          
        case DioExceptionType.connectionError:
          return const ApiException(
            message: 'No internet connection. Please check your network settings.',
            statusCode: 0,
            type: ApiExceptionType.network,
          );
          
        default:
          return const ApiException(
            message: 'An unexpected error occurred.',
            statusCode: 0,
            type: ApiExceptionType.unknown,
          );
      }
    }
    
    return ApiException(
      message: error.toString(),
      statusCode: 0,
      type: ApiExceptionType.unknown,
    );
  }

  /// Extract error message from response data
  String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      // Try common error message fields
      return data['message'] ?? 
             data['error'] ?? 
             data['detail'] ?? 
             data['error_description'];
    }
    return null;
  }

  /// Get exception type based on status code
  ApiExceptionType _getExceptionType(int statusCode) {
    if (statusCode >= 400 && statusCode < 500) {
      return ApiExceptionType.client;
    } else if (statusCode >= 500) {
      return ApiExceptionType.server;
    }
    return ApiExceptionType.unknown;
  }

  // ===== UTILITY METHODS =====

  /// Get base URL
  String get baseUrl => _baseUrl;

  /// Clear all stored data and reset client
  Future<void> reset() async {
    await AppStorage.clearAllData();
    _dio.interceptors.clear();
    _dio.close();
  }

  /// Update base URL (for testing or environment switching)
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }
}

// ===== EXCEPTION CLASSES =====

/// Custom API exception with detailed error information
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final ApiExceptionType type;
  final dynamic data;

  const ApiException({
    required this.message,
    required this.statusCode,
    required this.type,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';

  /// Check if the error is a network-related issue
  bool get isNetworkError => type == ApiExceptionType.network || type == ApiExceptionType.timeout;

  /// Check if the error is client-side (4xx)
  bool get isClientError => type == ApiExceptionType.client;

  /// Check if the error is server-side (5xx)
  bool get isServerError => type == ApiExceptionType.server;

  /// Check if the error indicates unauthorized access
  bool get isUnauthorized => statusCode == 401;

  /// Check if the error indicates forbidden access
  bool get isForbidden => statusCode == 403;

  /// Check if the error indicates resource not found
  bool get isNotFound => statusCode == 404;
}

/// Types of API exceptions
enum ApiExceptionType {
  network,
  timeout,
  client,
  server,
  cancelled,
  unknown,
}