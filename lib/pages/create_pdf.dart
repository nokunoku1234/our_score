import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' ;
import 'package:simple_resumaker/model/model.dart';

class CreatePdf {
  static Future<String> createPdfA4(SaveData saveData) async {
    final Document pdf = Document();

    List<int> blankBarNumber = [];
    saveData.blankBarNumber.forEach((key, value) => blankBarNumber.add(value));

    Future<dynamic> getImage() async{
      final ByteData bytes = await rootBundle.load('assets/image/osorosso_logo.png');
      final Uint8List imageData = bytes.buffer.asUint8List();

      final _image = PdfImage.file(pdf.document, bytes: imageData);
      return _image;
    }

    var image = await getImage();

    Future<dynamic> getFontData() async {
      final ByteData bytes = await rootBundle.load('assets/fonts/ipaexm.ttf');
      final Uint8List fontData = bytes.buffer.asUint8List();

      return Font.ttf(fontData.buffer.asByteData());
    }

    DateTime now = DateTime.now();


    var font = await getFontData();

    pdf.addPage(
      MultiPage(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
        pageFormat: PdfPageFormat.a4,
        orientation: PageOrientation.portrait,
        header: (Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return Container(
            child: Image(image, width: 70)
          );
        },
        build: (Context context) => <Widget>[
          Stack(
            alignment: Alignment.topLeft,
            children: [
              buildTitle(font, saveData.title, saveData.musicKey, saveData.temp),
              Container(
                child: Image(image, width: 70)
              ),
            ]
          ),
          Padding(padding: EdgeInsets.all(15.0)),
          buildBars(saveData, font, blankBarNumber)
        ],
      ),
    );
    Directory _temporaryDirectory = await getTemporaryDirectory();
    String temporaryDirectoryPath = _temporaryDirectory.path;
    String _filePath = '$temporaryDirectoryPath/${saveData.title}.pdf';

    List<int> _pdfSaveData = pdf.save();
    File _file = File(_filePath);
    await _file.writeAsBytes(_pdfSaveData);

    return _filePath;
  }

