import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class CreatePdf {
  static Future<String> createPdfA4(String text1, String text2) async {
    final Document pdf = Document();

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
        header: (Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return Container(
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
                border:
                BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
            child: Text(
              'Portable Document Format',
              style: Theme.of(context)
                  .defaultTextStyle
                  .copyWith(color: PdfColors.grey),
            ),
          );
        },
        build: (Context context) => <Widget>[
          ListView.builder(
            itemBuilder: (Context context, int i) {
              return Column(
                children: [
                  Row(
                    children: [
                      ListView.builder(
                        direction: Axis.horizontal,
                        itemBuilder: (Context context, int i) {
                          return ListView.builder(
                              itemBuilder: (Context context, int i) {
                                return Container(
                                  height: 3 * PdfPageFormat.mm,
                                  width: 45 * PdfPageFormat.mm,
                                  decoration: BoxDecoration(
                                    border: BoxBorder(
                                      top: true,
                                      right: true,
                                      bottom: true,
                                      left: true,
                                    ),
                                  ),
                                );
                              },
                              itemCount: 4
                          );
                        },
                        itemCount: 4
                      )
                    ]
                  ),
                  Padding(
                    padding: EdgeInsets.all(27.0),
                  ),
                ]
              );
            },
            itemCount: 8
          )
        ],
      ),
    );
    Directory _temporaryDirectory = await getTemporaryDirectory();
    String temporaryDirectoryPath = _temporaryDirectory.path;
    String _filePath = '$temporaryDirectoryPath/resume.pdf';

    List<int> _pdfSaveData = pdf.save();
    File _file = File(_filePath);
    await _file.writeAsBytes(_pdfSaveData);

    return _filePath;
  }
}
