import 'package:flutter/material.dart';
import 'package:simple_resumaker/pages/create_pdf.dart';
import 'package:simple_resumaker/pages/pdf_view.dart';

class AddPdfPage extends StatefulWidget {
  @override
  _AddPdfPageState createState() => _AddPdfPageState();
}

class _AddPdfPageState extends State<AddPdfPage> {

  TextEditingController txtController = TextEditingController();
  TextEditingController txtController2 = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add PDF'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: txtController,
          ),
          TextField(
            controller: txtController2,
          ),
          RaisedButton(
            child: Text('Create PDF'),
            onPressed: () async{
              String _filePath = await CreatePdf.createPdfA4(txtController.text, txtController2.text);
              Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewPage(filePath: _filePath,)));
            },
          ),
        ],
      ),
    );
  }
}
