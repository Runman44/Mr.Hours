import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class ExportPdfPage extends StatefulWidget {
  final int clientId;
  final DatePeriod selectedPeriod;

  ExportPdfPage({Key key, @required this.clientId, @required this.selectedPeriod}) : super(key: key);

  @override
  _ExportPdfPageState createState() => _ExportPdfPageState();
}

class _ExportPdfPageState extends State<ExportPdfPage> {
  String path;
  final pdf = pw.Document();

  @override
  void initState() {
    super.initState();
    loadPdf(widget.clientId, widget.selectedPeriod);
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/example.pdf');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  loadPdf(int id, DatePeriod datePeriod) async {
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          //TODO build good PDF here. based on hours and
          return pw.Center(
            child: pw.Text("Hello World"),
          ); // Center
        })); //
    final localFile = await _localFile;
    await localFile.writeAsBytes(pdf.save());

    setState(() {
      path = localFile.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pdf"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor
              ],
            ),
          ),
        ),
        actions: <Widget>[
          // action button
          Visibility(
            visible: path != null ? true : false,
            child: IconButton(
              icon: Icon(Icons.file_download),
              onPressed: () {

              },
            ),
          ),
        ],
      ),
      body: Container(alignment: Alignment.center, child: pdfView()),
    );
  }

  Widget pdfView() {
    if (path != null) {
      return PdfViewer(
        filePath: path,
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
