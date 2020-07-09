import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:simple_resumaker/model/model.dart';

class CreatePdf {
  static Future<String> createPdfA4(SaveData saveData) async {
    final Document pdf = Document();

    List<int> blankBarNumber = [];
    saveData.blankBarNumber.forEach((key, value) => blankBarNumber.add(value));


    Future<dynamic> getFontData() async {
      final ByteData bytes = await rootBundle.load('assets/fonts/ipaexm.ttf');
      final Uint8List fontData = bytes.buffer.asUint8List();

      return Font.ttf(fontData.buffer.asByteData());
    }

    DateTime now = DateTime.now();


    var font = await getFontData();

    pdf.addPage(
      MultiPage(
        margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
        pageFormat: PdfPageFormat.a4,
        orientation: PageOrientation.portrait,
//        header: (Context context) {
//          if (context.pageNumber == 1) {
//            return null;
//          }
//          return Container(
//            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//            decoration: const BoxDecoration(
//                border:
//                BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
//            child: Text(
//              'Portable Document Format',
//              style: Theme.of(context)
//                  .defaultTextStyle
//                  .copyWith(color: PdfColors.grey),
//            ),
//          );
//        },
        build: (Context context) => <Widget>[
          buildTitle(font, saveData.title, saveData.musicKey),

          Padding(padding: EdgeInsets.all(20.0)),
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

  static Column buildColumn({double width, double height, int barNumber, SaveData saveData, font}) {
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
                        child: Text(saveData.firstChord[(barNumber + 1).toString()], style: TextStyle(fontSize: 12, font: font))
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: width / 2,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(saveData.laterChord[(barNumber + 1).toString()], style: TextStyle(fontSize: 12, font: font))
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
              width: 100,
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
              width: 100,
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
              width: 100,
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

  static Column buildTitle(font, title, musicKey) {
    return Column(
      children: [
        Center(
          child: Text(title, style: TextStyle(fontSize: 20.0, font: font)),
        ),
        Padding(padding: EdgeInsets.all(10.0)),
        Container(
          alignment: Alignment.centerRight,
          child: Text('key = $musicKey', style: TextStyle(font: font, fontSize: 13)),
        ),
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
            padding: EdgeInsets.only(top: 20, right: 20),
            child: Container(
              decoration: BoxDecoration(
                border: BoxBorder(
                  top: true,
                  right: true,
                  bottom: true,
                  left: true,
                )
              ),
              width: 60,
              height: 28,
              alignment: Alignment.center,
              child: Text(saveData.labelName[(i + 1).toString()], style: TextStyle(fontSize: 15.0, font: font))
            )
          )
        );
      } else if((i + 1) % numberOfRow == 1 && saveData.labelName[(i + 1).toString()] == "") {
        _listCache.add(
          Padding(
              padding: EdgeInsets.only(top: 20, right: 20),
              child: Container(
                  width: 60,
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
                      child: buildColumn(width: 100, height: 7, barNumber: i, saveData: saveData, font: font)
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
        _listColumn.add(Padding(padding: EdgeInsets.all(30.0)));
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

}
