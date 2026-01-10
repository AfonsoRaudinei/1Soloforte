import 'package:flutter_test/flutter_test.dart';
import 'package:soloforte_app/core/error/exceptions.dart';

/// Unit tests for AppException hierarchy.
void main() {
  group('NetworkException', () {
    test('default message is correct', () {
      const e = NetworkException();
      expect(e.message, contains('conexão'));
    });

    test('timeout factory creates correct exception', () {
      final e = NetworkException.timeout();
      expect(e.code, equals('TIMEOUT'));
      expect(e.message, contains('expirou'));
    });

    test('noConnection factory creates correct exception', () {
      final e = NetworkException.noConnection();
      expect(e.code, equals('NO_CONNECTION'));
    });

    test('serverUnreachable factory creates correct exception', () {
      final e = NetworkException.serverUnreachable();
      expect(e.code, equals('SERVER_UNREACHABLE'));
    });

    test('statusCode is captured', () {
      const e = NetworkException(statusCode: 503);
      expect(e.statusCode, equals(503));
    });
  });

  group('AuthException', () {
    test('invalidCredentials factory creates correct exception', () {
      final e = AuthException.invalidCredentials();
      expect(e.code, equals('INVALID_CREDENTIALS'));
      expect(e.message, contains('incorretos'));
    });

    test('sessionExpired factory creates correct exception', () {
      final e = AuthException.sessionExpired();
      expect(e.code, equals('SESSION_EXPIRED'));
    });

    test('userNotFound factory creates correct exception', () {
      final e = AuthException.userNotFound();
      expect(e.code, equals('USER_NOT_FOUND'));
    });

    test('emailInUse factory creates correct exception', () {
      final e = AuthException.emailInUse();
      expect(e.code, equals('EMAIL_IN_USE'));
    });

    test('weakPassword factory creates correct exception', () {
      final e = AuthException.weakPassword();
      expect(e.code, equals('WEAK_PASSWORD'));
    });
  });

  group('ValidationException', () {
    test('can store multiple field errors', () {
      const e = ValidationException({
        'email': 'E-mail inválido',
        'password': 'Senha muito curta',
      });

      expect(e.hasError('email'), isTrue);
      expect(e.hasError('password'), isTrue);
      expect(e.hasError('name'), isFalse);
    });

    test('getError returns correct message', () {
      const e = ValidationException({'email': 'Inválido'});
      expect(e.getError('email'), equals('Inválido'));
      expect(e.getError('password'), isNull);
    });

    test('field factory creates single field error', () {
      final e = ValidationException.field('name', 'Obrigatório');
      expect(e.fieldErrors['name'], equals('Obrigatório'));
    });

    test('required factory creates correct message', () {
      final e = ValidationException.required('email');
      expect(e.fieldErrors['email'], contains('obrigatório'));
    });

    test('invalidEmail factory creates correct error', () {
      final e = ValidationException.invalidEmail();
      expect(e.hasError('email'), isTrue);
    });
  });

  group('StorageException', () {
    test('initFailed factory creates correct exception', () {
      final e = StorageException.initFailed();
      expect(e.code, equals('INIT_FAILED'));
    });

    test('notFound factory includes entity name', () {
      final e = StorageException.notFound('Área');
      expect(e.message, contains('Área'));
    });

    test('writeFailed factory creates correct exception', () {
      final e = StorageException.writeFailed();
      expect(e.code, equals('WRITE_FAILED'));
    });

    test('readFailed factory creates correct exception', () {
      final e = StorageException.readFailed();
      expect(e.code, equals('READ_FAILED'));
    });
  });

  group('ApiException', () {
    test('fromStatusCode creates correct exception for common codes', () {
      expect(ApiException.fromStatusCode(400).code, equals('BAD_REQUEST'));
      expect(ApiException.fromStatusCode(401).code, equals('UNAUTHORIZED'));
      expect(ApiException.fromStatusCode(403).code, equals('FORBIDDEN'));
      expect(ApiException.fromStatusCode(404).code, equals('NOT_FOUND'));
      expect(ApiException.fromStatusCode(500).code, equals('SERVER_ERROR'));
    });

    test('statusCode is captured', () {
      final e = ApiException.badRequest();
      expect(e.statusCode, equals(400));
    });

    test('custom message is captured', () {
      final e = ApiException.badRequest('Campo inválido');
      expect(e.message, contains('inválido'));
    });

    test('rateLimited creates correct exception', () {
      final e = ApiException.rateLimited();
      expect(e.statusCode, equals(429));
      expect(e.code, equals('RATE_LIMITED'));
    });
  });

  group('UnexpectedException', () {
    test('has default message', () {
      const e = UnexpectedException();
      expect(e.message, contains('inesperado'));
    });

    test('captures original error', () {
      final original = Exception('Original error');
      final e = UnexpectedException(originalError: original);
      expect(e.originalError, equals(original));
    });
  });

  group('NotImplementedException', () {
    test('has default message when no feature specified', () {
      const e = NotImplementedException();
      expect(e.message, contains('desenvolvimento'));
    });

    test('includes feature name when specified', () {
      const e = NotImplementedException('Export');
      expect(e.message, contains('Export'));
    });
  });

  group('AppException toString', () {
    test('toString includes exception type and message', () {
      const e = NetworkException(message: 'Test error');
      final str = e.toString();
      expect(str, contains('NetworkException'));
      expect(str, contains('Test error'));
    });
  });
}
