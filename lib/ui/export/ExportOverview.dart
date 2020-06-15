
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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstDate = DateTime(2000);
    _lastDate = DateTime(2999);

    DateTime selectedPeriodStart = DateTime.now().subtract(Duration(days: 7));
    DateTime selectedPeriodEnd = DateTime.now();
    _selectedPeriod = DatePeriod(selectedPeriodStart, selectedPeriodEnd);
  }

  @override
  Widget build(BuildContext context) {
    ClientBloc clientBloc = BlocProvider.of<ClientBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Rapportage"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Theme.of(context).accentColor],
            ),
          ),
        ),
      ),
      body: BlocBuilder<ClientBloc, ClientState>(
        bloc: clientBloc,
        builder: (context, clientState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(children: [
              Text(
                "Kies een opdrachtgever",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField(
                  validator: (Client value) => value == null ? "Selecteer eerst een opdrachtgever" : null,
                    isExpanded: true,
                    disabledHint: Text(""),
                    hint: Text("Selecteer een opdrachtgever"),
                    value: _dropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    style: TextStyle(color: Colors.deepPurple),
                    onChanged: (newValue) {
                      setState(() {
                        _dropdownValue = newValue;
                      });
                    },
                    items: clientBloc.state.clients
                        .map<DropdownMenuItem<Client>>((Client value) {
                      return DropdownMenuItem<Client>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Text(
                "Kies een periode",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildRangeDatePicker(_selectedPeriod, _firstDate,
                    _lastDate, _onSelectedDateChanged),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: RaisedButton(
                  child: Text("Rapportage Maken"),
                  color: Colors.deepPurple,
                  textColor: Colors.white,
                  onPressed: () {
                      bool valid = _formKey.currentState.validate();
                      if (!valid) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ExportPdfPage(clientId: _dropdownValue.id,
                                selectedPeriod: _selectedPeriod)),
                      );
                  },
                ),
              ),
            ]),
          );
        },
      ),
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
