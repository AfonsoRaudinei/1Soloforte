/// Centralized exception hierarchy for SoloForte app.
///
/// All application errors should extend [AppException] to ensure
/// consistent error handling and propagation throughout the app.
library;

import 'package:flutter/foundation.dart';

/// Base class for all application exceptions.
///
/// Use specific subclasses for different error types:
/// - [NetworkException] for connectivity issues
/// - [AuthException] for authentication failures
/// - [ValidationException] for form/data validation
/// - [StorageException] for local database issues
/// - [ApiException] for backend API errors
sealed class AppException implements Exception {
  /// Human-readable error message for display to users
  final String message;

  /// Original error that caused this exception (for debugging)
  final Object? originalError;

  /// Stack trace when the error occurred
  final StackTrace? stackTrace;

  /// Error code for programmatic handling
  final String? code;

  const AppException(
    this.message, {
    this.originalError,
    this.stackTrace,
    this.code,
  });

  @override
  String toString() {
    if (kDebugMode && originalError != null) {
      return '$runtimeType: $message\nCaused by: $originalError';
    }
    return '$runtimeType: $message';
  }
}

/// Network-related exceptions (no connection, timeout, etc.)
class NetworkException extends AppException {
  /// HTTP status code if available
  final int? statusCode;

  const NetworkException({
    String message = 'Erro de conexão. Verifique sua internet.',
    super.originalError,
    super.stackTrace,
    super.code,
    this.statusCode,
  }) : super(message);

  /// Connection timeout
  factory NetworkException.timeout() => const NetworkException(
    message: 'Conexão expirou. Tente novamente.',
    code: 'TIMEOUT',
  );

  /// No internet connection
  factory NetworkException.noConnection() => const NetworkException(
    message: 'Sem conexão com a internet.',
    code: 'NO_CONNECTION',
  );

  /// Server unreachable
  factory NetworkException.serverUnreachable() => const NetworkException(
    message: 'Servidor indisponível. Tente mais tarde.',
    code: 'SERVER_UNREACHABLE',
  );
}

/// Authentication and authorization exceptions
class AuthException extends AppException {
  const AuthException({
    String message = 'Erro de autenticação.',
    super.originalError,
    super.stackTrace,
    super.code,
  }) : super(message);

  /// Invalid credentials
  factory AuthException.invalidCredentials() => const AuthException(
    message: 'E-mail ou senha incorretos.',
    code: 'INVALID_CREDENTIALS',
  );

  /// Session expired
  factory AuthException.sessionExpired() => const AuthException(
    message: 'Sessão expirada. Faça login novamente.',
    code: 'SESSION_EXPIRED',
  );

  /// User not found
  factory AuthException.userNotFound() => const AuthException(
    message: 'Usuário não encontrado.',
    code: 'USER_NOT_FOUND',
  );

  /// Email already in use
  factory AuthException.emailInUse() => const AuthException(
    message: 'Este e-mail já está cadastrado.',
    code: 'EMAIL_IN_USE',
  );

  /// Weak password
  factory AuthException.weakPassword() => const AuthException(
    message: 'Senha muito fraca. Use pelo menos 6 caracteres.',
    code: 'WEAK_PASSWORD',
  );

  /// Account disabled
  factory AuthException.accountDisabled() => const AuthException(
    message: 'Conta desativada. Entre em contato com o suporte.',
    code: 'ACCOUNT_DISABLED',
  );

  /// Token refresh failed
  factory AuthException.tokenRefreshFailed() => const AuthException(
    message: 'Falha ao renovar sessão. Faça login novamente.',
    code: 'TOKEN_REFRESH_FAILED',
  );
}

/// Form and data validation exceptions
class ValidationException extends AppException {
  /// Map of field names to their error messages
  final Map<String, String> fieldErrors;

  const ValidationException(
    this.fieldErrors, {
    String message = 'Dados inválidos. Verifique os campos.',
    super.originalError,
    super.stackTrace,
    super.code,
  }) : super(message);

  /// Single field validation error
  factory ValidationException.field(String fieldName, String error) {
    return ValidationException({fieldName: error});
  }

  /// Required field missing
  factory ValidationException.required(String fieldName) {
    return ValidationException({fieldName: 'Campo obrigatório'});
  }

  /// Invalid email format
  factory ValidationException.invalidEmail() {
    return ValidationException({'email': 'E-mail inválido'});
  }

  /// Check if a specific field has an error
  bool hasError(String fieldName) => fieldErrors.containsKey(fieldName);

