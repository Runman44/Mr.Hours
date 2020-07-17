import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/components/Bullet.dart';
import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/ui/client/ClientEditor.dart';
import 'package:eventtracker/ui/client/ProjectEditor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientDetail extends StatelessWidget {
  final int clientId;

  ClientDetail({Key key, @required this.clientId}) : super(key: key);

  void startAddNewProject(BuildContext context, Client client, Project project) {
    showModalBottomSheet(
      context: context,
      builder: (bCtx) {
        return ProjectEditor(project: project, client: client);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, state) {

        final client = (state as ClientsLoadSuccess)
        .clients
        .firstWhere((element) => element.id == clientId, orElse: () => null);

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(230.0),
            child: AppBar(
              title: Text(
                "Opdrachtgever",
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black,
                      client.color,
                    ],
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(48.0),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 80.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Bullet(
                        color: client.color,
                        mini: true,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        client.name,
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                // action button
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    BlocProvider.of<ClientBloc>(context).add(
                      DeleteClient(client.id),
                    );
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClientEditor(client: client),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          floatingActionButton: FloatingActionButton.extended(
            label: Row(
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Project toevoegen",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            onPressed: () {
              startAddNewProject(context, client, null);
            },
          ),
          body: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 24),
              children: [
                ...getProductList(context, client),
              ]),
        );
      },
    );
  }


  List<Widget> getProductList(BuildContext context, Client client) {
    var clientProjects = client.projects ?? [];
    var projects = clientProjects
        .map((project) => ListTile(
      title: Text(project.name),
      subtitle: Text(
          "€ ${project.centsToDouble().toStringAsFixed(2)} per uur"),
      trailing: Text(
        project.billable ? "Factureerbaar" : "",
      ),
      onTap: () {
        startAddNewProject(context, client, project);
      },
    ))
        .toList();
    return projects;
  }
}