  static Widget buildLastBar({double width, double height, int barNumber, SaveData saveData, font}) {
    return Column(
        children: [
          Container(
            width: width,
            height: 20,
            child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: width / 2,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(saveData.firstChord[(barNumber + 1).toString()], style: TextStyle(fontSize: 10, font: font))
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: width / 2,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(saveData.laterChord[(barNumber + 1).toString()], style: TextStyle(fontSize: 10, font: font))
                      ),
                    ),
                  ),
                ]
            ),
          ),
          Row(
            children: [
              Column(
                  children: [
                    Container(
                      width: width - 6,
                      height: height,
                      decoration: BoxDecoration(
                        border: BoxBorder(
                          top: true,
                          right: true,
                          bottom: true,
                          left: true,
                        ),
                      ),
                    ),
                    Container(
                      width: width - 6,
                      height: height,
                      decoration: BoxDecoration(
                        border: BoxBorder(
                          top: true,
                          right: true,
                          bottom: true,
                          left: true,
                        ),
                      ),
                    ),
                    Container(
                      width: width - 6,
                      height: height,
                      decoration: BoxDecoration(
                        border: BoxBorder(
                          top: true,
                          right: true,
                          bottom: true,
                          left: true,
                        ),
                      ),
                    ),
                    Container(
                      width: width - 6,
                      height: height,
                      decoration: BoxDecoration(
                        border: BoxBorder(
                          top: true,
                          right: true,
                          bottom: true,
                          left: true,
                        ),
                      ),
                    ),
                  ]
              ),
              Column(
                  children: [
                    Container(
                      width: 3,
                      height: height,
                      decoration: BoxDecoration(
                        border: BoxBorder(
                          top: true,
                          right: true,
                          bottom: true,
                          left: true,
                        ),
                      ),
                    ),
                    Container(
                      width: 3,
                      height: height,
                      decoration: BoxDecoration(
                        border: BoxBorder(
                          top: true,
                          right: true,
                          bottom: true,
                          left: true,
                        ),
                      ),
                    ),
                    Container(
                      width: 3,
                      height: height,
                      decoration: BoxDecoration(
                        border: BoxBorder(
                          top: true,
                          right: true,
                          bottom: true,
                          left: true,
                        ),
                      ),
                    ),
                    Container(
                      width: 3,
                      height: height,
                      decoration: BoxDecoration(
                        border: BoxBorder(
                          top: true,
                          right: true,
                          bottom: true,
                          left: true,
                        ),
                      ),
                    ),
                  ]
              ),
              Container(
                width: 3,
                height: height * 4 + 1,
                color: PdfColor.fromHex('000000')
              )
            ]
          ),
        ]
    );
  }

  static Widget buildDoubleVerticalBar({double width, double height, int barNumber, SaveData saveData, font}) {
    return Column(
        children: [
          Container(
            width: width,
            height: 20,
            child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: width / 2,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(saveData.firstChord[(barNumber + 1).toString()], style: TextStyle(fontSize: 10, font: font))
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: width / 2,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(saveData.laterChord[(barNumber + 1).toString()], style: TextStyle(fontSize: 10, font: font))
                      ),
                    ),
                  ),
                ]
            ),
          ),
          Row(
              children: [
                Column(
                    children: [
                      Container(
                        width: width - 6,
                        height: height,
                        decoration: BoxDecoration(
                          border: BoxBorder(
                            top: true,
                            right: true,
                            bottom: true,
                            left: true,
                          ),
                        ),
                      ),
                      Container(
                        width: width - 6,
                        height: height,
                        decoration: BoxDecoration(
                          border: BoxBorder(
                            top: true,
                            right: true,
                            bottom: true,
                            left: true,
                          ),
                        ),
                      ),
                      Container(
                        width: width - 6,
                        height: height,
                        decoration: BoxDecoration(
                          border: BoxBorder(
                            top: true,
                            right: true,
                            bottom: true,
                            left: true,
                          ),
                        ),
                      ),
                      Container(
                        width: width - 6,
                        height: height,
                        decoration: BoxDecoration(
                          border: BoxBorder(
                            top: true,
                            right: true,
                            bottom: true,
                            left: true,
                          ),
                        ),
                      ),
                    ]
                ),
                Column(
                    children: [
                      Container(
                        width: 6,
                        height: height,
                        decoration: BoxDecoration(
                          border: BoxBorder(
                            top: true,
                            right: true,
                            bottom: true,
                            left: true,
                          ),
                        ),
                      ),
                      Container(
                        width: 6,
                        height: height,
                        decoration: BoxDecoration(
                          border: BoxBorder(
                            top: true,
                            right: true,
                            bottom: true,
                            left: true,
                          ),
                        ),
                      ),
                      Container(
                        width: 6,
                        height: height,
                        decoration: BoxDecoration(
                          border: BoxBorder(
                            top: true,
                            right: true,
                            bottom: true,
                            left: true,
                          ),
                        ),
                      ),
                      Container(
                        width: 6,
                        height: height,
                        decoration: BoxDecoration(
                          border: BoxBorder(
                            top: true,
                            right: true,
                            bottom: true,
                            left: true,
                          ),
                        ),
                      ),
                    ]
                ),
              ]
          ),
        ]
    );
  }


  static Widget buildColumn({double width, double height, int barNumber, SaveData saveData, font}) {
    return Column(
          children: [
            Container(
              width: width,
              height: 20,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: width / 2,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(saveData.firstChord[(barNumber + 1).toString()], style: TextStyle(fontSize: 10, font: font))
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: width / 2,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(saveData.laterChord[(barNumber + 1).toString()], style: TextStyle(fontSize: 10, font: font))
                      ),
                    ),
                  ),
                ]
              ),
            ),
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                border: BoxBorder(
                  top: true,
                  right: true,
                  bottom: true,
                  left: true,
                ),
              ),
            ),
            Container(
              width: width,
              height: 7,
              decoration: BoxDecoration(
                border: BoxBorder(
                  top: true,
                  right: true,
                  bottom: true,
                  left: true,
                ),
              ),
            ),
            Container(
              width: width,
              height: 7,
              decoration: BoxDecoration(
                border: BoxBorder(
                  top: true,
                  right: true,
                  bottom: true,
                  left: true,
                ),
              ),
            ),
            Container(
              width: width,
              height: 7,
              decoration: BoxDecoration(
                border: BoxBorder(
                  top: true,
                  right: true,
                  bottom: true,
                  left: true,
                ),
              ),
            ),
          ]
        );
  }

  static Column buildTitle(font, title, musicKey, temp) {
    return Column(
      children: [
        Center(
          child: Text(title, style: TextStyle(fontSize: 20.0, font: font)),
        ),
        Padding(
          padding: EdgeInsets.all(10)
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                child: (temp == null) ? Text('♩ = ', style: TextStyle(font: font, fontSize: 13)) : Text('♩ = $temp', style: TextStyle(font: font, fontSize: 13)),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text('key = $musicKey', style: TextStyle(font: font, fontSize: 13)),
              ),
            )
          ]
        )
      ]
    );
  }

  static Widget buildBars(SaveData saveData, font, List<int> blankBarNumber) {
    int numberOfRow = 4;
    List<Widget> _listCache = [];
    List<Widget> _listColumn = [];

    for(int i = 0; i < saveData.barNumber; i++) {
      if((i + 1) % numberOfRow == 1 && saveData.labelName[(i + 1).toString()] != "") {
        _listCache.add(
          Padding(
            padding: EdgeInsets.only(top: 20, right: 10),
            child: Container(
              decoration: BoxDecoration(
                border: BoxBorder(
                  top: true,
                  right: true,
                  bottom: true,
                  left: true,
                )
              ),
              width: 50,
              height: 28,
              alignment: Alignment.center,
              child: Text(saveData.labelName[(i + 1).toString()], style: TextStyle(fontSize: 11.0, font: font))
            )
          )
        );
      } else if((i + 1) % numberOfRow == 1 && saveData.labelName[(i + 1).toString()] == "") {
        _listCache.add(
          Padding(
              padding: EdgeInsets.only(top: 20, right: 10),
              child: Container(
                  width: 50,
                  height: 28,
              )
          )
        );
      }
      if(blankBarNumber.contains(i) == false) {
        _listCache.add(
          Builder(
              builder: (context) {
                return Expanded(
                  child: Container(
                      child: (i == saveData.barNumber - 1) ? buildLastBar(width: 130, height: 7, barNumber: i, saveData: saveData, font: font) : selectBar(font: font, saveData: saveData, i: i, height: 7, width: 130, blankBarNumber: blankBarNumber)
                  ),
                );
              }
          )
      );
      } else {
        _listCache.add(
        Builder(
            builder: (context) {
              return Expanded(
                child: Container(),
              );
            }
          )
        );
      }

      if((i + 1) % numberOfRow == 0) {
        _listColumn.add(Row(children: _listCache));
        _listColumn.add(Padding(padding: EdgeInsets.all(15.0)));
        _listCache = [];
      } else if(i + 1 == saveData.barNumber) {
        for(int j = 0; j < numberOfRow - (i + 1) % numberOfRow; j++) {
          _listCache.add(Expanded(child: Container()));

        }
        _listColumn.add(Row(children: _listCache));
      }
    }
    return Column(children: _listColumn);
  }

  static Widget selectBar({int i, SaveData saveData, double width, double height, font, List<int> blankBarNumber}) {
    print(i);
    switch((i + 1) % 4) {
      case 1:
        print('1小節目');
        if(saveData.labelName[(i + 5).toString()] != '' && blankBarNumber.contains(i + 1)) {
          print('複縦線');
          return buildDoubleVerticalBar(width: width, height: height, font: font, barNumber: i, saveData: saveData);
        } else {
          return buildColumn(width: width, height: height, saveData: saveData, barNumber: i, font: font);
        }
        break;
      case 2:
        print('2小節目');
        print(saveData.labelName[(i + 4).toString()]);
        if(saveData.labelName[(i + 4).toString()] != '' && blankBarNumber.contains(i + 1)) {
          print('複縦線');
          return buildDoubleVerticalBar(width: width, height: height, font: font, barNumber: i, saveData: saveData);
        } else {
          return buildColumn(width: width, height: height, saveData: saveData, barNumber: i, font: font);
        }
        break;
      case 3:
        print('3小節目');
        if(saveData.labelName[(i + 3).toString()] != '' && blankBarNumber.contains(i + 1)) {
          print('複縦線');
          return buildDoubleVerticalBar(width: width, height: height, font: font, barNumber: i, saveData: saveData);
        } else {
          return buildColumn(width: width, height: height, saveData: saveData, barNumber: i, font: font);
        }
        break;
      default:
        print('4小節目');
        if(saveData.labelName[(i + 2).toString()] != '') {
          print('複縦線');
          return buildDoubleVerticalBar(width: width, height: height, font: font, barNumber: i, saveData: saveData);
        } else {
          return buildColumn(width: width, height: height, saveData: saveData, barNumber: i, font: font);
        }
        break;
    }

  }

}
