import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/components/Bullet.dart';
import 'package:eventtracker/ui/client/ClientEditor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ClientBloc clientBloc = BlocProvider.of<ClientBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Opdrachtgever"),
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
          return ListView(
            children: clientState.clients
                .map((event) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: ListTile(
                        leading: Bullet(color: event.color,),
                        title: Text(event.name),
                        onTap: () =>Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ClientEditor(client: event)),
                        ),
                      ),
                    ))
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClientEditor(client: null)),
          );
        },
      ),
    );
  }
}
