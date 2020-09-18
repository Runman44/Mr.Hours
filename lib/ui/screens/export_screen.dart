import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/ui/screens/export_pfd_screen.dart';
import 'package:eventtracker/ui/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sup/quick_sup.dart';
import 'package:easy_localization/easy_localization.dart';

class ExportPage extends StatefulWidget {
  @override
  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  Client _dropdownValue;
  DateTime _firstDate;
  DateTime _lastDate;
  DateTimeRange _selectedPeriod;
  bool _isButtonEnabled;
  DateFormat _dateFormat = DateFormat("dd-MM-yyyy");

  @override
  void initState() {
    super.initState();
    _firstDate = DateTime(2000);
    _lastDate = DateTime(2999);
    _isButtonEnabled = false;

    DateTime selectedPeriodStart = DateTime.now().subtract(Duration(days: 7));
    DateTime selectedPeriodEnd = DateTime.now();
    _selectedPeriod = DateTimeRange(start: selectedPeriodStart, end: selectedPeriodEnd);
  }

  //TODO only rebuild whats needed to be rebuild.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, clientState) {
        if (clientState is ClientsLoadInProgress) {
          return Loading();
        }
        if (clientState is ClientsLoadEmpty) {
          return Center(
            child: QuickSup.empty(
              subtitle: 'no_customers_warning'.tr(),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(children: [
            Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton(
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down),
                style: Theme.of(context).textTheme.bodyText2,
                disabledHint: Text(""),
                hint: Text("select_customer".tr()),
                value: _dropdownValue,
                onChanged: (newValue) {
                  setState(() {
                    _dropdownValue = newValue;
                    _isButtonEnabled = true;
                  });
                },
                underline: Container(),
                items: (BlocProvider.of<ClientBloc>(context).state
                        as ClientsLoadSuccess)
                    .clients
                    .map<DropdownMenuItem<Client>>((Client value) {
                  return DropdownMenuItem<Client>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Text(
                "choose_period".tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 20),
                  Text(
                    "${_dateFormat.format(_selectedPeriod.start)}",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 20),
                  Text(
                    "${_dateFormat.format(_selectedPeriod.end)}",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: RaisedButton(
                child: Text("select_period".tr()),
                onPressed: () async {
                  final period = await showDateRangePicker(context: context, firstDate: _firstDate, lastDate: _lastDate);
                  if (period != null) {
                    _onSelectedDateChanged(period);
                  }
              },)
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RaisedButton(
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf),
                        SizedBox(width: 20),
                        Text("show_pdf".tr())
                      ],
                    ),
                    onPressed: !_isButtonEnabled
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExportPdfPage(
                                      clientId: _dropdownValue.id,
                                      selectedPeriod: _selectedPeriod)),
                            );
                          },
                  ),
                ],
              ),
            ),
          ]),
        );
      },
    );
  }

  void _onSelectedDateChanged(DateTimeRange newPeriod) {
    setState(() {
      _selectedPeriod = newPeriod;
    });
  }
}
