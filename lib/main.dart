import 'package:flutter/material.dart';
import 'package:simple_resumaker/pages/add_pdf_page.dart';
import 'package:simple_resumaker/pages/create_pdf.dart';
import 'package:simple_resumaker/pages/pdf_view.dart';
import 'package:simple_resumaker/utils/db_provider.dart';

import 'model/model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<SaveData> dbData = [];

  Future<void> setDb() async{
    await DbProvider.setDb();
    dbData = await DbProvider.getData();

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();

    setDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Resumaker'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int i) {
          return Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.picture_as_pdf),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddPdfPage(isNew: false, dbData: dbData[i])));
                  },
                ),
                title: Text(dbData[i].title),
                onTap: () async{
                  String _filePath = await CreatePdf.createPdfA4(dbData[i]);
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewPage(filePath: _filePath)));
                  setDb();
                },
              ),
              Divider(height: 0.0,),
            ],
          );
        },
        itemCount: dbData.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(context, MaterialPageRoute(builder: (context) => AddPdfPage(isNew: true)));
          setDb();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
