import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:simple_resumaker/pages/add_pdf_page.dart';
import 'package:simple_resumaker/pages/create_pdf.dart';
import 'package:simple_resumaker/pages/pdf_view.dart';
import 'package:simple_resumaker/utils/admob.dart';
import 'package:simple_resumaker/utils/db_provider.dart';

import 'model/model.dart';

void main() => runApp(MyApp());
Color primaryColor = Colors.blue;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: setting(),
        builder:(BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return HomePage();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Future<void> setting() async {
    AdMob.deviceData =  await AdMob.getDeviceData();
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
        title: Text('シンプルスコア'),
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
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int i) {
                return Padding(
                  padding: EdgeInsets.only(top: 10.0, right: 20, left: 20),
                  child: Card(
                    child: InkWell(
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        child: ListTile(
                          leading: Container(height: double.infinity, child: Icon(Icons.queue_music, color: primaryColor,)),
                          trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () async{
                              buildShowModalBottomSheet(dbData[i]);
                            },
                          ),
                          title: Text(dbData[i].title),
                        ),
                      ),
                      onTap: () async{
                        String _filePath = await CreatePdf.createPdfA4(dbData[i]);
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewPage(title: dbData[i].title, filePath: _filePath)));
                        setDb();
                      },

                    ),
                  ),
                );
              },
              itemCount: dbData.length,
            ),
          ),
          AdMob.getBannerContainer(context),
          Container(
            width: double.infinity,
            color: Colors.transparent,
            height: 40,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 300,
        height: 50,
        child: RaisedButton.icon(
          icon: Icon(Icons.add),
          elevation: 10,
          highlightColor: Colors.lightBlueAccent,
          highlightElevation: 0,
          color: Colors.white,
//        splashColor: Colors.purple,
          shape: StadiumBorder(
            side: BorderSide(color: primaryColor)
          ),
          onPressed: () async{
            await Navigator.push(context, MaterialPageRoute(builder: (context) => AddPdfPage(isNew: true)));
            setDb();
          },
          label: Text('スコア作成'),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlueAccent,
        notchMargin: 6.0,
        shape: AutomaticNotchedShape(
          RoundedRectangleBorder(),
          StadiumBorder(
            side: BorderSide(),
          ),
        ),
        child: Padding(padding: EdgeInsets.all(10.0),)
      ),
    );
  }




  Future<void> buildShowModalBottomSheet(SaveData saveData) {
    return showModalBottomSheet(
      context: context, builder: (BuildContext context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Flexible(child: Text(saveData.title, style: TextStyle(fontSize: 30,), softWrap: true,)),
                ],
              ),
            ),
            InkWell(
              child: Container(
                height: 70,
                alignment: Alignment.center,
                child: ListTile(
                  leading: Icon(Icons.share, color: primaryColor,),
                  title: Text('共有'),
                ),
              ),
              onTap: () async{
                String _filePath = await CreatePdf.createPdfA4(saveData);
                Navigator.pop(context);
                await FlutterShare.shareFile(
                  title: 'Example share',
                  filePath: _filePath,
                );
              },
            ),
            Divider(height: 0.0, indent: 20, endIndent: 20, thickness: 1,),
            InkWell(
              child: Container(
                height: 70,
                alignment: Alignment.center,
                child: ListTile(
                  leading: Icon(Icons.edit, color: primaryColor,),
                  title: Text('編集'),
                ),
              ),
              onTap: () async{
                Navigator.pop(context);
                await Navigator.push(context, MaterialPageRoute(builder: (context) => AddPdfPage(isNew: false, dbData: saveData)));
                setDb();
              },
            ),
            Divider(height: 0.0, indent: 20, endIndent: 20, thickness: 1,),
            InkWell(
              child: Container(
                height: 70,
                alignment: Alignment.center,
                child: ListTile(
                  leading: Icon(Icons.delete, color: primaryColor,),
                  title: Text('削除'),
                ),
              ),
              onTap: () async{
                Navigator.pop(context);
                await buildShowModalPopup(context, saveData);
                setDb();
              },
            ),
            Divider(height: 0.0, indent: 20, endIndent: 20, thickness: 1,),
          ],
        ),
      );
    });
  }

  Future<void> buildShowModalPopup(BuildContext context, SaveData saveData) {
    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('削除しますか？'),
            content: Text('削除すると復元できません。'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('キャンセル'),
                onPressed: () {
                  Navigator.pop(context);
                  print('==================キャンセルしました');
                },
              ),
              CupertinoActionSheetAction(
                child: Text('削除'),
                onPressed: () async{
                  await DbProvider.deleteData(saveData.id);
                  setDb();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

}
