/// Base Exception สำหรับแอพ
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}

/// Server Exception - เมื่อ API มีปัญหา
class ServerException extends AppException {
  final int?  statusCode;

  const ServerException(
    super.message, {
    super.code,
    this.statusCode,
  });
}

/// Cache Exception - เมื่อ Local Storage มีปัญหา
class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

/// Network Exception - เมื่อไม่มี Internet
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No internet connection',
  ]);
}

/// Unauthorized Exception - เมื่อ Token หมดอายุ
class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Unauthorized access',
  ]);
}

/// Not Found Exception - เมื่อหาข้อมูลไม่เจอ
class NotFoundException extends AppException {
  const NotFoundException([
    super.message = 'Resource not found',
  ]);
}

/// Validation Exception - เมื่อข้อมูลไม่ถูกต้อง
class ValidationException extends AppException {
  final Map<String, String>? errors;

  const ValidationException(
    super.message, {
    super.code,
    this.errors,
  });
}