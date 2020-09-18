import 'dart:io';

import 'package:eventtracker/bloc/pdf_bloc.dart';
import 'package:eventtracker/bloc/settings_bloc.dart';
import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/ui/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:share/share.dart';
import 'package:sup/quick_sup.dart';
import 'package:easy_localization/easy_localization.dart';

class ExportPdfPage extends StatefulWidget {
  final int clientId;
  final DateTimeRange selectedPeriod;

  ExportPdfPage(
      {Key key, @required this.clientId, @required this.selectedPeriod})
      : super(key: key);

  @override
  _ExportPdfPageState createState() => _ExportPdfPageState();
}

class _ExportPdfPageState extends State<ExportPdfPage> {
  String path;
  final pdf = pw.Document();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PdfBloc>(context).add(CreatePdf(widget.selectedPeriod));
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/registration-${DateTime.now().toString()}.pdf');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  PdfImage _logo;

  loadPdf(int id, List<DashboardItem> bookings, File logo) async {
    try {
      _logo = PdfImage.file(
        pdf.document,
        bytes: (await rootBundle.load(logo.path)).buffer.asUint8List(),
      );
    } catch (e) {
      //NO-OP
    }

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) =>
      [
        _contentHeader(context),
        pw.SizedBox(height: 20),
        _contentTable(context, bookings),
        pw.SizedBox(height: 20),
        pw.DefaultTextStyle(
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('total'.tr() + ":"),
              pw.Text(minutesToUIStringz(bookings
                  .map<int>((e) => e.totalMinutes())
                  .reduce((value, element) => value + element))),
            ],
          ),
        ),
      ],
    )); //
    final localFile = await _localFile;
    await localFile.writeAsBytes(pdf.save());

    setState(() {
      path = localFile.path;
    });
  }

  String minutesToUIStringz(int minutes) {
    Duration duration = Duration(minutes: minutes);
    List<String> parts = duration.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("pdf".tr()),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme
                    .of(context)
                    .primaryColor,
                Theme
                    .of(context)
                    .accentColor
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
                Share.shareFiles(['$path'], text: 'hour_registration'.tr());
              },
            ),
          ),
        ],
      ),
      body: Container(alignment: Alignment.center, child: pdfView()),
    );
  }

  Widget pdfView() {
    return BlocBuilder<PdfBloc, PdfState>(builder: (context, pdfState) {
      if (pdfState is PdfLoadInProgress) {
        return Loading();
      }
      if (pdfState is PdfLoadSuccess) {
        if (path != null) {
          return PdfViewer(
            filePath: path,
          );
        } else {
          return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, settingsState) {
            loadPdf(widget.clientId, pdfState.bookings, settingsState.settings.logo);
            return Loading();
          });
        }
      }
      return Center(
        child: QuickSup.error(
          title: "something_went_wrong".tr(),
        ),
      );
    });
  }


  pw.Widget _contentHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              height: 50,
              padding: const pw.EdgeInsets.only(left: 20),
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(
                'hour_registration'.tr(),
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
                    height: 72,
                    child: _logo != null ? pw.Image(_logo) : pw.Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context, List<DashboardItem> bookings) {
    var tableHeaders = ['date'.tr(), 'project'.tr(), 'tasks'.tr(), 'hour'.tr()];

    String getValue(DashboardItem booking, int col) {
      switch (col) {
        case 0:
          return DateFormat("dd-MM-yyyy").format(booking.startDateTime);
        case 1:
          return booking.projectName;
        case 2:
          return booking.tasks;
        case 3:
          return booking.minutesToUIString();
      }
      return '';
    }

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: 2,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: PdfColors.black,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: PdfColors.black,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.BoxBorder(
          bottom: true,
          color: PdfColors.teal,
          width: .5,
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
            (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        bookings.length,
            (row) =>
        List<String>.generate(
            tableHeaders.length, (col) => getValue(bookings[row], col)),
      ),
    );
  }
}
