import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

Future<void> openPdf(String pdfUrl, BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
  try {
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/payroll.pdf';

    await Dio().download(pdfUrl, filePath);
    await Future.delayed(const Duration(milliseconds: 300));
    await OpenFilex.open(filePath);
  } catch (e) {
    debugPrint("Error pdf install: $e");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error pdf install: $e')));
  } finally {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
