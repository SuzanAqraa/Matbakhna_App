import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../network_helpers/network_utils.dart';

Future<void> saveWithOfflineSupport({
  required BuildContext context,
  required Future<String?> Function() saveFunction,
  required VoidCallback onSuccess,
  required VoidCallback onStart,
  required VoidCallback onEnd,
}) async {
  onStart();

  final hasInternet = await InternetConnectionChecker().hasConnection;

  if (!hasInternet) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("لا يوجد اتصال بالإنترنت. سيتم حفظ البيانات عند استعادته."),
          backgroundColor: Colors.orange,
        ),
      );
    }
    onEnd();
    return;
  }

  int attempt = 0;

  try {
    final result = await handleWithRetry<String?>(
      request: () async {
        attempt++;
        return await saveFunction().timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            throw TimeoutException('انتهت مهلة الاتصال.');
          },
        );
      },
      maxRetries: 2,
      fallbackValue: null,
      retryDelay: const Duration(seconds: 2),
      onFail: () {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تعذر حفظ البيانات. سيتم حفظها عند عودة الاتصال."),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
    );

    if (result != null) {
      onSuccess();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: Colors.green),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("فشل الاتصال بالخادم. تأكد من وجود إنترنت وحاول مرة أخرى."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ غير متوقع: $e"), backgroundColor: Colors.red),
      );
    }
  } finally {
    onEnd();
  }
}
