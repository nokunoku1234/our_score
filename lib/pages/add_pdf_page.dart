import 'package:flutter/material.dart';
import 'package:simple_resumaker/pages/create_pdf.dart';
import 'package:simple_resumaker/pages/pdf_view.dart';

class AddPdfPage extends StatefulWidget {
  @override
  _AddPdfPageState createState() => _AddPdfPageState();
}

class _AddPdfPageState extends State<AddPdfPage> {

  List<int> barList = [0];

  TextEditingController txtController = TextEditingController();
  TextEditingController txtController2 = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add PDF'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          barList.add(barList.length);
          setState(() {

          });
        },
      ),
    );
  }

  Widget buildBody() {
    int numberOfRow = 4;

    List<Widget> _listColumn = [];
    List<Widget> _listCache = [];

    for(int i = 0; i < barList.length; i++) {
      if((i + 1) % numberOfRow == 1) {
        _listCache.add(
          Container(
            width: 40,
            child: TextField(),
          )
        );
      }
      _listCache.add(
       Builder(
         builder: (context) {
           return Expanded(
             child: Container(
               child: buildColumn(width: 100, height: 7),
             ),
           );
         },
       )
      );
      if((i + 1) % numberOfRow == 0) {
        _listColumn.add(Row(children: _listCache,));
        _listCache = [];
      } else if(i + 1 == barList.length){
        for(int j = 0; j < numberOfRow - (i + 1) % numberOfRow; j++) {
          _listCache.add(
              Expanded(child: Container(),)
          );
        }
        _listColumn.add(Row(children: _listCache,));
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: _listColumn,
        ),
      ),
    );
  }

  Column buildColumn({double width, double height}) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                width: width / 2,
                child: TextField()
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: width / 2,
                child: TextField()
              ),
            ),
          ],
        ),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(),
              right: BorderSide(),
              bottom: BorderSide(),
              left: BorderSide(),
            ),
          ),
        ),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(),
              bottom: BorderSide(),
              left: BorderSide(),
            ),
          ),
        ),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(),
              bottom: BorderSide(),
              left: BorderSide(),
            ),
          ),
        ),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(),
              bottom: BorderSide(),
              left: BorderSide(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(25.0),
        ),
      ],
    );
  }
}
