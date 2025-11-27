import 'dart:io';
import 'package:flutter/material.dart';
import 'exceptions.dart';
import 'failures.dart';

/// Error Handler - แปลง Exception เป็น Failure
class ErrorHandler {
  ErrorHandler._();

  /// แปลง Exception เป็น Failure
  static Failure handleException(dynamic error) {
    if (error is ServerException) {
      return ServerFailure(error.message, error.statusCode);
    }

    if (error is CacheException) {
      return CacheFailure(error.message);
    }

    if (error is NetworkException) {
      return const NetworkFailure();
    }

    if (error is UnauthorizedException) {
      return const UnauthorizedFailure();
    }

    if (error is NotFoundException) {
      return const NotFoundFailure();
    }

    if (error is SocketException) {
      return const NetworkFailure();
    }

    if (error is FormatException) {
      return const ServerFailure('Invalid data format');
    }

    return UnknownFailure(error.toString());
  }

  /// แสดง Error Message ให้ User
  static String getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error.  Please try again later.';
      case NetworkFailure:
        return 'No internet connection. Please check your network. ';
      case CacheFailure:
        return 'Unable to load cached data. ';
      case UnauthorizedFailure:
        return 'Session expired. Please login again.';
      case NotFoundFailure:
        return 'Data not found. ';
      default:
        return failure.message;
    }
  }

  /// แสดง SnackBar Error
  static void showErrorSnackBar(BuildContext context, Failure failure) {
    ScaffoldMessenger.of(context). showSnackBar(
      SnackBar(
        content: Text(getErrorMessage(failure)),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}