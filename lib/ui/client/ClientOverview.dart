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
                    children: clientState.clients
                        .map(
                          (event) => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: ListTile(
                                leading: Bullet(
                                  color: event.color,
                                ),
                                title: Text(event.name),
                                onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClientDetail(client: event)),
                                      ),
                                    }),
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
