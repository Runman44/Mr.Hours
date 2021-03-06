import 'package:eventtracker/view/bloc/ClientBloc.dart';
import 'package:eventtracker/view/ui/widgets/Bullet.dart';
import 'package:eventtracker/view/ui/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sup/quick_sup.dart';
import 'package:easy_localization/easy_localization.dart';

import 'client_detail_screen.dart';

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
              subtitle: 'no_customers_warning'.tr(),
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
                                  subtitle: Text("amount_of_projects".tr(args: [event.projects.length.toString()])),
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
            title: "something_went_wrong".tr(),
            onRetry: (){BlocProvider.of<ClientBloc>(context).add(LoadClients());},
            retryText: "try_again".tr(),
          ),
        );
      },
    );
  }
}
