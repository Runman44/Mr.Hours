import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/components/Bullet.dart';
import 'package:eventtracker/components/Loading.dart';
import 'package:eventtracker/ui/client/ClientDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sup/quick_sup.dart';

class ClientPage extends StatelessWidget {
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
              subtitle: 'No items in this list',
            ),
          );
        }
        if (clientState is ClientsLoadSuccess) {
          return Material(
            child: ListView(
              padding: EdgeInsets.only(top: 12),
                    children: clientState.clients
                        .map(
                          (event) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Card(
                              elevation: 4,
                              child: ListTile(
                                  leading: Bullet(
                                    color: event.color,
                                    mini: true,
                                  ),
                                  title: Text(event.name),
                                  subtitle: Text("projecten ${event.projects.length}"),
                                  onTap: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClientDetail(clientId: event.id)),
                                        ),
                                      }),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          );
        }
        return Center(
          child: QuickSup.error(
            title: "Er is iets mis gegaan",
            onRetry: (){BlocProvider.of<ClientBloc>(context).add(LoadClients());},
            retryText: "Probeer opnieuw",
          ),
        );
      },
    );
  }
}
