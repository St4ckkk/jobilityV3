import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobility/views/common/exports.dart';

class PDFViewerPage extends StatelessWidget {
  final File file;

  PDFViewerPage({required this.file});

  Future<void> _downloadFile(BuildContext context) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      try {
        final directory = await getApplicationDocumentsDirectory();
        final downloadsDirectory = Directory('${directory.path}/Download');
        if (!downloadsDirectory.existsSync()) {
          downloadsDirectory.createSync(recursive: true);
        }
        final path = '${downloadsDirectory.path}/resume.pdf';
        final newFile = await file.copy(path);

        Navigator.pop(context); // Close the progress dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, semanticLabel: 'Success'),
                SizedBox(width: 10),
                Expanded(child: Text('Downloaded to ${newFile.path}')),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        Navigator.pop(context); // Close the progress dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.red, semanticLabel: 'Error'),
                SizedBox(width: 10),
                Expanded(child: Text('Failed to download file: $e')),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resume Preview'),
        actions: [
          IconButton(
            icon: Icon(Icons.download, semanticLabel: 'Download'),
            onPressed: () => _downloadFile(context),
          ),
        ],
      ),
      body: PDFView(
        filePath: file.path,
      ),
    );
  }
}

Future<File> fetchAndDecodeResume(String base64String) async {
  final bytes = base64Decode(base64.normalize(base64String));
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/resume.pdf');
  await file.writeAsBytes(bytes);
  return file;
}

void openPDFViewer(BuildContext context, File file) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PDFViewerPage(file: file),
    ),
  );
}