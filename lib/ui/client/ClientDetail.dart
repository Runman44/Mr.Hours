import 'package:eventtracker/bloc/ClientBloc.dart';
import 'package:eventtracker/components/Bullet.dart';
import 'package:eventtracker/components/Loading.dart';
import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/ui/client/ClientEditor.dart';
import 'package:eventtracker/ui/client/ProjectEditor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sup/quick_sup.dart';

class ClientDetail extends StatefulWidget {
  final Client client;

  ClientDetail({Key key, @required this.client}) : super(key: key);

  @override
  _ClientDetailState createState() => _ClientDetailState();
}

class _ClientDetailState extends State<ClientDetail> {
  TextEditingController _nameController;
  FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client?.name);
    _focus = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Opdrachtgever",
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor
              ],
            ),
          ),
        ),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final ClientBloc clientBloc =
                  BlocProvider.of<ClientBloc>(context);
              clientBloc.add(
                DeleteClient(widget.client.id),
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
                  builder: (context) => ClientEditor(client: widget.client),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ClientBloc, ClientState>(builder: (context, clientState) {
        if (clientState is ClientsLoadInProgress) {
          return Loading();
        }
        if (clientState is ClientsLoadSuccess) {
          var client = clientState.clients.firstWhere((element) => element.id == widget.client.id);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(shrinkWrap: true, children: [
              ListTile(
                leading: Bullet(
                  color: client.color,
                ),
                title: Text(client.name),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Text("Projecten",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  children: getProductList(client),
                ),
              )
            ]),
          );
        }
        return QuickSup.error(
          title: "fdf",
        );
      }),
    );
  }

  List<Widget> getProductList(Client client) {
    var clientProjects = client.projects ?? [];
    var projects = clientProjects
        .map((project) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                title: Text(project.name),
                subtitle: Text(
                    "€ ${project.centsToDouble().toStringAsFixed(2)} per uur"),
                trailing: Text(
                  project.billable ? "Factureerbaar" : "",
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectEditor(project: project, client: widget.client),
                    ),
                  );
                },
              ),
            ))
        .toList();
    projects.add(
      Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Icon(Icons.add),
                ),
                Text("Project toevoegen"),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectEditor(client: widget.client),
                ),
              );
            },
          ),
        ),
      ),
    );
    return projects;
  }
}
