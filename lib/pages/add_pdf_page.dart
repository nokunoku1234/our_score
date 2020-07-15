import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_resumaker/model/model.dart';
import 'package:simple_resumaker/pages/create_pdf.dart';
import 'package:simple_resumaker/pages/pdf_view.dart';
import 'package:simple_resumaker/utils/admob.dart';
import 'package:simple_resumaker/utils/custom_layout.dart';
import 'package:simple_resumaker/utils/db_provider.dart';

class AddPdfPage extends StatefulWidget {

  final SaveData dbData;
  final bool isNew;

  AddPdfPage({this.dbData, this.isNew});

  @override
  _AddPdfPageState createState() => _AddPdfPageState();
}

class _AddPdfPageState extends State<AddPdfPage> {

  List<int> barList = [0];
  List<int> blankBarList = [];
  int numberOfRow = 4;
  double fontSize = 12.0;
  static String scoreMode = 'chord';

  SaveData _saveData;

  final Map<String, dynamic> firstChordMap = {};
  final Map<String, dynamic> laterChordMap = {};
  final Map<String, dynamic> labelNameMap = {};
  final Map<String, dynamic> blankBarMap = {};

  List<String> majorKey = ['', 'C', 'C#', 'D♭', 'D', 'D#', 'E♭', 'E', 'F', 'F#', 'G♭', 'G', 'G#', 'A♭', 'A', 'A#', 'B♭', 'B'];
  List<String> minorKey = ['','Am', 'A#m', 'B♭m', 'Bm', 'Cm', 'C#m', 'D♭m', 'Dm', 'D#m', 'E♭m', 'Em', 'Fm', 'F#m', 'G♭m', 'Gm', 'G#m', 'A♭m'];

  static List<TextEditingController> firstControllerList = [TextEditingController()];
  static List<TextEditingController> laterControllerList = [TextEditingController()];
  static List<TextEditingController> labelControllerList = [TextEditingController()];

