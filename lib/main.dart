import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/service/auth.dart';
import 'package:eventtracker/themes.dart';
import 'package:eventtracker/ui/login/AuthenticationWrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'bloc/ClientBloc.dart';
import 'bloc/UserBloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
//  SystemChrome.setPreferredOrientations([
//    DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown,
//  ]);

  initializeDateFormatting().then((_) => runApp(MultiBlocProvider(
        providers: [
          BlocProvider<ClientBloc>(
            create: (_) => ClientBloc(),
          ),
          BlocProvider<UserBloc>(
            create: (_) => UserBloc(),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(
              clientBloc: BlocProvider.of<ClientBloc>(context),
            ),
          ),
        ],
        child: DevicePreview(
          enabled: !kReleaseMode,
          builder: (context) => TimeApp(),
        ),
//    child: TimeApp(),
      )));
}

class TimeApp extends StatefulWidget {
  @override
  _TimeAppState createState() => _TimeAppState();
}

class _TimeAppState extends State<TimeApp> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(LoadUser());
    BlocProvider.of<ClientBloc>(context).add(LoadClient());
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: MaterialApp(
          locale: DevicePreview.of(context).locale,
          // <--- Add the locale
          builder: DevicePreview.appBuilder,
          // <--- Add the builder
          title: 'Pyre',
          theme: lightTheme,
          home: AuthenticationWrapper()),
    );
  }
}


abstract class DashboardEvent {
  const DashboardEvent();
}

class HoursUpdated extends DashboardEvent {
  final List<Client> clients;

  const HoursUpdated(this.clients);
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ClientBloc clientBloc;
  StreamSubscription dataSubscription;

  DashboardBloc({@required this.clientBloc}) {
    dataSubscription = clientBloc.listen((state) {
      if (clientBloc.state.clients.isNotEmpty) {
        add(HoursUpdated(clientBloc.state.clients));
      }
    });
  }

  @override
  DashboardState get initialState {
    return clientBloc.state.clients.isNotEmpty
        ? DashboardLoadSuccess(
            clientBloc.state.clients,
          )
        : DashboardLoadInProgress();
  }

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (clientBloc.state.clients.isNotEmpty) {
      yield DashboardLoadSuccess(
        clientBloc.state.clients,
      );
    }
  }

  @override
  Future<void> close() {
    dataSubscription.cancel();
    return super.close();
  }
}

abstract class DashboardState {
  const DashboardState();
}

class DashboardLoadInProgress extends DashboardState {}

class DashboardLoadSuccess extends DashboardState {
  final List<Client> clients;

  DashboardLoadSuccess(this.clients);
}
