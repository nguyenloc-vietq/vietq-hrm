// // payroll_detail_widget.dart
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
//
// class PayrollDetailWidget extends StatefulWidget {
//   final String title;
//
//   const PayrollDetailWidget({
//     super.key,
//     this.title = "Payslip",
//   });
//
//   @override
//   State<PayrollDetailWidget> createState() => _PayrollDetailWidgetState();
// }
//
// class _PayrollDetailWidgetState extends State<PayrollDetailWidget> {
//   String pdfUrl = "https://www.orimi.com/pdf-test.pdf";
//   String? localPath;
//   bool isLoading = true;
//   String errorMessage = '';
//
//   final Completer<PDFViewController> _controller = Completer<PDFViewController>();
//   int? totalPages = 0;
//   int currentPage = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _downloadPdf();
//   }
//
//   Future<void> _downloadPdf() async {
//     try {
//       final filename = pdfUrl.split('/').last.split('?').first;
//       final dir = await getTemporaryDirectory();
//       final file = File('${dir.path}/$filename');
//
//       if (!await file.exists()) {
//         final dio = Dio();
//         await dio.download(pdfUrl, file.path);
//       }
//
//       setState(() {
//         localPath = file.path;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Download failed: $e';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title)),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : errorMessage.isNotEmpty
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error, size: 64, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(errorMessage),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   isLoading = true;
//                   errorMessage = '';
//                 });
//                 _downloadPdf();
//               },
//               child: const Text("Thử lại"),
//             ),
//           ],
//         ),
//       )
//           : localPath != null
//           ? Stack(
//         children: [
//           PDFView(
//             // KEY này là "liều thuốc" chữa 99% lỗi iOS
//             key: ValueKey(localPath),
//             filePath: localPath,
//             enableSwipe: true,
//             swipeHorizontal: false,
//             autoSpacing: false,
//             pageFling: true,
//             pageSnap: true,
//             fitPolicy: FitPolicy.BOTH,
//             preventLinkNavigation: false,
//
//             onViewCreated: (PDFViewController pdfViewController) {
//               _controller.complete(pdfViewController);
//             },
//
//             onRender: (pages) {
//               setState(() {
//                 totalPages = pages;
//               });
//             },
//
//             onPageChanged: (int? page, int? total) {
//               setState(() {
//                 currentPage = page ?? 0;
//               });
//             },
//
//             onError: (error) {
//               setState(() {
//                 errorMessage = error.toString();
//               });
//             },
//           ),
//
//           // Hiển thị số trang
//           if (totalPages! > 0)
//             Positioned(
//               bottom: 30,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.black87,
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Text(
//                     "Trang ${currentPage + 1} / $totalPages",
//                     style: const TextStyle(color: Colors.white, fontSize: 15),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       )
//           : const Center(child: Text("Không có file PDF")),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:http/http.dart' as http;

class PayrollDetailWidget extends StatefulWidget {
  const PayrollDetailWidget({super.key});

  @override
  State<PayrollDetailWidget> createState() => _PayrollDetailWidgetState();
}

class _PayrollDetailWidgetState extends State<PayrollDetailWidget> {
  String pdfUrl = "https://www.orimi.com/pdf-test.pdf";

  Future<void> openPdf() async {
    // 1. Tải file PDF
    final response = await http.get(Uri.parse(pdfUrl));
    final bytes = response.bodyBytes;

    // 2. Lưu vào folder tạm thời
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/payroll.pdf');
    await file.writeAsBytes(bytes, flush: true);

    // 3. Mở file bằng ứng dụng mặc định (iOS: Preview)
    await OpenFilex.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: openPdf,
          child: const Text("Mở PDF"),
        ),
      ),
    );
  }
}