  /// Get error message for a specific field
  String? getError(String fieldName) => fieldErrors[fieldName];
}

/// Local storage/database exceptions
class StorageException extends AppException {
  const StorageException({
    String message = 'Erro ao acessar dados locais.',
    super.originalError,
    super.stackTrace,
    super.code,
  }) : super(message);

  /// Database initialization failed
  factory StorageException.initFailed() => const StorageException(
    message: 'Falha ao inicializar banco de dados.',
    code: 'INIT_FAILED',
  );

  /// Record not found
  factory StorageException.notFound(String entity) => StorageException(
    message: '$entity não encontrado(a).',
    code: 'NOT_FOUND',
  );

  /// Write failed
  factory StorageException.writeFailed() => const StorageException(
    message: 'Falha ao salvar dados.',
    code: 'WRITE_FAILED',
  );

  /// Read failed
  factory StorageException.readFailed() => const StorageException(
    message: 'Falha ao ler dados.',
    code: 'READ_FAILED',
  );
}

/// Backend API exceptions
class ApiException extends AppException {
  /// HTTP status code
  final int statusCode;

  /// Raw response body if available
  final String? responseBody;

  const ApiException({
    required this.statusCode,
    String message = 'Erro no servidor.',
    this.responseBody,
    super.originalError,
    super.stackTrace,
    super.code,
  }) : super(message);

  /// 400 Bad Request
  factory ApiException.badRequest([String? message]) => ApiException(
    statusCode: 400,
    message: message ?? 'Requisição inválida.',
    code: 'BAD_REQUEST',
  );

  /// 401 Unauthorized
  factory ApiException.unauthorized() => const ApiException(
    statusCode: 401,
    message: 'Não autorizado. Faça login.',
    code: 'UNAUTHORIZED',
  );

  /// 403 Forbidden
  factory ApiException.forbidden() => const ApiException(
    statusCode: 403,
    message: 'Acesso negado.',
    code: 'FORBIDDEN',
  );

  /// 404 Not Found
  factory ApiException.notFound([String? resource]) => ApiException(
    statusCode: 404,
    message: resource != null
        ? '$resource não encontrado.'
        : 'Recurso não encontrado.',
    code: 'NOT_FOUND',
  );

  /// 409 Conflict
  factory ApiException.conflict([String? message]) => ApiException(
    statusCode: 409,
    message: message ?? 'Conflito de dados.',
    code: 'CONFLICT',
  );

  /// 422 Unprocessable Entity
  factory ApiException.unprocessable([String? message]) => ApiException(
    statusCode: 422,
    message: message ?? 'Dados não puderam ser processados.',
    code: 'UNPROCESSABLE',
  );

  /// 429 Too Many Requests
  factory ApiException.rateLimited() => const ApiException(
    statusCode: 429,
    message: 'Muitas requisições. Aguarde um momento.',
    code: 'RATE_LIMITED',
  );

  /// 500 Internal Server Error
  factory ApiException.serverError() => const ApiException(
    statusCode: 500,
    message: 'Erro interno do servidor.',
    code: 'SERVER_ERROR',
  );

  /// 503 Service Unavailable
  factory ApiException.serviceUnavailable() => const ApiException(
    statusCode: 503,
    message: 'Serviço temporariamente indisponível.',
    code: 'SERVICE_UNAVAILABLE',
  );

  /// Create from HTTP status code
  factory ApiException.fromStatusCode(int statusCode, [String? message]) {
    return switch (statusCode) {
      400 => ApiException.badRequest(message),
      401 => ApiException.unauthorized(),
      403 => ApiException.forbidden(),
      404 => ApiException.notFound(message),
      409 => ApiException.conflict(message),
      422 => ApiException.unprocessable(message),
      429 => ApiException.rateLimited(),
      500 => ApiException.serverError(),
      503 => ApiException.serviceUnavailable(),
      _ => ApiException(
        statusCode: statusCode,
        message: message ?? 'Erro desconhecido',
      ),
    };
  }
}

/// Generic unexpected error (should be rare)
class UnexpectedException extends AppException {
  const UnexpectedException({
    String message = 'Ocorreu um erro inesperado.',
    super.originalError,
    super.stackTrace,
  }) : super(message, code: 'UNEXPECTED');
}

/// Feature not implemented yet
class NotImplementedException extends AppException {
  const NotImplementedException([String? feature])
    : super(
        feature != null
            ? '$feature ainda não está disponível.'
            : 'Funcionalidade em desenvolvimento.',
        code: 'NOT_IMPLEMENTED',
      );
}
