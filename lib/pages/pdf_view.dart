import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:simple_resumaker/main.dart';

class PdfViewPage extends StatefulWidget {
  final String filePath;

  PdfViewPage({this.filePath}) : super();

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              while(Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: PDFView(
        filePath: widget.filePath,
        onError: (error) {
          print('error: $error');
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onPageChanged: (int page, int total) {
          print('page change: $page/$total');
        },
      ),
    );
  }
}
