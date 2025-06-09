import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

class MultipleErrorsException implements Exception {
  final List<Object> errors;

  MultipleErrorsException(this.errors);

  @override
  String toString() {
    return 'MultipleErrorsException: ${errors.length} errors:\n' +
        errors.map((e) => e.toString()).join('\n');
  }
}

Future<T> handleWithRetry<T>({
  required Future<T> Function() request,
  T? fallbackValue,
  int maxRetries = 2,
  Duration retryDelay = const Duration(milliseconds: 300),
  VoidCallback? onFail,
}) async {
  int attempts = 0;
  List<Object> allErrors = [];

  while (attempts < maxRetries) {
    debugPrint('Attempt: ${attempts + 1}');

    try {
      final result = await request();
      debugPrint('Request succeeded on attempt: ${attempts + 1}');
      return result;
    } on SocketException catch (e) {
      debugPrint('SocketException on attempt ${attempts + 1}');
      allErrors.add(e);
      onFail?.call();
    } on TimeoutException catch (e) {
      debugPrint('TimeoutException on attempt ${attempts + 1}');
      allErrors.add(e);
      onFail?.call();
    } on FirebaseException catch (e) {
      debugPrint('FirebaseException on attempt ${attempts + 1}');
      allErrors.add(e);
      onFail?.call();
    } catch (e) {
      debugPrint('Unknown exception on attempt ${attempts + 1}: $e');
      allErrors.add(e);
      onFail?.call();
    }

    attempts++;
    if (attempts < maxRetries) {
      await Future.delayed(retryDelay);
    }
  }

  debugPrint('All $maxRetries attempts failed.');

  if (fallbackValue != null) {
    debugPrint('Returning fallbackValue after $maxRetries attempts.');
    return fallbackValue;
  }

  if (allErrors.isEmpty) {
    throw Exception('Request failed after $maxRetries attempts without specific error.');
  }

  throw MultipleErrorsException(allErrors);

}
class NetworkUtils {
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}