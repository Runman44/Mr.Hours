import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/ui/screens/export_pfd_screen.dart';
import 'package:eventtracker/ui/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:sup/quick_sup.dart';

class ExportPage extends StatefulWidget {
  @override
  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  Client _dropdownValue;
  DateTime _firstDate;
  DateTime _lastDate;
  DatePeriod _selectedPeriod;
  bool _isButtonEnabled;

  @override
  void initState() {
    super.initState();
    _firstDate = DateTime(2000);
    _lastDate = DateTime(2999);
    _isButtonEnabled = false;

    DateTime selectedPeriodStart = DateTime.now().subtract(Duration(days: 7));
    DateTime selectedPeriodEnd = DateTime.now();
    _selectedPeriod = DatePeriod(selectedPeriodStart, selectedPeriodEnd);
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
              subtitle: 'No clients made yet',
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(children: [
            Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton(
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down),
                style: Theme.of(context).textTheme.bodyText2,
                disabledHint: Text(""),
                hint: Text("Selecteer een opdrachtgever"),
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
                "Kies een periode",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: buildRangeDatePicker(_selectedPeriod, _firstDate,
                  _lastDate, _onSelectedDateChanged),
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
                        Text("Toon PDF")
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

  @override
  void dispose() {
    super.dispose();
  }

  void _onSelectedDateChanged(DatePeriod newPeriod) {
    setState(() {
      _selectedPeriod = newPeriod;
    });
  }

  buildRangeDatePicker(DatePeriod selectedPeriod, DateTime firstAllowedDate,
      DateTime lastAllowedDate, ValueChanged<DatePeriod> onNewSelected) {
    return RangePicker(
        selectedPeriod: selectedPeriod,
        onChanged: onNewSelected,
        firstDate: firstAllowedDate,
        lastDate: lastAllowedDate);
  }
}