import 'package:flutter/material.dart';
import 'package:simple_resumaker/model/model.dart';
import 'package:simple_resumaker/pages/create_pdf.dart';
import 'package:simple_resumaker/pages/pdf_view.dart';
import 'package:simple_resumaker/utils/db_provider.dart';

class AddPdfPage extends StatefulWidget {
  @override
  _AddPdfPageState createState() => _AddPdfPageState();
}

class _AddPdfPageState extends State<AddPdfPage> {

  List<int> barList = [0];
  int numberOfRow = 4;

  SaveData _saveData;

  final Map<String, dynamic> firstChordMap = {};
  final Map<String, dynamic> laterChordMap = {};
  final Map<String, dynamic> labelNameMap = {};

  List<TextEditingController> firstControllerList = [TextEditingController()];
  List<TextEditingController> laterControllerList = [TextEditingController()];
  List<TextEditingController> labelController = [TextEditingController()];

  TextEditingController titleController = TextEditingController();
  TextEditingController musicKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add PDF'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async{
              makeList();
              createMusic();
              print(firstChordMap);
              String _filePath = await CreatePdf.createPdfA4(_saveData);
              await Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewPage(filePath: _filePath,)));
              _saveData = SaveData();
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildTitle(),
              buildBars(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          barList.add(barList.length);
          firstControllerList.add(TextEditingController());
          laterControllerList.add(TextEditingController());
          labelController.add(TextEditingController());

          setState(() {

          });
        },
      ),
    );
  }

  void makeList() {
    for(int i = 0; i < barList.length; i++) {
      firstChordMap[(i + 1).toString()] = firstControllerList[i].text;
      laterChordMap[(i + 1).toString()] = laterControllerList[i].text;
      labelNameMap[(i + 1).toString()] = labelController[i].text;
    }
  }

  void createMusic() async{
    _saveData = SaveData(
        title: titleController.text,
        musicKey: musicKeyController.text,
        barNumber: barList.length,
        firstChord: firstChordMap,
        laterChord: laterChordMap,
        labelName: labelNameMap,
        date: DateTime.now()
    );

    await DbProvider.insertData(_saveData);

  }

  Row buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 2,
          child: Container(
              child: Center(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: titleController,
                  style: TextStyle(fontSize: 25.0),
                ),
              )
          )
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('key = '),
                  Container(
                    height: 10,
                    width: 35,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: musicKeyController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBars() {
    List<Widget> _listColumn = [];
    List<Widget> _listCache = [];

    for(int i = 0; i < barList.length; i++) {
      if((i + 1) % numberOfRow == 1) {
        _listCache.add(
          Container(
            height: 28,
            width: 40,
            child: TextField(
              textAlign: TextAlign.center,
              controller: labelController[i],
            ),
          )
        );
      }
      _listCache.add(
       Builder(
         builder: (context) {
           return Expanded(
             child: Container(
               child: buildColumn(width: 100, height: 7, barNumber: i),
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

  Column buildColumn({double width, double height, int barNumber}) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(right: 5.0, bottom: 3.0),
                child: Container(
                  height: 20,
                  width: width / 2,
                  child: TextField(
                    controller: firstControllerList[barNumber],
                  )
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(right: 5.0, bottom: 3.0),
                child: Container(
                  height: 20,
                  width: width / 2,
                  child: TextField(
                    controller: laterControllerList[barNumber],
                  )
                ),
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
          padding: EdgeInsets.all(11.0),
        ),
      ],
    );
  }

}
