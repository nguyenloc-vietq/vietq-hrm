import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

Future<void> downloadAndShareFile(String fileUrl, String fileName, BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
  try {
    final dir = await getTemporaryDirectory();

    if (Platform.isIOS) {
      final filePath = '${dir.path}/$fileName';

      // Tải file
      await Dio().download(fileUrl, filePath);
      await Share.shareXFiles([XFile(filePath)], text: "Share PDF");
    } else {
      Directory? downloadsDir;

      if (Platform.isAndroid && await androidMajorVersion() >= 30) {
        downloadsDir = await getExternalStorageDirectory();
        final filePath = '/storage/emulated/0/Download/payroll-vietq/$fileName';
        await Dio().download(fileUrl, filePath);
        debugPrint("File đã lưu vào: $filePath");
      } else{
        if (await checkStoragePermission()) {
          if (Platform.version.startsWith('Android 10') ||
              int.parse(Platform.version.split(' ')[0]) >= 10) {
            downloadsDir = Directory('/storage/emulated/0/Download');
          } else {
            downloadsDir = await getExternalStorageDirectory();
          }

          final filePath = '${downloadsDir!.path}/$fileName';
          await Dio().download(fileUrl, filePath);
          debugPrint("File đã lưu vào: $filePath");
        }
        else {
          debugPrint("Không có quyền ghi bộ nhớ");
        }
      }
    }
  } catch (e) {
    debugPrint("Error pdf install: $e");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error pdf install: $e')));
  } finally {
    Navigator.of(context, rootNavigator: true).pop();
  }
}




Future<bool> checkStoragePermission() async {
  var status = await Permission.storage.status;
  print("#==========> ${status.isGranted}");
  if (!status.isGranted) {
    print("#==========> Chay vao day}");
    status = await Permission.manageExternalStorage.request();
  }
  return status.isGranted;
}

Future<int> androidMajorVersion() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  print(androidInfo.version.sdkInt);
  return androidInfo.version.sdkInt;
}
