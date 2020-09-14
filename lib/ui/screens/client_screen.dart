import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/ui/widgets/Bullet.dart';
import 'package:eventtracker/ui/widgets/Loading.dart';
import 'package:eventtracker/ui/screens/client_detail_screen.dart';
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
              subtitle: 'Nog geen clienten aangemaakt',
            ),
          );
        }
        if (clientState is ClientsLoadSuccess) {
          return Material(
            child: ListView(
              padding: const EdgeInsets.only(top: 12),
                    children: clientState.clients
                        .map(
                          (event) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Card(
                              elevation: 0,
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
