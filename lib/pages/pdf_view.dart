import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:simple_resumaker/main.dart';

class PdfViewPage extends StatefulWidget {
  final String filePath;
  final String title;

  PdfViewPage({this.title, this.filePath}) : super();

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.lightBlue,
                Colors.lightBlueAccent,
                Colors.blueAccent
              ]
            )
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              while(Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async{
              await FlutterShare.shareFile(
                title: 'Example share',
                filePath: widget.filePath,
              );
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
