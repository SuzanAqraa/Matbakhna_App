import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

Future<T> handleWithRetry<T>({
  required Future<T> Function() request,
  required T fallbackValue,
  int maxRetries = 2,
  Duration retryDelay = const Duration(milliseconds: 1)
}) async {
  int attempts = 0;

  while (attempts < maxRetries) {
    debugPrint('Attempt: ${attempts + 1}');

    try {
      final result = await request();
      debugPrint('Request succeeded on attempt: ${attempts + 1}');
      return result;
    } on SocketException catch (_) {
      debugPrint('SocketException on attempt ${attempts + 1}');
    } on TimeoutException catch (_) {
      debugPrint('TimeoutException on attempt ${attempts + 1}');
    } on FirebaseException catch (_) {
      debugPrint('FirebaseException on attempt ${attempts + 1}');
    } catch (e) {
      debugPrint('Unknown exception on attempt ${attempts + 1}: $e');
    }

    attempts++;
    if (attempts < maxRetries) {
      await Future.delayed(retryDelay);
    }
  }

  debugPrint('All $maxRetries attempts failed. Returning fallback value.');
  return fallbackValue;
}