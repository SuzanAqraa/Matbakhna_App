import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

Future<T> handleWithRetry<T>({
  required Future<T> Function() request,
  required T fallbackValue,
  int maxRetries = 2,
  Duration retryDelay = const Duration(milliseconds: 300),
  VoidCallback? onFail,
}) async {
  int attempts = 0;
  Object? lastError;

  while (attempts < maxRetries) {
    debugPrint('Attempt: ${attempts + 1}');

    try {
      final result = await request();
      debugPrint('Request succeeded on attempt: ${attempts + 1}');
      return result;
    } on SocketException catch (e) {
      debugPrint('SocketException on attempt ${attempts + 1}');
      lastError = e;
    } on TimeoutException catch (e) {
      debugPrint('TimeoutException on attempt ${attempts + 1}');
      lastError = e;
    } on FirebaseException catch (e) {
      debugPrint('FirebaseException on attempt ${attempts + 1}');
      lastError = e;
    } catch (e) {
      debugPrint('Unknown exception on attempt ${attempts + 1}: $e');
      lastError = e;
    }

    attempts++;
    if (attempts < maxRetries) {
      await Future.delayed(retryDelay);
    }
  }

  debugPrint('All $maxRetries attempts failed.');
  if (onFail != null) onFail();

  throw lastError ?? Exception('Request failed after $maxRetries attempts.');
}
