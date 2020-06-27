import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/ui/export/ExportPdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

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

  @override
  Widget build(BuildContext context) {
    ClientBloc clientBloc = BlocProvider.of<ClientBloc>(context);

    return BlocBuilder<ClientBloc, ClientState>(
      bloc: clientBloc,
      builder: (context, clientState) {
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
                items: clientBloc.state.clients
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
                  ButtonTheme(
                    height:50,
                    child: RaisedButton(
                      child: Row(
                        children: [
                          Icon(Icons.picture_as_pdf),
                          SizedBox(width: 20),
                          Text("Toon PDF")
                        ],
                      ),
                      color: Colors.deepPurple,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
                  ),
                ],
              ),
            ),
          ]),
        );
      },
    );
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
