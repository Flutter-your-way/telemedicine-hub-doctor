// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PDFViewerPage extends StatefulWidget {
  final String url;

  const PDFViewerPage({super.key, required this.url});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localPath;
  bool isLoading = true;
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/temp_prescription.pdf';
    final response = await http.get(Uri.parse(widget.url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    setState(() {
      localPath = filePath;
      isLoading = false;
    });
  }

  Future<void> downloadPdf() async {
    setState(() {
      isDownloading = true;
    });

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/prescription_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final response = await http.get(Uri.parse(widget.url));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF downloaded successfully to $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download PDF: $e')),
      );
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localPath!,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              onRender: (pages) {
                setState(() {});
              },
              onError: (error) {
              },
              onPageError: (page, error) {
              },
              onViewCreated: (PDFViewController pdfViewController) {
                // You can save the controller for further use
              },
              onPageChanged: (int? page, int? total) {
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: isDownloading ? null : downloadPdf,
        tooltip: 'Download PDF',
        child: isDownloading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.download),
      ),
    );
  }
}