  TextEditingController titleController = TextEditingController();
  static TextEditingController musicKeyController = TextEditingController();
  TextEditingController tempController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    clearText();
    if(widget.isNew == false) {
      makeEditList();
    }
    scoreMode = 'chord';
  }

  void makeEditList() {
    barList = List.generate(widget.dbData.barNumber, (i) => i);
    widget.dbData.blankBarNumber.forEach((key, value) => blankBarList.add(value));
    firstControllerList = List.generate(widget.dbData.barNumber, (i) => TextEditingController());
    laterControllerList = List.generate(widget.dbData.barNumber, (i) => TextEditingController());
    labelControllerList = List.generate(widget.dbData.barNumber, (i) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('スコア作成'),
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
            icon: Icon(Icons.cached),
            onPressed: () {
              switch(barList.length % numberOfRow) {
                case 1:
                  int totalBarNum = barList.length + (numberOfRow - 1) + 1;
                  for(int i = 0; i < 3; i++) {
                    blankBarList.add(barList.length + i);
                    firstControllerList.add(TextEditingController());
                    laterControllerList.add(TextEditingController());
                    labelControllerList.add(TextEditingController());
                  }
                  firstControllerList.add(TextEditingController());
                  laterControllerList.add(TextEditingController());
                  labelControllerList.add(TextEditingController());
                  barList = List.generate(totalBarNum, (i) => i);
                  break;
                case 2:
                  int totalBarNum = barList.length + (numberOfRow - 2) + 1;
                  for(int i = 0; i < 2; i++) {
                    blankBarList.add(barList.length + i);
                    firstControllerList.add(TextEditingController());
                    laterControllerList.add(TextEditingController());
                    labelControllerList.add(TextEditingController());
                  }
                  firstControllerList.add(TextEditingController());
                  laterControllerList.add(TextEditingController());
                  labelControllerList.add(TextEditingController());
                  barList = List.generate(totalBarNum, (i) => i);
                  break;
                case 3:
                  int totalBarNum = barList.length + (numberOfRow - 3) + 1;
                  blankBarList.add(barList.length);
                  barList = List.generate(totalBarNum, (i) => i);
                  for(int i = 0; i < 2; i++) {
                    firstControllerList.add(TextEditingController());
                    laterControllerList.add(TextEditingController());
                    labelControllerList.add(TextEditingController());
                  }
                  break;
              }
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.more),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text('記述方法の選択'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text('コード'),
                        onPressed: () {
                          scoreMode = 'chord';
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text('ディグリー'),
                        onPressed: () {
                          scoreMode = 'degree';
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text('ダイアトニック'),
                        onPressed: () {
                          if(musicKeyController.text == '') {
                            scoreMode = 'chord';
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text('エラー'),
                                  content: Text('keyが入力されていません'),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              }
                            );
                          } else if(majorKey.contains(musicKeyController.text) == false && minorKey.contains(musicKeyController.text) == false) {
                            scoreMode = 'chord';
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text('エラー'),
                                  content: Text('正しいkeyが入力されていません'),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              }
                            );
                          } else {
                            scoreMode = 'diatonic';
                            Navigator.pop(context);
                          }
                        },
                      ),

                    ],
                  );
                }
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async{
              if(titleController.text == "" && widget.isNew == true) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text('エラー'),
                      content: Text('タイトルが入力されていません'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  }
                );
              } else if(majorKey.contains(musicKeyController.text) == false && minorKey.contains(musicKeyController.text) == false) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text('エラー'),
                      content: Text('正しいkeyが入力されていません'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  }
                );
              } else {
                makeList();
                createMusic(widget.isNew);
                String _filePath = await CreatePdf.createPdfA4(_saveData);
                await Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewPage(title: _saveData.title, filePath: _filePath,)));
                _saveData = SaveData();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
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
          ),
          AdMob.getBannerContainer(context),
          Container(
            width: double.infinity,
            color: Colors.transparent,
            height: 40,
          ),

        ],
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          notchMargin: 4.0,
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(),
            StadiumBorder(
              side: BorderSide(),
            ),
          ),
          child: Padding(padding: EdgeInsets.all(10.0),)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 400,
        height: 60,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 60,
                child: (barList.length > 1) ? RaisedButton.icon(
                  icon: Icon(Icons.remove),
                  elevation: 10,
                  color: Colors.white,
                  highlightColor: Colors.red,
                  highlightElevation: 0,
                  shape: StadiumBorder(
                      side: BorderSide(color: Colors.red)
                  ),
                  onPressed: () {
                    int _blankBarListLength = blankBarList.length;
                    if(barList.length > 1) {
                      barList.removeLast();
                      firstControllerList.removeLast();
                      laterControllerList.removeLast();
                      labelControllerList.removeLast();

                      for(int i =0; i < _blankBarListLength; i++) {
                        if(blankBarList.contains(barList.length - 1)) {
                          blankBarList.removeLast();
                          barList.removeLast();
                          firstControllerList.removeLast();
                          laterControllerList.removeLast();
                          labelControllerList.removeLast();
                        }
                      }

                      setState(() {});
                    }
                  },
                  label: Text('小節削除'),
                )
                : RaisedButton.icon(
                  icon: Icon(Icons.remove),
                  elevation: 10,
                  color: Colors.white,
                  highlightColor: Colors.red,
                  highlightElevation: 0,
                  shape: StadiumBorder(
                    side: BorderSide(color: Colors.red)
                  ),
                  label: Text('小節削除'),
                )
              ),
            ),
            Padding(padding: EdgeInsets.all(8.0),),
            Expanded(
              child: Container(
                height: 60,
                child: RaisedButton.icon(
                  icon: Icon(Icons.add),
                  elevation: 10,
                  highlightColor: Colors.blue,
                  highlightElevation: 0,
                  color: Colors.white,
                  shape: StadiumBorder(
                      side: BorderSide(color: Colors.blue)
                  ),
                  onPressed: () {
                    barList.add(barList.length);
                    firstControllerList.add(TextEditingController());
                    laterControllerList.add(TextEditingController());
                    labelControllerList.add(TextEditingController());

                    setState(() {});
                  },
                  label: Text('小節追加'),
                ),
              ),
            ),

          ],
        ),
      ),

    );
  }

  void clearText() {
    if(widget.isNew) {
      firstControllerList = [TextEditingController()];
      laterControllerList = [TextEditingController()];
      labelControllerList = [TextEditingController()];
    } else {
      for(int i = 0; i < barList.length; i++) {
        firstControllerList[i].clear();
        laterControllerList[i].clear();
        labelControllerList[i].clear();
      }
    }
    musicKeyController.clear();
  }

  void makeList() {
    if(widget.isNew) {
      for(int i = 0; i < barList.length; i++) {
        firstChordMap[(i + 1).toString()] = firstControllerList[i].text;
        laterChordMap[(i + 1).toString()] = laterControllerList[i].text;
        labelNameMap[(i + 1).toString()] = labelControllerList[i].text;
      }
      for(int j = 0; j < blankBarList.length; j++) {
        blankBarMap[(j + 1).toString()] = blankBarList[j];
      }
    } else {
      (titleController.text != "") ? widget.dbData.title = titleController.text : widget.dbData.title = widget.dbData.title;
      (musicKeyController.text != "") ? widget.dbData.musicKey = musicKeyController.text : widget.dbData.musicKey = widget.dbData.musicKey;
      (tempController.text != "") ? widget.dbData.temp = int.parse(tempController.text) : widget.dbData.temp = widget.dbData.temp;
      for(int i = 0; i < barList.length; i++) {
        (firstControllerList[i].text != "")
            ? firstChordMap[(i + 1).toString()] = firstControllerList[i].text
            : firstChordMap[(i + 1).toString()] = (i + 1 > widget.dbData.barNumber) ? "" : widget.dbData.firstChord[(i + 1).toString()];
        (laterControllerList[i].text != "")
            ? laterChordMap[(i + 1).toString()] = laterControllerList[i].text
            : laterChordMap[(i + 1).toString()] = (i + 1 > widget.dbData.barNumber) ? "" : widget.dbData.laterChord[(i + 1).toString()];
        (labelControllerList[i].text != "")
            ? labelNameMap[(i + 1).toString()] = labelControllerList[i].text
            : labelNameMap[(i + 1).toString()] = (i + 1 > widget.dbData.barNumber) ? "" : widget.dbData.labelName[(i + 1).toString()];
      }
      for(int j = 0; j < blankBarList.length; j++) {
        blankBarMap[(j + 1).toString()] = blankBarList[j];
      }
    }

  }

  void createMusic(bool isNew) async{
    _saveData =  isNew ? SaveData(
      title: titleController.text,
      musicKey: musicKeyController.text,
      temp: (tempController.text == '') ? null : int.parse(tempController.text),
      barNumber: barList.length,
      blankBarNumber: blankBarMap,
      firstChord: firstChordMap,
      laterChord: laterChordMap,
      labelName: labelNameMap,
      date: DateTime.now()
    ) : SaveData(
      title: widget.dbData.title,
      musicKey: widget.dbData.musicKey,
      temp: widget.dbData.temp,
      barNumber: barList.length,
      blankBarNumber: blankBarMap,
      firstChord: firstChordMap,
      laterChord: laterChordMap,
      labelName: labelNameMap,
      date: DateTime.now()
    );

    isNew ? await DbProvider.insertData(_saveData) : await DbProvider.updateData(_saveData, widget.dbData.id);

  }

  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        children: <Widget>[
          Container(
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: widget.isNew ? 'タイトルを入力' : widget.dbData.title,
                  ),
                  textAlign: TextAlign.center,
                  controller: titleController,
                  style: TextStyle(fontSize: 25.0),
                ),
              )
          ),
          Padding(padding: EdgeInsets.only(top: 20),),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(flex: 2, child: Container()),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('♩ = '),
                        Container(
                          height: 15,
                          width: 35,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: fontSize),
                            decoration: InputDecoration(
                              hintText: widget.isNew ? null : widget.dbData.temp.toString(),
                            ),
                            textAlign: TextAlign.center,
                            controller: tempController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                          height: 15,
                          width: 35,
                          child: TextField(
                            readOnly: true,
                            style: TextStyle(fontSize: fontSize),
//                        focusNode: AlwaysDisabledFocusNode(),
                            onTap: () async{
                              await showKeyBoard(whichController: 'musicKey');
                              switch(musicKeyController.text) {
                                case 'C#':
                                  musicKeyController.text = 'D♭';
                                  break;
                                case 'A#m':
                                  musicKeyController.text = 'B♭m';
                                  break;
                                case 'C♭':
                                  musicKeyController.text = 'B';
                                  break;
                                case 'A♭m':
                                  musicKeyController.text = 'G#m';
                                  break;
                                case 'G#':
                                  musicKeyController.text = 'A♭';
                                  break;
                                case 'E#m':
                                  musicKeyController.text = 'Fm';
                                  break;
                                case 'D#':
                                  musicKeyController.text = 'E♭';
                                  break;
                                case 'B#':
                                  musicKeyController.text = 'C';
                                  break;
                                case 'A#':
                                  musicKeyController.text = 'B♭';
                                  break;
                                case 'E#':
                                  musicKeyController.text = 'F';
                                  break;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: widget.isNew ? null : widget.dbData.musicKey,
                            ),
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
          ),
        ],
      ),
    );
  }

  Future<Widget> showKeyBoard({String whichController, int i}) {
    return showModalBottomSheet(
      context: context, builder: (BuildContext context) {
        switch(whichController) {
          case'musicKey':
            return KeyBoard(textEditingController: musicKeyController, type: 'musicKey');
            break;
          case'firstChord_chord':
            return KeyBoard(textEditingController: firstControllerList[i], type: 'chord');
            break;
          case 'firstChord_degree':
            return KeyBoard(textEditingController: firstControllerList[i], type: 'degree');
            break;
          case 'firstChord_diatonic':
            return KeyBoard(textEditingController: firstControllerList[i], type: 'diatonic', whichKey: musicKeyController.text,);
            break;
          case'laterChord_chord':
            return KeyBoard(textEditingController: laterControllerList[i], type: 'chord');
            break;
          case'laterChord_degree':
            return KeyBoard(textEditingController: laterControllerList[i], type: 'degree');
            break;
          case'laterChord_diatonic':
            return KeyBoard(textEditingController: laterControllerList[i], type: 'diatonic', whichKey: musicKeyController.text,);
            break;
          case'label':
            return KeyBoard(textEditingController: labelControllerList[i], type: 'label');
            break;
          default:
            return null;
        }
    });
  }

  Widget buildBars() {
    List<Widget> _listColumn = [];
    List<Widget> _listCache = [];

    for(int i = 0; i < barList.length; i++) {
      if((i + 1) % numberOfRow == 1) {
        _listCache.add(
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Container(
              height: 28,
              width: 40,
              child: TextField(
                readOnly: true,
                style: TextStyle(fontSize: fontSize),
//                focusNode: AlwaysDisabledFocusNode(),
                onTap: () async{
                  await showKeyBoard(whichController: 'label', i: i);
                },
                decoration: InputDecoration(
                  hintText: widget.isNew ? null : widget.dbData.labelName[(i + 1).toString()],
                ),
                textAlign: TextAlign.center,
                controller: labelControllerList[i],
              ),
            ),
          )
        );
      }
      if(blankBarList.contains(i) == false) {
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
      } else {
        _listCache.add(
          Builder(
            builder: (context) {
              return Expanded(
                child: Container(),
              );
            },
          )
        );
      }
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
                padding: EdgeInsets.only(right: 2.0, bottom: 3.0),
                child: Container(
                  width: width / 2,
                  child: TextField(
                    readOnly: true,
                    textAlignVertical: TextAlignVertical.bottom,
                    enabled: true,
                    style: TextStyle(fontSize: fontSize),
//                    focusNode: AlwaysDisabledFocusNode(),
                    onTap: () async{
                      await showKeyBoard(whichController: 'firstChord_$scoreMode', i: barNumber);
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: widget.isNew ? null : widget.dbData.firstChord[(barNumber + 1).toString()],
                    ),
                    controller: firstControllerList[barNumber],
                  )
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(right: 2.0, bottom: 3.0),
                child: Container(
                  width: width / 2,
                  child: TextField(
                    readOnly: true,
                    textAlignVertical: TextAlignVertical.bottom,
                    style: TextStyle(fontSize: fontSize),
//                    focusNode: AlwaysDisabledFocusNode(),
                    onTap: () async{
                      await showKeyBoard(whichController: 'laterChord_$scoreMode', i: barNumber);
                    },
                    decoration: InputDecoration(
                      hintText: widget.isNew ? null : widget.dbData.laterChord[(barNumber + 1).toString()],
                    ),
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
          padding: EdgeInsets.only(bottom: 40.0),
        ),
      ],
    );
  }

}
