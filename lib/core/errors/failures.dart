import 'package:equatable/equatable.dart';

/// Base Failure สำหรับ Domain Layer
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Server Failure
class ServerFailure extends Failure {
  final int?  statusCode;

  const ServerFailure([
    super.message = 'Server error occurred',
    this.statusCode,
  ]);

  @override
  List<Object?> get props => [message, statusCode];
}

/// Cache Failure
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Network Failure
class NetworkFailure extends Failure {
  const NetworkFailure([super. message = 'No internet connection']);
}

/// Unauthorized Failure
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized access']);
}

/// Not Found Failure
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Unknown Failure
class UnknownFailure extends Failure {
  const UnknownFailure([super. message = 'An unknown error occurred']);
}