import 'package:flutter/material.dart';

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
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
