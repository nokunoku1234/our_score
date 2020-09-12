import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_resumaker/pages/add_pdf_page.dart';
import 'package:simple_resumaker/pages/create_pdf.dart';
import 'package:simple_resumaker/pages/pdf_view.dart';
import 'package:simple_resumaker/pages/play_music/play_music.dart';
import 'package:simple_resumaker/pages/splash_screen.dart';
import 'package:simple_resumaker/utils/admob.dart';
import 'package:simple_resumaker/utils/db_provider.dart';

import 'model/model.dart';

void main() => runApp(ProviderScope(child: MyApp()));
List<SaveData> dbData = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen()
    );
  }

}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.setDb}) : super(key: key);

  final String title;
  final Function setDb;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> setDb() async{
    await DbProvider.setDb();
    dbData = await DbProvider.getData();

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        title: Text('Our Score', style: TextStyle(fontSize: 25),),
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
      body: dbData.length == 0 ?
      Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              child: Image.asset('assets/image/our_score_bgimage_2.png'),
//              width: MediaQuery.of(context).size.width*0.8,
              height: double.infinity,
            ),
            Padding(
              padding:EdgeInsets.only(bottom: 28.0),
              child: AdMob.getBannerContainer(context),
            ),
          ],
        ),
      )
      : Column(
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
                          leading: Container(height: double.infinity, child: Icon(Icons.queue_music, color: Theme.of(context).primaryColor,)),
                          trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () async{
                              buildShowModalBottomSheet(dbData[i]);
                            },
                          ),
                          title: Text(dbData[i].title),
                        ),
                      ),
                      onLongPress: () async{
                        String _filePath = await CreatePdf.createPdfA4(dbData[i]);
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewPage(title: dbData[i].title, filePath: _filePath)));
                        setDb();
                      },
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PlayMusicPage(), fullscreenDialog: true));
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
            side: BorderSide(color: Theme.of(context).primaryColor)
          ),
          onPressed: () async{
            await Navigator.push(context, MaterialPageRoute(builder: (context) => AddPdfPage(isNew: true)));
            setDb();
          },
          label: Text('スコア作成'),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        color: Colors.lightBlueAccent,
        notchMargin: 6.0,
        shape: AutomaticNotchedShape(
          RoundedRectangleBorder(),
          StadiumBorder(
            side: BorderSide(),
          ),
        ),
        child: Platform.isAndroid ? Padding(padding: EdgeInsets.all(20.0),) : Padding(padding: EdgeInsets.all(10.0))
      ),
    );
  }




  Future<void> buildShowModalBottomSheet(SaveData saveData) {
    return showModalBottomSheet(
      context: context, builder: (BuildContext context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(saveData.title, style: TextStyle(fontSize: 30,)),
            ),
            InkWell(
              child: Container(
                height: 70,
                alignment: Alignment.center,
                child: ListTile(
                  leading: Icon(Icons.share, color: Theme.of(context).primaryColor,),
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
                  leading: Icon(Icons.edit, color: Theme.of(context).primaryColor,),
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
                  leading: Icon(Icons.delete, color: Theme.of(context).primaryColor,),
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
                child: Text('キャンセル', style: TextStyle(color: Colors.red),),
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
