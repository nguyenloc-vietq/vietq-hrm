import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class PayrollDetailWidget extends StatefulWidget {
  final String title;

  const PayrollDetailWidget({
    super.key,
    this.title = "Payslip",
  });

  @override
  State<PayrollDetailWidget> createState() => _PayrollDetailWidgetState();
}

class _PayrollDetailWidgetState extends State<PayrollDetailWidget> {
  String? localPath;
  String pdfUrl = "https://www.orimi.com/pdf-test.pdf";
  int? totalPages = 0;
  int currentPage = 0;
  bool isReady = false;
  bool isLoading = true;
  String errorMessage = '';
  late PDFViewController pdfController;

  @override
  void initState() {
    super.initState();
    downloadAndSavePdf();
  }

  Future<void> downloadAndSavePdf() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final filename = pdfUrl.split('/').last.split('?').first.split('#').last;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename');

      // Nếu đã có file rồi → dùng luôn (cache)
      if (await file.exists()) {
        setState(() {
          localPath = file.path;
          isLoading = false;
        });
        return;
      }

      final dio = Dio();
      await dio.download(
        pdfUrl,
        file.path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print('Download: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      if (await file.exists()) {
        setState(() {
          localPath = file.path;
          isLoading = false;
        });
      } else {
        throw Exception("Download failed");
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      print('PDF Download Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Loading..."),
          ],
        ),
      )
          : errorMessage.isNotEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                downloadAndSavePdf(); // thử lại
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      )
          : localPath != null
          ? Stack(
        children: [
          PDFView(
            filePath: localPath,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            onRender: (pages) {
              setState(() {
                totalPages = pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
            },
            onPageError: (page, error) {
              print('Page $page: $error');
            },
            onViewCreated: (PDFViewController controller) {
              pdfController = controller;
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                currentPage = page ?? 0;
              });
            },
          ),

          // Hiển thị số trang hiện tại góc dưới
          if (isReady)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Page ${currentPage + 1} / $totalPages",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      )
          : const Center(child: Text("Not found!")),
    );
  }
}